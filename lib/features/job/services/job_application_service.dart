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

  Future<String?> uploadFile(String bucket, String path, File file) async {
    try {
      final String fullPath = '${AuthService.currentUser!.id}/$path';
      await _supabase.storage.from(bucket).upload(fullPath, file, fileOptions: const FileOptions(upsert: true));
      return _supabase.storage.from(bucket).getPublicUrl(fullPath);
    } catch (e) {
      appLog('Error uploading file: $e');
      return null;
    }
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

    final pelamarId = user.id;

    try {
      // Guard against duplicate applications before uploading any files —
      // cheaper, and avoids creating orphaned berkas/storage objects.
      final existing = await _supabase
          .from('lamaran')
          .select('lamaran_id')
          .eq('pelamar_id', pelamarId)
          .eq('lowongan_id', lowonganId)
          .limit(1);
      if ((existing as List).isNotEmpty) {
        return ApplicationResult.alreadyApplied;
      }

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
      }).select().single();

      final berkasId = berkasResponse['berkas_lamaran_id'];

      // 2. Insert into lamaran. The Supabase client cannot run a true
      // multi-statement transaction, so if this fails we manually roll back
      // the berkas_lamaran row to avoid an orphan record.
      try {
        await _supabase.from('lamaran').insert({
          'lowongan_id': lowonganId,
          'pelamar_id': pelamarId,
          'berkas_lamaran_id': berkasId,
          'status_terakhir': 'applied',
        });
      } catch (e) {
        appLog('Error inserting lamaran, rolling back berkas_lamaran: $e');
        await _rollbackBerkas(berkasId);
        return ApplicationResult.failure;
      }

      return ApplicationResult.success;
    } catch (e) {
      appLog('Error submitting application: $e');
      return ApplicationResult.failure;
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
}
