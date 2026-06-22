import 'package:dcc_mobile/core/utils/app_logger.dart';
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
          .select('''
            *,
            lowongan (
              *,
              perusahaan (
                *
              )
            )
          ''')
          .eq('pelamar_id', user.id)
          .order('updated_at', ascending: false);

      final List<dynamic> response = await query;

      // For applications where lowongan is null (RLS-blocked inactive jobs),
      // attempt to fetch the lowongan data directly using lowongan_id.
      final List<Map<String, dynamic>> enrichedResponse = [];
      for (final data in response) {
        final map = Map<String, dynamic>.from(data as Map<String, dynamic>);

        if (_isLowonganMissing(map['lowongan']) && map['lowongan_id'] != null) {
          final lowonganData = await _fetchLowonganFallback(map['lowongan_id'].toString());
          if (lowonganData != null) {
            map['lowongan'] = lowonganData;
          }
        }

        enrichedResponse.add(map);
      }
      
      final List<ApplicationModel> allApplications = enrichedResponse
          .map((data) => ApplicationModel.fromMap(data))
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
      appLog('Error fetching applications: $e');
      rethrow;
    }
  }

  /// Check if the lowongan data from the join is missing/empty.
  /// This happens when the lowongan is inactive and RLS blocks the join.
  bool _isLowonganMissing(dynamic lowongan) {
    if (lowongan == null) return true;
    if (lowongan is Map && lowongan.isEmpty) return true;
    if (lowongan is List && lowongan.isEmpty) return true;
    return false;
  }

  /// Fallback: fetch lowongan + perusahaan directly by ID.
  /// Uses a separate RPC call or a direct query that may bypass
  /// the RLS restriction that blocks joined reads.
  Future<Map<String, dynamic>?> _fetchLowonganFallback(String lowonganId) async {
    try {
      final response = await _supabase
          .from('lowongan')
          .select('''
            *,
            perusahaan (
              *
            )
          ''')
          .eq('lowongan_id', lowonganId)
          .maybeSingle();

      return response;
    } catch (e) {
      appLog('WARN: _fetchLowonganFallback failed for $lowonganId: $e');
      return null;
    }
  }
}
