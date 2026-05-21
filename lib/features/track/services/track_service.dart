import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/application_model.dart';
import '../../auth/services/auth_service.dart';

class TrackService {
  final _supabase = Supabase.instance.client;

  Future<List<ApplicationModel>> fetchApplications({String filter = 'Semua'}) async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return [];

      var query = _supabase
          .from('lamaran')
          .select('*, lowongan(*, perusahaan(*))')
          .eq('pelamar_id', user.id)
          .order('updated_at', ascending: false);

      final List<dynamic> response = await query;
      
      final List<ApplicationModel> allApplications = response
          .map((data) => ApplicationModel.fromMap(data as Map<String, dynamic>))
          .toList();

      if (filter.contains('Semua')) return allApplications;
      
      if (filter.contains('Aktif')) {
        // Aktif: applied, reviewed, interview (currentStep < 3)
        return allApplications.where((app) => app.currentStep < 3).toList();
      }
      
      if (filter.contains('Selesai')) {
        // Selesai: accepted, rejected (currentStep == 3)
        return allApplications.where((app) => app.currentStep == 3).toList();
      }
      
      return allApplications;
    } catch (e) {
      print('Error fetching applications: $e');
      return [];
    }
  }
}
