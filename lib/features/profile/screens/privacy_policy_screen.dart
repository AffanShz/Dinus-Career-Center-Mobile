import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Kebijakan Privasi',
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
            Text(
              'Kebijakan Privasi UDINUS Career Center',
              style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Terakhir diperbarui: 23 Juni 2026',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '1. Pengumpulan Informasi',
              content: 'Kami mengumpulkan informasi yang Anda berikan secara langsung saat menggunakan platform UDINUS Career Center. Informasi ini meliputi data akademik (NIM, Jurusan, IPK), informasi kontak (Email, Nomor Telepon), data riwayat pendidikan, kemampuan teknis (Tech Stack), dan Curriculum Vitae (CV). Kami juga mengumpulkan informasi riwayat lamaran yang Anda ajukan.',
            ),
            _buildSection(
              title: '2. Penggunaan Informasi',
              content: 'Informasi Anda digunakan secara eksklusif untuk tujuan karir dan rekrutmen. Kami membagikan data profil dan CV Anda hanya kepada perusahaan (Penyedia Kerja) ketika Anda menekan tombol "Lamar Sekarang" atau saat perusahaan mencari kandidat yang cocok. Kami tidak menjual data pribadi Anda kepada pihak ketiga mana pun.',
            ),
            _buildSection(
              title: '3. Keamanan Data',
              content: 'Kami berkomitmen untuk melindungi data pribadi Anda. Sistem kami menggunakan autentikasi yang aman dan transmisi data yang dienkripsi. Namun, kami mengingatkan Anda untuk selalu menjaga kerahasiaan kata sandi Anda dan tidak membagikannya.',
            ),
            _buildSection(
              title: '4. Perubahan Kebijakan',
              content: 'Kami sewaktu-waktu dapat memperbarui Kebijakan Privasi ini. Segala perubahan akan diumumkan melalui aplikasi ini. Penggunaan berkelanjutan atas layanan ini menandakan persetujuan Anda atas setiap pembaruan.',
            ),
            const SizedBox(height: 32),
            Text(
              'Jika Anda memiliki pertanyaan seputar Kebijakan Privasi ini, silakan hubungi tim UDINUS Career Center melalui kontak resmi Universitas Dian Nuswantoro.',
              style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.labelLarge.copyWith(color: AppColors.secondary, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
          ),
        ],
      ),
    );
  }
}
