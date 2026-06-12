import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import '../models/profile_model.dart';

class EducationSection extends StatelessWidget {
  final List<Education> educationList;
  final String? pendidikanTertinggi;

  const EducationSection({
    super.key,
    required this.educationList,
    this.pendidikanTertinggi,
  });

  @override
  Widget build(BuildContext context) {
    // Show section even if educationList is empty, as long as pendidikanTertinggi exists
    if (educationList.isEmpty && (pendidikanTertinggi == null || pendidikanTertinggi!.isEmpty)) {
      return const SizedBox.shrink();
    }

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
                'Riwayat Pendidikan',
                style: AppTextStyles.headlineSmall,
              ),
              if (pendidikanTertinggi != null && pendidikanTertinggi!.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD3E2FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.school_outlined, size: 14, color: Color(0xFF1E5BBF)),
                      const SizedBox(width: 4),
                      Text(
                        pendidikanTertinggi!,
                        style: AppTextStyles.labelSmall
                            .copyWith(color: const Color(0xFF1E5BBF)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          if (educationList.isEmpty)
            Text(
              'Belum ada riwayat pendidikan.',
              style: AppTextStyles.bodySmall,
            )
          else
            ...educationList.asMap().entries.map((entry) {
              final edu = entry.value;
              final isLast = entry.key == educationList.length - 1;

              return Padding(
                padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            edu.institution,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            edu.degree,
                            style: AppTextStyles.bodyMedium,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 12,
                                color: AppColors.onSurfaceVariant,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                edu.period,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 11,
                                ),
                              ),
                              if (edu.location.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 12,
                                  color: AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  edu.location,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
