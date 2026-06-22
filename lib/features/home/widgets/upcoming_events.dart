import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import 'package:intl/intl.dart';
import '../../event/models/event_model.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse(event.registrationLink ?? 'https://cc.dinus.ac.id/tiket_JF27/');
        try {
          if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
            debugPrint('Could not launch $url');
          }
        } catch (e) {
          debugPrint('Error launching URL: $e');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, Color(0xFF0A58A6)],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flash_on,
                              color: Colors.white, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            (event.category ?? 'EVENT').toUpperCase(),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    event.title,
                    style: AppTextStyles.headlineLarge.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            DateFormat('dd MMM yyyy', 'id_ID').format(event.eventDate),
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time_outlined,
                            color: Colors.white70,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            event.startTime,
                            style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: -30,
              bottom: -30,
              child: Icon(
                Icons.language,
                size: 150,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            Positioned(
              right: -60,
              top: -20,
              child: Icon(
                Icons.show_chart,
                size: 200,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}

class UpcomingEvents extends StatelessWidget {
  final EventModel event;

  const UpcomingEvents({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Event yang akan datang',
          style: AppTextStyles.headlineSmall,
        ),
        const SizedBox(height: 16),
        EventCard(event: event),
      ],
    );
  }
}
