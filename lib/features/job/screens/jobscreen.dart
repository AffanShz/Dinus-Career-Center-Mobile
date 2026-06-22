import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/widgets/app_header.dart';
import 'package:dcc_mobile/features/profile/bloc/profile_bloc.dart';
import 'package:dcc_mobile/features/profile/bloc/profile_state.dart';
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
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, profileState) {
                            return AppHeader(
                                photoUrl: profileState.userProfile?.photoUrl);
                          },
                        ),
                        const SizedBox(height: 24),
                        JobSearchBar(
                          onSearch: (query) {
                            context.read<JobBloc>().add(SearchJobs(query));
                          },
                        ),
                        const SizedBox(height: 16),
                        CategoryFilter(
                          categories: _categories,
                          selectedCategory: state.selectedCategory,
                          onCategorySelected: (category) {
                            context
                                .read<JobBloc>()
                                .add(ChangeCategory(category));
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<JobBloc>().add(LoadJobs(
                              category: state.selectedCategory,
                              query: state.searchQuery,
                            ));
                      },
                      child: state.status == JobStatus.loading
                          ? const Center(child: CircularProgressIndicator())
                          : state.status == JobStatus.failure
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: const [
                                    Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(32.0),
                                        child:
                                            Text('Gagal memuat lowongan'),
                                      ),
                                    ),
                                  ],
                                )
                              : state.jobs.isEmpty
                                  ? ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: const [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(32.0),
                                            child: Text(
                                                'Tidak ada lowongan ditemukan'),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                        vertical: 8.0,
                                      ),
                                      itemCount: state.jobs.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 16.0),
                                            child: _buildSectionHeader(
                                                state.jobs.length),
                                          );
                                        }
                                        return JobListItem(
                                          job: state.jobs[index - 1],
                                        );
                                      },
                                    ),
                    ),
                  ),
                ],
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
          style: AppTextStyles.headlineMedium.copyWith(
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
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }
}
