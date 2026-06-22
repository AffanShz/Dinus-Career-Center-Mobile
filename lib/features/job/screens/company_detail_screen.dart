import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import '../models/job_model.dart';
import '../services/job_service.dart';
import '../widgets/job_list_item.dart';

class CompanyDetailScreen extends StatefulWidget {
  final JobModel job;

  const CompanyDetailScreen({super.key, required this.job});

  @override
  State<CompanyDetailScreen> createState() => _CompanyDetailScreenState();
}

class _CompanyDetailScreenState extends State<CompanyDetailScreen> {
  List<JobModel> _companyJobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCompanyJobs();
  }

  Future<void> _fetchCompanyJobs() async {
    try {
      final jobs = await JobService().fetchJobs(namaPerusahaan: widget.job.perusahaan);
      if (mounted) {
        setState(() {
          _companyJobs = jobs.where((j) => j.id != widget.job.id).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Detail Perusahaan',
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
              child: Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.2)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: widget.job.logoPerusahaan != null && widget.job.logoPerusahaan!.isNotEmpty
                    ? Image.network(
                        widget.job.logoPerusahaan!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.business, size: 50, color: AppColors.primary),
                      )
                    : const Icon(Icons.business, size: 50, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                widget.job.perusahaan,
                style: AppTextStyles.headlineLarge.copyWith(color: AppColors.primary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.location_on, size: 16, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    widget.job.lokasi,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Alamat Perusahaan'),
            const SizedBox(height: 12),
            Text(
              widget.job.alamatPerusahaan ?? 'Alamat belum tersedia.',
              style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Deskripsi'),
            const SizedBox(height: 12),
            Text(
              widget.job.deskripsiPerusahaan != null && widget.job.deskripsiPerusahaan!.isNotEmpty 
                ? widget.job.deskripsiPerusahaan! 
                : 'Informasi detail perusahaan belum tersedia pada sistem saat ini. Perusahaan ini aktif mencari talenta terbaik melalui platform UDINUS Career Center.',
              style: AppTextStyles.bodyMedium.copyWith(height: 1.6, color: widget.job.deskripsiPerusahaan != null ? AppColors.onSurface : Colors.grey[700]),
            ),
            if (widget.job.websitePerusahaan != null && widget.job.websitePerusahaan!.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSectionTitle('Website'),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final url = Uri.parse(widget.job.websitePerusahaan!.startsWith('http') 
                    ? widget.job.websitePerusahaan! 
                    : 'https://${widget.job.websitePerusahaan}');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: Text(
                  widget.job.websitePerusahaan!,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 32),
            _buildSectionTitle('Lowongan dari Perusahaan Ini'),
            const SizedBox(height: 16),
            _buildCompanyJobs(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
    );
  }

  Widget _buildCompanyJobs() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_companyJobs.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.textMuted),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Tidak ada lowongan lain yang aktif dari perusahaan ini.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _companyJobs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        return JobListItem(job: _companyJobs[index]);
      },
    );
  }
}
