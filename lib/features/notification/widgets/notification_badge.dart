import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/notification_badge_bloc.dart';

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
  late NotificationBadgeBloc _badgeBloc;

  @override
  void initState() {
    super.initState();
    _badgeBloc = NotificationBadgeBloc()..add(LoadUnreadCount());
  }

  @override
  void dispose() {
    _badgeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBadgeBloc, NotificationBadgeState>(
      bloc: _badgeBloc,
      builder: (context, state) {
        if (state.count == 0) return widget.child;

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
                  state.count > 9 ? '9+' : state.count.toString(),
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
      },
    );
  }
}
