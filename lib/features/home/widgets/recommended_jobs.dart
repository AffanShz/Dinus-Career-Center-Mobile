import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import '../../job/models/job_model.dart';
import '../../job/screens/job_detail_screen.dart';

/// Card loker ringkas untuk ditampilkan di home screen.
/// Menampilkan: logo perusahaan, judul, nama perusahaan, lokasi, dan 1 tag.
class HomeJobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onBookmarkToggle;

  const HomeJobCard({
    super.key,
    required this.job,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(job: job),
          ),
        );
      },
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Baris atas: logo + bookmark
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo perusahaan
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: job.logoPerusahaan != null &&
                            job.logoPerusahaan!.isNotEmpty
                        ? Image.network(
                            job.logoPerusahaan!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.business,
                                    color: Colors.grey, size: 20),
                          )
                        : const Icon(Icons.business,
                            color: Colors.grey, size: 20),
                  ),
                ),
                // Tombol bookmark
                GestureDetector(
                  onTap: onBookmarkToggle,
                  child: Icon(
                    job.isBookmarked
                        ? Icons.bookmark
                        : Icons.bookmark_border_rounded,
                    color: job.isBookmarked ? AppColors.primary : Colors.grey[400],
                    size: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Judul lowongan
            Text(
              job.judul,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),

            // Nama perusahaan
            Text(
              job.perusahaan,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.blueGrey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),

            // Lokasi
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 13, color: Colors.blueGrey[500]),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job.lokasi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.blueGrey[500],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 1 tag saja (tipe pekerjaan / jurusan / sektor)
            if (job.tags.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: job.tags.first.bg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  job.tags.first.label,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: job.tags.first.text,
                  ),
                ),
              )
            else if (job.tipePekerjaan != null)
              // Fallback jika tags kosong tapi tipePekerjaan ada
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6E4FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  job.tipePekerjaan!,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2D5BE3),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Section rekomendasi loker di home screen dengan scroll horizontal.
class RecommendedJobs extends StatelessWidget {
  final List<JobModel> jobs;
  final Function(String) onBookmarkToggle;
  final VoidCallback? onSeeAll;

  const RecommendedJobs({
    super.key,
    required this.jobs,
    required this.onBookmarkToggle,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rekomendasi Loker',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                'Lihat Semua',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accent,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Konten: loading skeleton / empty state / list card
        if (jobs.isEmpty)
          _buildEmptyState()
        else
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: jobs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final job = jobs[index];
                return HomeJobCard(
                  job: job,
                  onBookmarkToggle: () => onBookmarkToggle(job.id),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.work_outline_rounded, size: 36, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            'Belum ada rekomendasi loker',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
