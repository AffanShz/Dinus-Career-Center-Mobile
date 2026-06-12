import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';

class AcademicInfoSection extends StatelessWidget {
  final String? gpa;
  final String? nim;
  final String? bidang;

  const AcademicInfoSection({
    super.key,
    this.gpa,
    this.nim,
    this.bidang,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border:
            Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Informasi Akademik',
                style: AppTextStyles.headlineSmall,
              ),
              if (gpa != null && gpa!.isNotEmpty)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFDBCA),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Color(0xFF783200)),
                      const SizedBox(width: 4),
                      Text(
                        '$gpa IPK',
                        style: AppTextStyles.labelSmall
                            .copyWith(color: const Color(0xFF783200)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInfoRow('NIM', nim ?? '-'),
          const SizedBox(height: 16),
          _buildInfoRow('Bidang / Jurusan', bidang ?? '-'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(fontSize: 12),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
