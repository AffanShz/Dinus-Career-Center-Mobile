import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import '../models/job_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/job_application_bloc.dart';
import 'job_application_screen.dart';
import 'company_detail_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';
import '../../home/bloc/home_bloc.dart';
import '../../home/bloc/home_event.dart';

class JobDetailScreen extends StatefulWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late bool _isApplied;
  late JobApplicationBloc _applicationBloc;

  @override
  @override
  void initState() {
    super.initState();
    _isApplied = widget.job.isApplied;
    _applicationBloc = JobApplicationBloc();
  }

  @override
  void dispose() {
    _applicationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<bool>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 130), // Space for back button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildJobTitle(),
                        const SizedBox(height: 24),
                        _buildInfoCards(),
                        const SizedBox(height: 24),
                        _buildCompanyCard(),
                        const SizedBox(height: 24),
                        _buildAdditionalInfo(),
                        const SizedBox(height: 32),
                        _buildDescription(),
                        const SizedBox(height: 24),
                        _buildRequirements(),
                        const SizedBox(height: 120), // Space for bottom bar
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Top App Bar
            _buildCustomAppBar(context),

            // Bottom Bar
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCircleButton(
              icon: Icons.arrow_back,
              onPressed: () =>
                  Navigator.of(context).popUntil((route) => route.isFirst),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildJobTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            (widget.job.tipePekerjaan ?? 'LOKER').toUpperCase(),
            style: AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.job.judul,
          style: AppTextStyles.headlineLarge.copyWith(
            color: AppColors.primary,
            height: 1.2,
          ),
        ),
        if (widget.job.rangeGaji != null &&
            widget.job.rangeGaji!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.monetization_on,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                widget.job.rangeGaji!,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildInfoCards() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildInfoCard(
            icon: Icons.work_outline,
            label: 'TIPE',
            value: widget.job.tipePekerjaan ?? '-',
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            icon: Icons.event_available_outlined,
            label: 'DEADLINE',
            value: widget.job.formattedBatasAkhir,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            icon: Icons.people_outline,
            label: 'KUOTA',
            value: widget.job.jumlahPersonText,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.accent),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textMuted,
              fontSize: 10,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 12,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyCard() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CompanyDetailScreen(job: widget.job),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child:
                    widget.job.logoPerusahaan != null &&
                        widget.job.logoPerusahaan!.isNotEmpty
                    ? Image.network(
                        widget.job.logoPerusahaan!,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.business,
                              color: AppColors.primary,
                            ),
                      )
                    : const Icon(Icons.business, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PERUSAHAAN',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  Text(
                    widget.job.perusahaan,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  if (widget.job.lokasi.isNotEmpty)
                    Text(
                      widget.job.lokasi,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    final List<String> chips = [];
    if (widget.job.jabatan != null && widget.job.jabatan!.isNotEmpty) {
      chips.add(widget.job.jabatan!);
    }
    if (widget.job.jurusan != null && widget.job.jurusan!.isNotEmpty) {
      chips.add(widget.job.jurusan!);
    }
    if (widget.job.sektor != null && widget.job.sektor!.isNotEmpty) {
      chips.add(widget.job.sektor!);
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Informasi Tambahan',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips
              .map(
                (chip) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.5),
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    chip,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deskripsi Lowongan',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.job.detailLowongan.isNotEmpty
              ? widget.job.detailLowongan
              : 'Tidak ada deskripsi tersedia.',
          style: AppTextStyles.bodyMedium.copyWith(
            height: 1.6,
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildRequirements() {
    if (widget.job.requirements.isEmpty) {
      return const SizedBox.shrink();
    }

    final reqList = widget.job.requirements
        .split(RegExp(r'\n|,|-'))
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kualifikasi:',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 16),
          ...reqList.map(
            (req) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Icon(
                      Icons.check_circle,
                      size: 18,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      req.trim(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    final bool isAktif = widget.job.isAktif;
    final bool canCancel = _isApplied && (widget.job.statusLamaran == null || widget.job.statusLamaran!.toLowerCase() == 'applied');

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 20,
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'STATUS',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isAktif ? 'DIBUKA' : 'DITUTUP',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: isAktif ? AppColors.primary : AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 32),
              Expanded(
                child: ElevatedButton(
                  onPressed: isAktif && (!_isApplied || canCancel)
                      ? () async {
                          if (_isApplied) {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Batalkan Lamaran'),
                                content: const Text(
                                  'Apakah Anda yakin ingin membatalkan lamaran untuk posisi ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Tidak'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.error,
                                    ),
                                    child: const Text('Ya, Batalkan'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true && mounted) {
                              // Show loading indicator
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => BlocProvider.value(
                                  value: _applicationBloc,
                                  child:
                                      BlocListener<
                                        JobApplicationBloc,
                                        JobApplicationState
                                      >(
                                        listener: (context, state) {
                                          if (state is JobApplicationSuccess) {
                                            Navigator.pop(
                                              context,
                                            ); // close loading
                                            setState(() {
                                              _isApplied = false;
                                            });
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Lamaran berhasil dibatalkan.',
                                                ),
                                              ),
                                            );
                                            try {
                                              context.read<JobBloc>().add(
                                                CancelJobSuccess(widget.job.id),
                                              );
                                              context.read<HomeBloc>().add(
                                                LoadHomeData(),
                                              );
                                            } catch (_) {}
                                          } else if (state
                                              is JobApplicationFailure) {
                                            Navigator.pop(
                                              context,
                                            ); // close loading
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(state.error),
                                              ),
                                            );
                                          }
                                        },
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                ),
                              );

                              _applicationBloc.add(
                                CancelApplication(widget.job.id),
                              );
                            }
                            return;
                          }

                          final applied = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobApplicationScreen(
                                lowonganId: widget.job.id,
                              ),
                            ),
                          );
                          if (applied == true && mounted) {
                            setState(() {
                              _isApplied = true;
                            });
                            try {
                              context.read<JobBloc>().add(
                                ApplyJobSuccess(widget.job.id),
                              );
                              context.read<HomeBloc>().add(LoadHomeData());
                            } catch (_) {}
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_isApplied
                        ? AppColors.primary
                        : canCancel
                            ? AppColors.error
                            : Colors.grey,
                    disabledBackgroundColor: Colors.grey[300],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    !_isApplied
                        ? 'Lamar Sekarang'
                        : canCancel
                            ? 'Batalkan Lamaran'
                            : 'Lamaran Diproses',
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
