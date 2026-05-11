import 'package:supabase_flutter/supabase_flutter.dart';
import '../../job/models/job_model.dart';
import '../models/event_model.dart';

class HomeService {
  final _supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> fetchHomeData() async {
    // ── 1. Fetch nama user ────────────────────────────────────────────────
    final user = _supabase.auth.currentUser;
    String name = user?.userMetadata?['full_name'] ?? 'User DCC';
    final String email = user?.email ?? '';

    try {
      final pelamarData = await _supabase
          .from('pelamar')
          .select('nama_lengkap')
          .eq('email', email)
          .maybeSingle();

      if (pelamarData != null) {
        name = pelamarData['nama_lengkap'] ?? name;
      } else {
        final profileData = await _supabase
            .from('profiles')
            .select('full_name')
            .eq('email', email)
            .maybeSingle();
        if (profileData != null) {
          name = profileData['full_name'] ?? name;
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('[HomeService] Error fetching user name: $e');
    }

    // ── 2. Fetch recommended jobs dari Supabase ───────────────────────────
    List<JobModel> recommendedJobs = [];
    try {
      final response = await _supabase.from('lowongan').select('''
        *,
        perusahaan ( nama_perusahaan, kota, alamat_perusahaan ),
        jabatan ( nama ),
        jurusan ( nama ),
        tipe_pekerjaan ( nama ),
        sektor ( nama )
      ''').eq('status_loker', 'aktif').limit(5);

      // ignore: avoid_print
      print('[HomeService] Fetched ${(response as List).length} lowongan');

      recommendedJobs = (response as List)
          .map((data) => JobModel.fromMap(data as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // ignore: avoid_print
      print('[HomeService] Error fetching recommended jobs: $e');
    }

    return {
      'userName': name,
      'profileCompleteness': 0.75,
      'recommendedJobs': recommendedJobs,
      'upcomingEvent': Event(
        title: 'Tech Career Expo 2024',
        date: 'Oct 24, 2024',
        time: '10:00 AM',
        type: 'LIVE WEBINAR',
      ),
    };
  }
}
