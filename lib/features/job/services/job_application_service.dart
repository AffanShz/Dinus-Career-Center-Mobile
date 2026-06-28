import 'dart:async';
import 'dart:io';

import 'package:dcc_mobile/core/utils/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/services/auth_service.dart';

/// Outcome of [JobApplicationService.submitApplication], so the UI can show a
/// precise message instead of a generic success/failure.
enum ApplicationResult {
  /// Application (and its files) were saved successfully.
  success,

  /// The user has already applied to this lowongan.
  alreadyApplied,

  /// No authenticated user.
  notLoggedIn,

  /// Upload or database error.
  failure,
}

class JobApplicationService {
  final _supabase = Supabase.instance.client;

  /// Per-lowongan mutex: prevents a second submit from entering the
  /// critical section while the first is still uploading files.
  final Map<String, Completer<void>> _submitLocks = {};

  /// Uploads [file] to [bucket]/[path] and returns the public URL.
  ///
  /// Throws on failure so the caller can abort the application instead of
  /// silently inserting a record with a null file URL.
  Future<String> uploadFile(String bucket, String path, File file) async {
    final String fullPath = '${AuthService.currentUser!.id}/$path';
    await _supabase.storage.from(bucket).upload(
      fullPath,
      file,
      fileOptions: const FileOptions(upsert: true),
    );
    return _supabase.storage.from(bucket).getPublicUrl(fullPath);
  }

  Future<ApplicationResult> submitApplication({
    required String lowonganId,
    File? pasFoto,
    File? cv,
    File? portofolioFile,
    String? portofolioLink,
    File? transkipNilai,
    File? suratLamaran,
  }) async {
    final user = AuthService.currentUser;
    if (user == null) {
      appLog('User not logged in');
      return ApplicationResult.notLoggedIn;
    }

    // ── Bug #4 fix: per-lowongan mutex ──
    // If a submit for the same lowongan is already in-flight, wait for it
    // to finish first. This closes the TOCTOU window between the duplicate
    // check and the final INSERT.
    if (_submitLocks.containsKey(lowonganId)) {
      appLog('DEBUG: Waiting for in-flight submit for lowongan $lowonganId');
      await _submitLocks[lowonganId]!.future;
    }
    final lock = Completer<void>();
    _submitLocks[lowonganId] = lock;

    final pelamarId = user.id;

    try {
      // Guard against duplicate applications before uploading any files —
      // cheaper, and avoids creating orphaned berkas/storage objects.
      final existing = await _supabase
          .from('lamaran')
          .select('lamaran_id, status_terakhir')
          .eq('pelamar_id', pelamarId)
          .eq('lowongan_id', lowonganId)
          .maybeSingle();

      bool isReapply = false;
      String? existingLamaranId;

      if (existing != null) {
        if (existing['status_terakhir'] == 'cancelled') {
          isReapply = true;
          existingLamaranId = existing['lamaran_id']?.toString();
        } else {
          return ApplicationResult.alreadyApplied;
        }
      }

      // ── Bug #5 fix: upload failures now throw ──
      // uploadFile() no longer swallows errors. If a provided file fails
      // to upload, the exception propagates here and the application is
      // aborted — preventing a record with null file URLs.
      String? pasFotoUrl;
      if (pasFoto != null) {
         pasFotoUrl = await uploadFile('berkas-lamaran', 'pas_foto_${DateTime.now().millisecondsSinceEpoch}.jpg', pasFoto);
      }
      String? cvUrl;
      if (cv != null) {
         cvUrl = await uploadFile('berkas-lamaran', 'cv_${DateTime.now().millisecondsSinceEpoch}.pdf', cv);
      }
      String? portofolioUrl;
      if (portofolioFile != null) {
         portofolioUrl = await uploadFile('berkas-lamaran', 'portofolio_${DateTime.now().millisecondsSinceEpoch}.pdf', portofolioFile);
      } else if (portofolioLink != null && portofolioLink.isNotEmpty) {
         portofolioUrl = portofolioLink;
      }
      String? transkipNilaiUrl;
      if (transkipNilai != null) {
         transkipNilaiUrl = await uploadFile('berkas-lamaran', 'transkip_${DateTime.now().millisecondsSinceEpoch}.pdf', transkipNilai);
      }
      String? suratLamaranUrl;
      if (suratLamaran != null) {
         suratLamaranUrl = await uploadFile('berkas-lamaran', 'surat_lamaran_${DateTime.now().millisecondsSinceEpoch}.pdf', suratLamaran);
      }

      // 1. Insert into berkas_lamaran
      final berkasResponse = await _supabase.from('berkas_lamaran').insert({
        'pelamar_id': pelamarId,
        'pas_foto': pasFotoUrl,
        'cv': cvUrl,
        'portofolio': portofolioUrl,
        'transkip_nilai': transkipNilaiUrl,
        'surat_lamaran': suratLamaranUrl,
      }).select().maybeSingle();

      if (berkasResponse == null) {
        throw Exception('Gagal menyimpan berkas lamaran');
      }

      final berkasId = berkasResponse['berkas_lamaran_id'];

      // 2. Insert or Update into lamaran
      try {
        if (isReapply && existingLamaranId != null) {
          await _supabase.from('lamaran').update({
            'berkas_lamaran_id': berkasId,
            'status_terakhir': 'applied',
          }).eq('lamaran_id', existingLamaranId);
        } else {
          await _supabase.from('lamaran').insert({
            'lowongan_id': lowonganId,
            'pelamar_id': pelamarId,
            'berkas_lamaran_id': berkasId,
            'status_terakhir': 'applied',
          });
        }
      } catch (e) {
        appLog('Error upserting lamaran, rolling back berkas_lamaran: $e');
        await _rollbackBerkas(berkasId);
        return ApplicationResult.failure;
      }

      return ApplicationResult.success;
    } catch (e) {
      appLog('Error submitting application: $e');
      return ApplicationResult.failure;
    } finally {
      // Always release the lock so subsequent attempts can proceed.
      _submitLocks.remove(lowonganId);
      lock.complete();
    }
  }

  /// Best-effort cleanup of an orphaned berkas_lamaran row.
  Future<void> _rollbackBerkas(dynamic berkasId) async {
    try {
      await _supabase
          .from('berkas_lamaran')
          .delete()
          .eq('berkas_lamaran_id', berkasId);
    } catch (e) {
      appLog('Failed to roll back berkas_lamaran $berkasId: $e');
    }
  }

  /// Membatalkan lamaran dengan mengubah status_terakhir menjadi 'canceled'
  Future<bool> cancelApplication(String lowonganId) async {
    final user = AuthService.currentUser;
    if (user == null) {
      appLog('User not logged in');
      return false;
    }

    try {
      await _supabase
          .from('lamaran')
          .update({'status_terakhir': 'cancelled'})
          .eq('lowongan_id', lowonganId)
          .eq('pelamar_id', user.id);
      return true;
    } catch (e) {
      appLog('Error cancelling application: $e');
      return false;
    }
  }
}
