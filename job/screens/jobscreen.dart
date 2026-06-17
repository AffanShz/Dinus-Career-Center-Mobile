import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/widgets/app_header.dart';
import '../bloc/job_bloc.dart';
import '../bloc/job_event.dart';
import '../bloc/job_state.dart';
import '../widgets/job_search_bar.dart';
import '../widgets/category_filter.dart';
import '../widgets/job_list_item.dart';

class JobScreen extends StatelessWidget {
  const JobScreen({super.key});

  final List<String> _categories = const [
    'Semua',
    'Full-time',
    'Magang',
    'Part-time',
    'Freelance',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobBloc()..add(const LoadJobs()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<JobBloc, JobState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<JobBloc>().add(LoadJobs(
                        category: state.selectedCategory,
                        query: state.searchQuery,
                      ));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const AppHeader(),
                        const SizedBox(height: 32),
                        JobSearchBar(
                          onSearch: (query) {
                            context.read<JobBloc>().add(SearchJobs(query));
                          },
                        ),
                        const SizedBox(height: 24),
                        CategoryFilter(
                          categories: _categories,
                          selectedCategory: state.selectedCategory,
                          onCategorySelected: (category) {
                            context.read<JobBloc>().add(ChangeCategory(category));
                          },
                        ),
                        const SizedBox(height: 24),
                        _buildSectionHeader(state.jobs.length),
                        const SizedBox(height: 16),
                        if (state.status == JobStatus.loading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state.status == JobStatus.failure)
                          const Center(child: Text('Gagal memuat lowongan'))
                        else if (state.jobs.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text('Tidak ada lowongan ditemukan'),
                            ),
                          )
                        else
                          Column(
                            children: state.jobs
                                .map((job) => JobListItem(
                                      job: job,
                                    ))
                                .toList(),

                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Lowongan Tersedia',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFD6E4FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count Lowongan',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}
