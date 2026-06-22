import 'package:dcc_mobile/core/utils/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_model.dart';

class EventService {
  final _supabase = Supabase.instance.client;

  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await _supabase
          .from('events')
          .select('*, event_speakers(*)')
          .order('event_date', ascending: true)
          .limit(20);

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      // Re-throw or handle error appropriately
      appLog('Error fetching events: $e');
      throw Exception('Failed to fetch events from Supabase');
    }
  }
}
