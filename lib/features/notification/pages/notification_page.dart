import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../bloc/notification_bloc.dart';
import '../bloc/notification_event.dart';
import '../bloc/notification_state.dart';
import '../repositories/notification_repository.dart';
import '../services/realtime_notification_service.dart';
import '../widgets/notification_tile.dart';
import 'notification_detail_page.dart';
import 'package:dcc_mobile/core/theme/colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationBloc(
        repository: NotificationRepository(),
        realtimeService: RealtimeNotificationService()..init(),
      )..add(LoadNotifications()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          title: Text(
            'Notifikasi',
            style: GoogleFonts.poppins(
              color: const Color(0xFF1E293B),
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            BlocBuilder<NotificationBloc, NotificationState>(
              builder: (context, state) {
                final hasUnread = state.notifications.any((n) => !n.isRead);
                if (!hasUnread) return const SizedBox.shrink();

                return TextButton(
                  onPressed: () {
                    context.read<NotificationBloc>().add(MarkAllAsReadEvent());
                  },
                  child: Text(
                    'Baca Semua',
                    style: GoogleFonts.poppins(
                      color: AppColors.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state.status == NotificationStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == NotificationStatus.failure) {
              return Center(child: Text('Gagal memuat notifikasi: ${state.errorMessage}'));
            }

            if (state.notifications.isEmpty) {
              return _buildEmptyState();
            }

            final groupedNotifications = _groupNotifications(state.notifications);

            return RefreshIndicator(
              onRefresh: () async {
                context.read<NotificationBloc>().add(LoadNotifications());
              },
              child: ListView.builder(
                itemCount: groupedNotifications.length,
                itemBuilder: (context, index) {
                  final group = groupedNotifications[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                        child: Text(
                          group.header,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      ...group.items.map((notification) => NotificationTile(
                            notification: notification,
                            onTap: () {
                              context.read<NotificationBloc>().add(MarkAsRead(notification.id));
                              _handleNotificationNavigation(context, notification);
                            },
                          )),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_none_rounded, size: 40, color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Notifikasi',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifikasi tentang lamaran dan\ninterview akan muncul di sini',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  List<_NotificationGroup> _groupNotifications(List<dynamic> notifications) {
    final Map<String, List<dynamic>> groups = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (var n in notifications) {
      final date = DateTime(n.createdAt.year, n.createdAt.month, n.createdAt.day);
      String header;
      if (date == today) {
        header = 'HARI INI';
      } else if (date == yesterday) {
        header = 'KEMARIN';
      } else {
        header = DateFormat('dd MMMM yyyy').format(date).toUpperCase();
      }

      if (!groups.containsKey(header)) {
        groups[header] = [];
      }
      groups[header]!.add(n);
    }

    return groups.entries
        .map((e) => _NotificationGroup(header: e.key, items: e.value))
        .toList();
  }

  void _handleNotificationNavigation(BuildContext context, dynamic notification) {
    // Navigate to detail page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailPage(notification: notification),
      ),
    );
  }
}

class _NotificationGroup {
  final String header;
  final List<dynamic> items;

  _NotificationGroup({required this.header, required this.items});
}
