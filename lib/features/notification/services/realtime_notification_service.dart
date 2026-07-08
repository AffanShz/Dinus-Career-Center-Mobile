import 'package:dcc_mobile/core/utils/app_logger.dart';
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
  bool _isListeningToAuth = false;
  final _notificationController = StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get notificationStream => _notificationController.stream;

  void listenToAuthChanges() {
    if (_isListeningToAuth) return;
    _isListeningToAuth = true;
    
    _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;

      if ((event == AuthChangeEvent.signedIn || event == AuthChangeEvent.initialSession) && session != null) {
        appLog('DEBUG: AuthChangeEvent.${event.name} - Initializing Realtime Notifications');
        init();
      } else if (event == AuthChangeEvent.signedOut) {
        appLog('DEBUG: AuthChangeEvent.signedOut - Disposing Realtime Notifications');
        _channel?.unsubscribe();
        _channel = null;
      }
    });
  }

  void init() {
    final user = _supabase.auth.currentUser;
    if (user == null) {
      appLog('DEBUG: RealtimeNotificationService.init() - No user logged in');
      return;
    }
    
    // Check if we are already subscribed to this user's channel to avoid redundancy
    if (_channel != null) {
      appLog('DEBUG: Realtime already subscribed, skipping re-init');
      return;
    }

    appLog('DEBUG: Subscribing to notifications for user: ${user.id}');
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
          appLog('DEBUG: Realtime Subscription Status: $status');
          if (error != null) {
            appLog('DEBUG: Realtime Subscription Error: $error');
          }
        });
  }

  Future<void> _handleInsert(PostgresChangePayload payload) async {
    appLog('DEBUG: Received Realtime Payload: ${payload.newRecord}');

    // Ignore DELETE events which have empty newRecord and cause ghost notifications
    if (payload.eventType == PostgresChangeEvent.delete) {
      return;
    }

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

    try {
      await NotificationService().showNotification(
        id: notificationId.hashCode.abs(),
        title: data['judul'] ?? 'Notifikasi Baru',
        body: data['pesan'] ?? '',
        payload: jsonEncode(data),
      );
      appLog('DEBUG: System notification shown for id=$notificationId');
    } catch (e) {
      appLog('ERROR: showNotification failed: $e');
    }
  }

  /// Tears down the realtime channel without closing the shared
  /// [StreamController]. Because this class is a singleton, closing
  /// the controller is permanent — any subsequent `add()` call (e.g.
  /// after a re-login) would throw `Bad state: Cannot add event after
  /// closing`. Only the channel subscription needs cleanup; the stream
  /// stays alive for the lifetime of the process.
  void dispose() {
    _channel?.unsubscribe();
    _channel = null;
  }
}
