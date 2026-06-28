import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Syarat & Ketentuan',
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
              'Syarat & Ketentuan Layanan',
              style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(
              'Terakhir diperbarui: 23 Juni 2026',
              style: AppTextStyles.bodySmall.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            _buildSection(
              title: '1. Pengguna Platform',
              content: 'Platform UDINUS Career Center ini diperuntukkan secara khusus bagi Mahasiswa dan Alumni Universitas Dian Nuswantoro. Pengguna wajib menggunakan data akademik (NIM, Nama, Email SIADIN) yang valid dan sesuai dengan pangkalan data universitas.',
            ),
            _buildSection(
              title: '2. Penggunaan Layanan',
              content: 'Pengguna diperbolehkan menggunakan layanan ini untuk mencari informasi lowongan kerja, mendaftar program magang (PMMB/KKI), dan membangun resume (CV). Segala bentuk penyalahgunaan, manipulasi data, atau penggunaan platform untuk tujuan ilegal akan ditindak tegas.',
            ),
            _buildSection(
              title: '3. Tanggung Jawab Konten',
              content: 'Pengguna bertanggung jawab penuh atas keabsahan dan kebenaran data profil dan Curriculum Vitae yang diunggah. Pihak UDINUS Career Center tidak bertanggung jawab apabila terjadi penolakan oleh perusahaan akibat pemalsuan data yang dilakukan oleh pengguna.',
            ),
            _buildSection(
              title: '4. Interaksi dengan Perusahaan',
              content: 'Segala bentuk proses seleksi, wawancara, dan perjanjian kerja adalah tanggung jawab langsung antara pencari kerja dan perusahaan penyedia kerja. UDINUS Career Center bertindak murni sebagai fasilitator penyedia informasi.',
            ),
            const SizedBox(height: 32),
            Text(
              'Dengan menggunakan aplikasi ini, Anda secara sadar memahami dan menyetujui seluruh syarat serta ketentuan yang berlaku.',
              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
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
