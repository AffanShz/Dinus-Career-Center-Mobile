import '../../event/models/event_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dcc_mobile/core/utils/app_logger.dart';

class EventDetailService {
  final _supabase = Supabase.instance.client;

  Future<EventModel> getEventDetail(String id) async {
    try {
      final response = await _supabase
          .from('events')
          .select('*, event_speakers(*)')
          .eq('event_id', id)
          .maybeSingle();

      if (response == null) {
        throw Exception('Event not found');
      }

      return EventModel.fromJson(response);
    } catch (e) {
      appLog('Error fetching event detail: $e');
      throw Exception('Failed to fetch event detail from Supabase');
    }
  }
}
