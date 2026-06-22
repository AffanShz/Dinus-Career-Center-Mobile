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
          .order('updated_at', ascending: false)
          .limit(50);

      final List<dynamic> response = await query;

      // Collect IDs where lowongan is missing (RLS-blocked inactive jobs)
      final List<Map<String, dynamic>> mutableResponse = [];
      final List<String> missingLowonganIds = [];

      for (final data in response) {
        final map = Map<String, dynamic>.from(data as Map<String, dynamic>);
        mutableResponse.add(map);

        if (_isLowonganMissing(map['lowongan']) && map['lowongan_id'] != null) {
          missingLowonganIds.add(map['lowongan_id'].toString());
        }
      }

      // Batch fetch all missing lowongan in a single query (instead of N+1)
      if (missingLowonganIds.isNotEmpty) {
        final fallbackData = await _fetchLowonganBatch(missingLowonganIds);
        for (final map in mutableResponse) {
          if (_isLowonganMissing(map['lowongan']) && map['lowongan_id'] != null) {
            final id = map['lowongan_id'].toString();
            if (fallbackData.containsKey(id)) {
              map['lowongan'] = fallbackData[id];
            }
          }
        }
      }
      
      final List<ApplicationModel> allApplications = mutableResponse
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

  /// Batch fetch: fetch multiple lowongan + perusahaan directly by IDs.
  /// Replaces the serial N+1 _fetchLowonganFallback loop with a single query.
  Future<Map<String, Map<String, dynamic>>> _fetchLowonganBatch(List<String> lowonganIds) async {
    try {
      final response = await _supabase
          .from('lowongan')
          .select('''
            *,
            perusahaan (
              *
            )
          ''')
          .inFilter('lowongan_id', lowonganIds);

      final Map<String, Map<String, dynamic>> result = {};
      for (final item in response as List) {
        final map = item as Map<String, dynamic>;
        final id = map['lowongan_id']?.toString();
        if (id != null) {
          result[id] = map;
        }
      }
      return result;
    } catch (e) {
      appLog('WARN: _fetchLowonganBatch failed: $e');
      return {};
    }
  }
}
