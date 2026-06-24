import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/job_filter_bloc.dart';

class JobFilterBottomSheet extends StatefulWidget {
  final String? initialSektor;
  final String? initialJurusan;
  final String? initialLokasi;

  const JobFilterBottomSheet({
    super.key,
    this.initialSektor,
    this.initialJurusan,
    this.initialLokasi,
  });

  @override
  State<JobFilterBottomSheet> createState() => _JobFilterBottomSheetState();
}

class _JobFilterBottomSheetState extends State<JobFilterBottomSheet> {
  late JobFilterBloc _filterBloc;
  
  List<String> _sektorOptions = [];
  List<String> _jurusanOptions = [];
  List<String> _lokasiOptions = [];

  String? _selectedSektor;
  String? _selectedJurusan;
  String? _selectedLokasi;

  @override
  @override
  void initState() {
    super.initState();
    _selectedSektor = widget.initialSektor;
    _selectedJurusan = widget.initialJurusan;
    _selectedLokasi = widget.initialLokasi;
    _filterBloc = JobFilterBloc()..add(FetchFilterOptions());
  }

  @override
  void dispose() {
    _filterBloc.close();
    super.dispose();
  }

  void _applyFilter() {
    Navigator.pop(context, {
      'sektor': _selectedSektor,
      'jurusan': _selectedJurusan,
      'lokasi': _selectedLokasi,
    });
  }

  void _resetFilter() {
    setState(() {
      _selectedSektor = null;
      _selectedJurusan = null;
      _selectedLokasi = null;
    });
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(color: AppColors.onSurface),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: (value != null && items.contains(value)) ? value : null,
              isExpanded: true,
              hint: Text('Pilih $label', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey[500])),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.grey),
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Semua'),
                ),
                ...items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item, style: AppTextStyles.bodyMedium),
                  );
                }),
              ],
              onChanged: onChanged,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Lowongan',
                style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<JobFilterBloc, JobFilterState>(
            bloc: _filterBloc,
            builder: (context, state) {
              if (state is JobFilterLoading || state is JobFilterInitial) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (state is JobFilterLoaded) {
                _sektorOptions = state.sektorOptions;
                _jurusanOptions = state.jurusanOptions;
                _lokasiOptions = state.lokasiOptions;

                return Column(
                  children: [
                    _buildDropdown(
                      label: 'Sektor Industri',
                      value: _selectedSektor,
                      items: _sektorOptions,
                      onChanged: (val) => setState(() => _selectedSektor = val),
                    ),
                    _buildDropdown(
                      label: 'Jurusan',
                      value: _selectedJurusan,
                      items: _jurusanOptions,
                      onChanged: (val) => setState(() => _selectedJurusan = val),
                    ),
                    _buildDropdown(
                      label: 'Lokasi Kota',
                      value: _selectedLokasi,
                      items: _lokasiOptions,
                      onChanged: (val) => setState(() => _selectedLokasi = val),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resetFilter,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text('Reset', style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _applyFilter,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text('Terapkan', style: AppTextStyles.labelLarge.copyWith(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }
              return const Center(child: Text('Gagal memuat filter.'));
            },
          ),
        ],
      ),
    );
  }
}
