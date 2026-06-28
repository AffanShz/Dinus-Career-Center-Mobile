import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/widgets/app_header.dart';
import 'package:dcc_mobile/features/profile/bloc/profile_bloc.dart';
import 'package:dcc_mobile/features/profile/bloc/profile_event.dart';
import 'package:dcc_mobile/features/profile/bloc/profile_state.dart';
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
    return Scaffold(
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

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      builder: (context, profileState) {
                        return AppHeader(
                            photoUrl: profileState.userProfile?.photoUrl);
                      },
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        final homeBloc = context.read<HomeBloc>();
                        final profileBloc = context.read<ProfileBloc>();
                        
                        homeBloc.add(LoadHomeData());
                        profileBloc.add(LoadProfile());
                        
                        // Use Future.any to prevent RefreshIndicator from hanging
                        // if the state transitions too quickly before firstWhere catches it.
                        await Future.any([
                          Future.wait([
                            homeBloc.stream.firstWhere((state) => state.status != HomeStatus.loading),
                            profileBloc.stream.firstWhere((state) => state.status != ProfileStatus.loading),
                          ]),
                          Future.delayed(const Duration(seconds: 2)),
                        ]);
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
                              const SizedBox(height: 16),
                              // Greeting + profile completeness — sumber profil
                              // tunggal dari ProfileBloc.
                              BlocBuilder<ProfileBloc, ProfileState>(
                                builder: (context, profileState) {
                                  final userProfile = profileState.userProfile;
                                  final name = userProfile?.name;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GreetingSection(
                                        userName: (name != null &&
                                                name.isNotEmpty)
                                            ? name
                                            : 'User DCC',
                                      ),
                                      const SizedBox(height: 32),
                                      if (userProfile != null &&
                                          userProfile.completionPercentage <
                                              1.0) ...[
                                        ProfileCard(userProfile: userProfile),
                                        const SizedBox(height: 32),
                                      ],
                                    ],
                                  );
                                },
                              ),

                              // Recommended jobs section
                              RecommendedJobs(
                                jobs: state.recommendedJobs,
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
                    ),
                  ),
                ],
              );
            },
          ),
      ),
    );
  }
}
