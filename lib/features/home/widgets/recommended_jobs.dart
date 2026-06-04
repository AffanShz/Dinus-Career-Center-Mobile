import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
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
        width: 240,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest.withOpacity(0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: job.logoPerusahaan != null && job.logoPerusahaan!.isNotEmpty
                        ? Image.network(
                            job.logoPerusahaan!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.business, color: AppColors.onSurfaceVariant),
                          )
                        : const Icon(Icons.business, color: AppColors.onSurfaceVariant),
                  ),
                ),
                GestureDetector(
                  onTap: onBookmarkToggle,
                  child: Icon(
                    job.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: job.isBookmarked ? AppColors.primary : AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              job.judul,
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.onPrimaryFixed),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              job.perusahaan,
              style: AppTextStyles.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.onSurfaceVariant),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    job.lokasi,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rekomendasi Pekerjaan',
              style: AppTextStyles.headlineSmall,
            ),
            TextButton(
              onPressed: onSeeAll,
              child: Text('Lihat Semua', style: AppTextStyles.labelLarge),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (jobs.isEmpty)
          const Center(child: Text('Tidak ada rekomendasi pekerjaan'))
        else
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: jobs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
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
}
