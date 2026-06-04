import 'package:supabase_flutter/supabase_flutter.dart';
import '../../job/models/job_model.dart';
import '../../profile/models/profile_model.dart';
import '../../profile/services/profile_service.dart';
import '../models/event_model.dart';

class HomeService {
  final _supabase = Supabase.instance.client;
  final _profileService = ProfileService();

  Future<Map<String, dynamic>> fetchHomeData() async {
    // ── 1. Fetch profile and calculate completeness ───────────────────────
    double completeness = 0.0;
    String name = 'User DCC';
    UserProfile? userProfile;
    try {
      userProfile = await _profileService.fetchUserProfile();
      name = userProfile.name;
      completeness = userProfile.completionPercentage;
    } catch (e) {
      // ignore: avoid_print
      print('[HomeService] Error fetching profile: $e');
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
      'profileCompleteness': completeness,
      'userProfile': userProfile,
      'recommendedJobs': recommendedJobs,
      'upcomingEvent': Event(
        title: 'Tech Career Expo 2024',
        date: '24 Okt 2024',
        time: '10:00 WIB',
        type: 'WEBINAR LANGSUNG',
      ),
    };
  }
}
