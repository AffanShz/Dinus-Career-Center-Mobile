import 'package:dcc_mobile/core/utils/app_logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';
import '../../auth/services/auth_service.dart';

class NotificationRepository {
  final _supabase = Supabase.instance.client;

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return [];

      final response = await _supabase
          .from('notifikasi')
          .select()
          .eq('pelamar_id', user.id)
          .order('created_at', ascending: false);

      return (response as List)
          .map((data) => NotificationModel.fromMap(data))
          .toList();
    } catch (e) {
      appLog('Error fetching notifications: $e');
      return [];
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabase
          .from('notifikasi')
          .update({'is_read': true})
          .eq('notifikasi_id', notificationId);
    } catch (e) {
      appLog('Error marking notification as read: $e');
    }
  }

  Future<void> markAllAsRead() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return;

      await _supabase
          .from('notifikasi')
          .update({'is_read': true})
          .eq('pelamar_id', user.id)
          .eq('is_read', false);
    } catch (e) {
      appLog('Error marking all notifications as read: $e');
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _supabase
          .from('notifikasi')
          .delete()
          .eq('notifikasi_id', notificationId);
    } catch (e) {
      appLog('Error deleting notification: $e');
    }
  }

  Future<void> deleteAllNotifications() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return;

      await _supabase
          .from('notifikasi')
          .delete()
          .eq('pelamar_id', user.id);
    } catch (e) {
      appLog('Error deleting all notifications: $e');
    }
  }

  Future<int> getUnreadCount() async {
    try {
      final user = AuthService.currentUser;
      if (user == null) return 0;

      final response = await _supabase
          .from('notifikasi')
          .select('notifikasi_id')
          .eq('pelamar_id', user.id)
          .eq('is_read', false);

      return (response as List).length;
    } catch (e) {
      appLog('Error getting unread count: $e');
      return 0;
    }
  }
}
