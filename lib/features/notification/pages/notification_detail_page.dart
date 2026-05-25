import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/notification_model.dart';
import 'package:dcc_mobile/core/theme/colors.dart';

class NotificationDetailPage extends StatelessWidget {
  final NotificationModel notification;

  const NotificationDetailPage({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'Detail Notifikasi',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTypeBadge(),
            const SizedBox(height: 16),
            Text(
              notification.judul,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              DateFormat('dd MMMM yyyy, HH:mm').format(notification.createdAt),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
            const Divider(height: 32),
            Text(
              notification.pesan,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.6,
                color: const Color(0xFF334155),
              ),
            ),
            const SizedBox(height: 32),
            if (notification.tipe == 'interview' && notification.linkZoom != null)
              _buildActionButton(
                label: 'Join Interview',
                icon: Icons.video_call_rounded,
                onPressed: () {
                  // TODO: Launch zoom link
                },
              ),
            if ((notification.tipe == 'lamaran' ||
                    notification.tipe == 'completed' ||
                    notification.tipe == 'status_update') &&
                notification.lamaranId != null)
              _buildActionButton(
                label: 'Lihat Status Lamaran',
                icon: Icons.description_rounded,
                onPressed: () {
                  // TODO: Navigate to application detail
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge() {
    IconData iconData;
    Color color;
    String label;

    switch (notification.tipe.toLowerCase()) {
      case 'interview':
        iconData = Icons.video_call_rounded;
        color = const Color(0xFF4530B2);
        label = 'Interview';
        break;
      case 'lamaran':
      case 'status_update':
        iconData = Icons.description_rounded;
        color = const Color(0xFF1E5BBF);
        label = 'Lamaran';
        break;
      case 'completed':
        iconData = Icons.check_circle_outline_rounded;
        color = const Color(0xFF10B981); // Green color for success/completed
        label = 'Selesai';
        break;
      default:
        iconData = Icons.notifications_rounded;
        color = AppColors.primary;
        label = 'Informasi';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
