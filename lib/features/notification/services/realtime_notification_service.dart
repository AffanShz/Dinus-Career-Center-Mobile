import 'dart:async';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RealtimeNotificationService {
  static final RealtimeNotificationService _instance = RealtimeNotificationService._internal();
  factory RealtimeNotificationService() => _instance;
  RealtimeNotificationService._internal();

  final _supabase = Supabase.instance.client;
  RealtimeChannel? _channel;
  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;

  void listenToAuthChanges() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if (event == AuthChangeEvent.signedIn && session != null) {
        print('DEBUG: AuthChangeEvent.signedIn - Initializing Realtime Notifications');
        init();
      } else if (event == AuthChangeEvent.signedOut) {
        print('DEBUG: AuthChangeEvent.signedOut - Disposing Realtime Notifications');
        _channel?.unsubscribe();
        _channel = null;
      }
    });
  }

  void init() {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      print('DEBUG: RealtimeNotificationService.init() - No user logged in');
      return;
    }
    
    // Unsubscribe from existing channel if any
    _channel?.unsubscribe();

    print('DEBUG: Subscribing to notifications for user: ${user.id}');
    _channel = _supabase
        .channel('notifikasi_user_${user.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.all, // Listen to ALL changes (INSERT, UPDATE, DELETE)
          schema: 'public',
          table: 'notifikasi',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'pelamar_id',
            value: user.id,
          ),
          callback: _handleInsert,
        )
        .subscribe((status, error) {
          print('DEBUG: Realtime Subscription Status: $status');
          if (error != null) {
            print('DEBUG: Realtime Subscription Error: $error');
          }
        });
  }

  Future<void> _handleInsert(PostgresChangePayload payload) async {
    print('DEBUG: Received Realtime Payload: ${payload.newRecord}');
    final data = payload.newRecord;
    
    // Always update the UI stream
    _notificationController.add(data);

    // Only show system notification (pop-up) for NEW inserts, not updates.
    if (payload.eventType != PostgresChangeEvent.insert) {
      return;
    }

    final String notificationId = data['notifikasi_id'].toString();
    
    // Duplicate prevention for system notifications
    final prefs = await SharedPreferences.getInstance();
    final List<String> processedIds = prefs.getStringList('processed_notification_ids') ?? [];
    
    if (processedIds.contains(notificationId)) return;
    
    processedIds.add(notificationId);
    if (processedIds.length > 50) processedIds.removeAt(0);
    await prefs.setStringList('processed_notification_ids', processedIds);

    NotificationService().showNotification(
      id: notificationId.hashCode,
      title: data['judul'] ?? 'Notifikasi Baru',
      body: data['pesan'] ?? '',
      payload: jsonEncode(data),
    );
  }

  void dispose() {
    _channel?.unsubscribe();
    _notificationController.close();
  }
}
