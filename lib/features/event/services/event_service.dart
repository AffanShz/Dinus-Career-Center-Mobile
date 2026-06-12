import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/event_model.dart';

class EventService {
  final _supabase = Supabase.instance.client;

  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await _supabase
          .from('events')
          .select('*, event_speakers(*)')
          .order('event_date', ascending: true);

      if (response == null) {
        return [];
      }

      final List<dynamic> data = response as List<dynamic>;
      return data.map((json) => EventModel.fromJson(json)).toList();
    } catch (e) {
      // Re-throw or handle error appropriately
      print('Error fetching events: $e');
      throw Exception('Failed to fetch events from Supabase');
    }
  }
}
