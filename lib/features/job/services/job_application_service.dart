import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../auth/services/auth_service.dart';

class JobApplicationService {
  final _supabase = Supabase.instance.client;

  Future<String?> uploadFile(String bucket, String path, File file) async {
    try {
      final String fullPath = '${AuthService.currentUser!.id}/$path';
      await _supabase.storage.from(bucket).upload(fullPath, file, fileOptions: const FileOptions(upsert: true));
      return _supabase.storage.from(bucket).getPublicUrl(fullPath);
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<bool> submitApplication({
    required String lowonganId,
    File? pasFoto,
    File? cv,
    File? portofolioFile,
    String? portofolioLink,
    File? transkipNilai,
    File? suratLamaran,
    String? catatan,
  }) async {
    try {
      final user = AuthService.currentUser;
      if (user == null) {
        print('User not logged in');
        return false;
      }

      final pelamarId = user.id;

      String? pasFotoUrl;
      if (pasFoto != null) {
         pasFotoUrl = await uploadFile('berkas', 'pas_foto_${DateTime.now().millisecondsSinceEpoch}.jpg', pasFoto);
      }
      String? cvUrl;
      if (cv != null) {
         cvUrl = await uploadFile('berkas', 'cv_${DateTime.now().millisecondsSinceEpoch}.pdf', cv);
      }
      String? portofolioUrl;
      if (portofolioFile != null) {
         portofolioUrl = await uploadFile('berkas', 'portofolio_${DateTime.now().millisecondsSinceEpoch}.pdf', portofolioFile);
      } else if (portofolioLink != null && portofolioLink.isNotEmpty) {
         portofolioUrl = portofolioLink;
      }
      String? transkipNilaiUrl;
      if (transkipNilai != null) {
         transkipNilaiUrl = await uploadFile('berkas', 'transkip_${DateTime.now().millisecondsSinceEpoch}.pdf', transkipNilai);
      }
      String? suratLamaranUrl;
      if (suratLamaran != null) {
         suratLamaranUrl = await uploadFile('berkas', 'surat_lamaran_${DateTime.now().millisecondsSinceEpoch}.pdf', suratLamaran);
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

      // 2. Insert into lamaran
      await _supabase.from('lamaran').insert({
        'lowongan_id': lowonganId,
        'pelamar_id': pelamarId,
        'berkas_lamaran_id': berkasId,
        'status_terakhir': 'applied',
        'catatan': catatan,
      });

      return true;
    } catch (e) {
      print('Error submitting application: $e');
      return false;
    }
  }
}
