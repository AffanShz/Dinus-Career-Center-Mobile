import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import '../models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileHeader({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Profile Avatar
        Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainerLow,
            border: Border.all(color: AppColors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(56),
            child: (userProfile.photoUrl != null &&
                    userProfile.photoUrl!.isNotEmpty)
                ? Image.network(
                    userProfile.photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Image.asset('assets/images/dcc.png'),
                  )
                : Image.asset(
                    'assets/images/dcc.png',
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        const SizedBox(height: 16),
        // Name
        Text(
          userProfile.name,
          style: AppTextStyles.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        // Major/Bidang
        Text(
          userProfile.bidang ?? 'Computer Science',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        // University
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school_outlined, size: 18, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              'Dian Nuswantoro University',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        // Location
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_on_outlined, size: 18, color: AppColors.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              'Semarang, Indonesia',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),
      ],
    );
  }
}
