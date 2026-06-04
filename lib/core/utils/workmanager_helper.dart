import 'dart:convert';
import 'package:workmanager/workmanager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/notification/services/notification_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final prefs = await SharedPreferences.getInstance();
    final url = prefs.getString('SUPABASE_URL');
    final anonKey = prefs.getString('SUPABASE_ANON_KEY');
    final userId = prefs.getString('USER_ID');

    if (url == null || anonKey == null || userId == null) {
      return Future.value(true);
    }

    try {
      // Initialize Supabase
      try {
        await Supabase.initialize(url: url, anonKey: anonKey);
      } catch (_) {
        // Already initialized
      }

      // Initialize NotificationService in this isolate
      await NotificationService().init();

      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('notifikasi')
          .select()
          .eq('pelamar_id', userId)
          .eq('is_read', false)
          .order('created_at', ascending: false)
          .limit(5);

      final List<dynamic> notifications = response as List;
      final List<String> processedIds = prefs.getStringList('processed_notification_ids') ?? [];
      bool hasUpdates = false;

      for (var data in notifications) {
        final String notificationId = data['notifikasi_id'].toString();
        if (!processedIds.contains(notificationId)) {
          processedIds.add(notificationId);
          hasUpdates = true;
          
          await NotificationService().showNotification(
            id: notificationId.hashCode,
            title: data['judul'] ?? 'Notifikasi Baru',
            body: data['pesan'] ?? '',
            payload: jsonEncode(data),
          );
        }
      }

      if (hasUpdates) {
        if (processedIds.length > 50) {
          processedIds.removeRange(0, processedIds.length - 50);
        }
        await prefs.setStringList('processed_notification_ids', processedIds);
      }
    } catch (e) {
      print('Workmanager task error: $e');
    }

    return Future.value(true);
  });
}

class WorkManagerHelper {
  static const String taskName = "check_notifications_task";

  static void init() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static void registerTask() {
    Workmanager().registerPeriodicTask(
      "1",
      taskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }
}
