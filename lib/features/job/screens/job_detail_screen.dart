import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import '../models/job_model.dart';
import 'job_application_screen.dart';

class JobDetailScreen extends StatefulWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late bool _isApplied;

  @override
  void initState() {
    super.initState();
    _isApplied = widget.job.isApplied;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pop(context, _isApplied);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primary),
            onPressed: () => Navigator.pop(context, _isApplied),
          ),
          title: Text(
            'Detail Lowongan',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
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
                            color: Colors.black.withValues(alpha: 0.04),
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
                              child:
                                  widget.job.logoPerusahaan != null &&
                                      widget.job.logoPerusahaan!.isNotEmpty
                                  ? Image.network(
                                      widget.job.logoPerusahaan!,
                                      fit: BoxFit.contain,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                                Icons.business,
                                                size: 40,
                                                color: AppColors.primary,
                                              ),
                                    )
                                  : const Icon(
                                      Icons.business,
                                      size: 40,
                                      color: AppColors.primary,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Judul Lowongan
                          Text(
                            widget.job.judul,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.headlineLarge.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Nama Perusahaan
                          Text(
                            widget.job.perusahaan,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ),
                          // Lokasi Perusahaan
                          if (widget.job.lokasi.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 14,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.job.lokasi,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 16),
                          _buildStatusBadge(widget.job.statusLoker),
                          // Tags (tipe pekerjaan, jurusan, sektor)
                          if (widget.job.tags.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Wrap(
                              alignment: WrapAlignment.center,
                              spacing: 8,
                              runSpacing: 6,
                              children: widget.job.tags
                                  .map(
                                    (tag) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: tag.bg,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        tag.label,
                                        style: AppTextStyles.labelSmall.copyWith(
                                          color: tag.text,
                                        ),
                                      ),
                                    ),
                                  )
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
                          widget.job.rangeGajiText,
                        ),
                        _buildInfoItem(
                          Icons.people_outline,
                          'Kebutuhan',
                          widget.job.jumlahPerson != null
                              ? '${widget.job.jumlahPersonText} Orang'
                              : '-',
                        ),
                        _buildInfoItem(
                          Icons.calendar_today_outlined,
                          'Deadline',
                          widget.job.formattedBatasAkhir,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
  
                    // Detail Info (jabatan jika ada)
                    if (widget.job.jabatan != null &&
                        widget.job.jabatan!.isNotEmpty) ...[
                      _buildInfoRow(
                        Icons.work_outline,
                        'Jabatan',
                        widget.job.jabatan!,
                      ),
                      const SizedBox(height: 12),
                    ],
  
                    // Divider
                    Divider(color: Colors.grey[200], thickness: 1),
                    const SizedBox(height: 24),
  
                    // Deskripsi Pekerjaan
                    _buildSectionTitle('Deskripsi Pekerjaan'),
                    const SizedBox(height: 12),
                    Text(
                      widget.job.detailLowongan.isNotEmpty
                          ? widget.job.detailLowongan
                          : 'Tidak ada deskripsi.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.grey[800],
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 32),
  
                    // Kualifikasi / Requirements
                    _buildSectionTitle('Kualifikasi'),
                    const SizedBox(height: 12),
                    ..._buildRequirementsList(widget.job.requirements),
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
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (widget.job.isAktif && !_isApplied)
                      ? () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  JobApplicationScreen(lowonganId: widget.job.id),
                            ),
                          );
  
                          if (result == true && mounted) {
                            setState(() {
                              _isApplied = true;
                            });
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isApplied
                        ? Colors.green
                        : AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: _isApplied
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.grey[300],
                    disabledForegroundColor: _isApplied
                        ? Colors.green
                        : Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _isApplied
                        ? 'Anda sudah mendaftar'
                        : (widget.job.isAktif
                              ? 'Lamar Sekarang'
                              : 'Lowongan Ditutup'),
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: null, // inherit from button foregroundColor
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final isActive = status.toLowerCase() == 'aktif';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isActive ? 'AKTIF' : 'TUTUP',
        style: AppTextStyles.labelSmall.copyWith(
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
              color: AppColors.accent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.accent, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: AppTextStyles.labelSmall.copyWith(
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
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
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
      style: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.primary,
      ),
    );
  }

  List<Widget> _buildRequirementsList(String requirements) {
    if (requirements.isEmpty) {
      return [
        Text(
          'Tidak ada kualifikasi yang disebutkan.',
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[600]),
        ),
      ];
    }

    final lines = requirements
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();

    return lines
        .map(
          (line) => Padding(
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
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey[800],
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }
}
