import 'package:flutter/material.dart';
import '../repositories/notification_repository.dart';
import '../services/realtime_notification_service.dart';

class NotificationBadge extends StatefulWidget {
  final Widget child;

  const NotificationBadge({
    super.key,
    required this.child,
  });

  @override
  State<NotificationBadge> createState() => _NotificationBadgeState();
}

class _NotificationBadgeState extends State<NotificationBadge> {
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchInitialCount();
    // Listen to realtime notifications to refresh count
    RealtimeNotificationService().notificationStream.listen((_) {
      _fetchInitialCount();
    });
  }

  Future<void> _fetchInitialCount() async {
    if (!mounted) return;
    final count = await NotificationRepository().getUnreadCount();
    if (mounted) {
      setState(() {
        _unreadCount = count;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_unreadCount == 0) return widget.child;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        Positioned(
          right: -4,
          top: -4,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              _unreadCount > 9 ? '9+' : _unreadCount.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
