import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import '../models/job_model.dart';
import 'job_application_screen.dart';

class JobDetailScreen extends StatelessWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Lowongan',
          style: GoogleFonts.poppins(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Logo Perusahaan
                        Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: job.logoPerusahaan != null &&
                                    job.logoPerusahaan!.isNotEmpty
                                ? Image.network(
                                    job.logoPerusahaan!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Icon(Icons.business,
                                            size: 40, color: AppColors.primary),
                                  )
                                : const Icon(Icons.business,
                                    size: 40, color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Judul Lowongan
                        Text(
                          job.judul,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Nama Perusahaan
                        Text(
                          job.perusahaan,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Lokasi Perusahaan
                        if (job.lokasi.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on_outlined,
                                  size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                job.lokasi,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 16),
                        _buildStatusBadge(job.statusLoker),
                        // Tags (tipe pekerjaan, jurusan, sektor)
                        if (job.tags.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 6,
                            children: job.tags
                                .map((tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: tag.bg,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        tag.label,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: tag.text,
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Info Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(
                        Icons.monetization_on_outlined,
                        'Gaji',
                        job.rangeGajiText,
                      ),
                      _buildInfoItem(
                        Icons.people_outline,
                        'Kebutuhan',
                        job.jumlahPerson != null
                            ? '${job.jumlahPersonText} Orang'
                            : '-',
                      ),
                      _buildInfoItem(
                        Icons.calendar_today_outlined,
                        'Deadline',
                        job.formattedBatasAkhir,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Detail Info (jabatan jika ada)
                  if (job.jabatan != null && job.jabatan!.isNotEmpty) ...[
                    _buildInfoRow(Icons.work_outline, 'Jabatan', job.jabatan!),
                    const SizedBox(height: 12),
                  ],

                  // Divider
                  Divider(color: Colors.grey[200], thickness: 1),
                  const SizedBox(height: 24),

                  // Deskripsi Pekerjaan
                  _buildSectionTitle('Deskripsi Pekerjaan'),
                  const SizedBox(height: 12),
                  Text(
                    job.detailLowongan.isNotEmpty
                        ? job.detailLowongan
                        : 'Tidak ada deskripsi.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[800],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Kualifikasi / Requirements
                  _buildSectionTitle('Kualifikasi'),
                  const SizedBox(height: 12),
                  ..._buildRequirementsList(job.requirements),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // CTA Button
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: (job.isAktif && !job.isApplied)
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                JobApplicationScreen(lowonganId: job.id),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: job.isApplied ? Colors.green : AppColors.primary,
                  foregroundColor: AppColors.white,
                  disabledBackgroundColor: job.isApplied ? Colors.green.withOpacity(0.1) : Colors.grey[300],
                  disabledForegroundColor: job.isApplied ? Colors.green : Colors.grey[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  job.isApplied
                      ? 'Anda sudah mendaftar'
                      : (job.isAktif ? 'Lamar Sekarang' : 'Lowongan Ditutup'),
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status.toLowerCase() == 'aktif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'AKTIF' : 'TUTUP',
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.accent, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.accent),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textMuted,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  List<Widget> _buildRequirementsList(String requirements) {
    if (requirements.isEmpty) {
      return [
        Text(
          'Tidak ada kualifikasi yang disebutkan.',
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
        ),
      ];
    }

    final lines = requirements
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return lines
        .map((line) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: Icon(Icons.circle, size: 6, color: AppColors.accent),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      line.trim().startsWith('-') || line.trim().startsWith('•')
                          ? line.trim().substring(1).trim()
                          : line.trim(),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[800],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();
  }
}
