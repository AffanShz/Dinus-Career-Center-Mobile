import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import '../../job/models/job_model.dart';
import '../../job/screens/job_detail_screen.dart';

class JobCard extends StatelessWidget {
  final JobModel job;
  final VoidCallback onBookmarkToggle;

  const JobCard({
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
        width: 260,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/images/dcc.png', height: 40),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    job.isBookmarked ? Icons.bookmark : Icons.bookmark_border_rounded,
                    color: job.isBookmarked ? AppColors.primary : Colors.grey,
                  ),
                  onPressed: onBookmarkToggle,
                ),
              ],
            ),
            const Spacer(),
            Text(
              job.judul,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              job.perusahaan,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: Colors.blueGrey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.blueGrey[600],
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    job.lokasi,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.blueGrey[600]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: job.tags.take(2).map((tag) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: tag.bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tag.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: tag.text,
                    ),
                  ),
                );
              }).toList(),
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

  const RecommendedJobs({
    super.key,
    required this.jobs,
    required this.onBookmarkToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return const Center(child: Text("Belum ada rekomendasi loker"));
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rekomendasi Loker',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              'Lihat Semua',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.accent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final job = jobs[index];
              return Padding(
                padding:
                    EdgeInsets.only(right: index == jobs.length - 1 ? 0 : 16),
                child: JobCard(
                  job: job,
                  onBookmarkToggle: () => onBookmarkToggle(job.judul),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
