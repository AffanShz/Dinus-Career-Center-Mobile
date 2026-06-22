import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Tentang Kami',
          style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset('assets/images/udinus.png', height: 100),
            ),
            const SizedBox(height: 32),
            Text(
              'UDINUS Career Center',
              style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'UDINUS Career Center (UCC) merupakan pusat layanan dan karir bagi Alumni Universitas Dian Nuswantoro. Kami menyediakan informasi karir, pemagangan (internship), dan lowongan kerja di berbagai bidang serta lintas perusahaan industri.',
              style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
            ),
            const SizedBox(height: 16),
            Text(
              'Kehadiran portal ini ditujukan untuk memfasilitasi pertemuan antara para pencari kerja, khususnya lulusan UDINUS, dengan pihak perusahaan penyedia kerja atau instansi. Melalui platform ini, diharapkan terjalin sinergi yang baik dalam memenuhi kebutuhan sumber daya manusia yang berkualitas di dunia industri.',
              style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
            ),
            const SizedBox(height: 32),
            Text(
              'Layanan Kami',
              style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            _buildServiceItem(Icons.work_outline, 'Informasi Lowongan Kerja (Loker)'),
            _buildServiceItem(Icons.business_center_outlined, 'Informasi Magang / PMMB / KKI'),
            _buildServiceItem(Icons.school_outlined, 'Campus Hiring & Job Fair'),
            _buildServiceItem(Icons.group_outlined, 'Konseling Karir & Tracer Study'),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondary, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
