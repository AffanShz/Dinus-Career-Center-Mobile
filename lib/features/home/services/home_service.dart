import 'package:dcc_mobile/core/utils/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../job/models/job_model.dart';
import '../models/event_model.dart';

class HomeService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchHomeData() async {
    // ── Fetch recommended jobs dari Supabase ──────────────────────────────
    // Profil di-fetch terpisah oleh ProfileBloc (sumber tunggal profil).
    List<JobModel> recommendedJobs = [];
    try {
      final user = _supabase.auth.currentUser;
      final String today = DateTime.now().toIso8601String().split('T')[0];
      final response = await _supabase.from('lowongan').select('''
        *,
        perusahaan ( nama_perusahaan, kota, alamat_perusahaan, logo ),
        jabatan ( nama ),
        jurusan ( nama ),
        tipe_pekerjaan ( nama ),
        sektor ( nama )
      ''')
      .eq('status_loker', 'aktif')
      .or('batas_akhir.is.null,batas_akhir.gte.$today')
      .limit(5);

      // ignore: avoid_print
      appLog('[HomeService] Fetched ${(response as List).length} lowongan');

      Set<String> appliedJobIds = {};
      if (user != null) {
        final applications = await _supabase
            .from('lamaran')
            .select('lowongan_id')
            .eq('pelamar_id', user.id);
        
        appliedJobIds = (applications as List)
            .map((a) => a['lowongan_id'].toString())
            .toSet();
      }

      recommendedJobs = (response as List).map((data) {
        final String lowonganId = data['lowongan_id'].toString();
        final Map<String, dynamic> mutableData = Map<String, dynamic>.from(data);
        mutableData['is_applied'] = appliedJobIds.contains(lowonganId);
        return JobModel.fromMap(mutableData);
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      appLog('[HomeService] Error fetching recommended jobs: $e');
    }

    return {
      'recommendedJobs': recommendedJobs,
      'upcomingEvent': Event(
        title: 'Dinus Career Center Job Fair 2027',
        date: '15-16 Juni 2027',
        time: '08:00 - 16:00 WIB',
        type: 'JOB FAIR',
      ),
    };
  }
}
