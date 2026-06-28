import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import '../models/profile_model.dart';
import '../services/cv_service.dart';
import 'cv_preview_screen.dart';

class CVScreen extends StatelessWidget {
  final UserProfile profile;

  const CVScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Template CV'),
        backgroundColor: AppColors.background,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih desain yang paling sesuai dengan profesionalisme Anda.',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildTemplateCard(
                    context,
                    title: 'Modern Minimalist',
                    description: 'Desain bersih dengan sidebar warna aksen.',
                    icon: Icons.dashboard_customize,
                    type: CVTemplateType.modern,
                  ),
                  const SizedBox(height: 16),
                  _buildTemplateCard(
                    context,
                    title: 'Classic Traditional',
                    description: 'Layout hitam-putih standar yang sangat ATS-friendly.',
                    icon: Icons.article,
                    type: CVTemplateType.classic,
                  ),
                  const SizedBox(height: 16),
                  _buildTemplateCard(
                    context,
                    title: 'Professional Executive',
                    description: 'Layout dua kolom dengan penekanan pada konten padat.',
                    icon: Icons.assignment_ind,
                    type: CVTemplateType.professional,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required CVTemplateType type,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CVPreviewScreen(profile: profile, template: type),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.navIndicator,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 32),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.headlineSmall),
                  const SizedBox(height: 4),
                  Text(description, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.outline),
          ],
        ),
      ),
    );
  }
}
