import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import 'package:intl/intl.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import '../models/event_model.dart';
import '../../event_detail/screens/event_detail_screen.dart';

class EventCard extends StatelessWidget {
  final EventModel event;

  const EventCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('d MMM yyyy').format(event.eventDate);
    final category = event.category ?? 'EVENT';
    final tagColor = _getCategoryColor(category);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventDetailScreen(event: event),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with Tags
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: const Color(0xFF1E293B),
                    child: _buildImage(event.imageUrl),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Row(
                    children: [
                      _buildTag(
                        'Akan Datang',
                        const Color(0xFF1E5BBF).withValues(alpha: 0.8),
                      ),
                      const SizedBox(width: 8),
                      _buildTag(category, tagColor.withValues(alpha: 0.8)),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        dateStr,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        event.locationName ?? 'TBA',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Center(child: Icon(Icons.image, color: Colors.white));
    }
    if (imageUrl.startsWith('http')) {
      return Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.broken_image, color: Colors.white));
      });
    } else {
      return Image.asset(imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.broken_image, color: Colors.white));
      });
    }
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'WEBINAR':
        return const Color(0xFF1E293B);
      case 'WORKSHOP':
        return const Color(0xFFBC5919);
      case 'CAREER WORKSHOP':
        return const Color(0xFF6B8DD6);
      default:
        return const Color(0xFF6B8DD6);
    }
  }
}
