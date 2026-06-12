import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/widgets/app_header.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/greeting_section.dart';
import '../widgets/profile_card.dart';
import '../widgets/recommended_jobs.dart';
import '../widgets/upcoming_events.dart';

/// Home screen displaying greeting, profile completeness,
/// recommended jobs, and upcoming events.
class Homescreen extends StatelessWidget {
  final VoidCallback? onSeeAllJobs;

  const Homescreen({super.key, this.onSeeAllJobs});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(LoadHomeData()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.status == HomeStatus.initial ||
                  state.status == HomeStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == HomeStatus.failure) {
                return const Center(child: Text('Gagal memuat data'));
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<HomeBloc>().add(LoadHomeData());
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
                        // Shared app header
                        AppHeader(photoUrl: state.userProfile?.photoUrl),
                        const SizedBox(height: 32),

                        // Greeting section
                        GreetingSection(userName: state.userName),
                        const SizedBox(height: 32),

                        // Profile completeness card
                        if (state.userProfile != null && state.userProfile!.completionPercentage < 1.0) ...[
                          ProfileCard(userProfile: state.userProfile),
                          const SizedBox(height: 32),
                        ],

                        // Recommended jobs section
                        RecommendedJobs(
                          jobs: state.recommendedJobs,
                          onBookmarkToggle: (jobId) {
                            context.read<HomeBloc>().add(ToggleJobBookmark(jobId));
                          },
                          onSeeAll: onSeeAllJobs,
                        ),
                        const SizedBox(height: 32),

                        // Upcoming events section
                        if (state.upcomingEvent != null) ...[
                          UpcomingEvents(event: state.upcomingEvent!),
                          const SizedBox(height: 32),
                        ],
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
}
