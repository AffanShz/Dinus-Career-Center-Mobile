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
      print('[HomeService] Fetched ${(response as List).length} lowongan');

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
      print('[HomeService] Error fetching recommended jobs: $e');
    }

    return {
      'userName': name,
      'profileCompleteness': completeness,
      'userProfile': userProfile,
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
