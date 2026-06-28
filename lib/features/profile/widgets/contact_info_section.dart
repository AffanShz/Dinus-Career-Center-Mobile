import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';

class ContactInfoSection extends StatelessWidget {
  final String email;
  final String? phone;
  final String? city;

  const ContactInfoSection({
    super.key,
    required this.email,
    this.phone,
    this.city,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Kontak',
            style: AppTextStyles.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildContactItem(Icons.mail_outline, 'Email', email),
          const Divider(height: 24, color: AppColors.surfaceContainerHigh),
          _buildContactItem(Icons.smartphone_outlined, 'Nomor HP', phone ?? '+62 812 3456 7890'),
          const Divider(height: 24, color: AppColors.surfaceContainerHigh),
          _buildContactItem(Icons.location_on_outlined, 'Kota', city ?? 'Semarang, Jawa Tengah'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.bodySmall),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
