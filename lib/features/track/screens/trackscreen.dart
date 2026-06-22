import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/widgets/app_header.dart';
import 'package:dcc_mobile/features/profile/bloc/profile_bloc.dart';
import 'package:dcc_mobile/features/profile/bloc/profile_state.dart';
import '../bloc/track_bloc.dart';
import '../bloc/track_event.dart';
import '../bloc/track_state.dart';
import '../widgets/status_filter.dart';
import '../widgets/application_card.dart';

class TrackScreen extends StatelessWidget {
  const TrackScreen({super.key});

  final List<String> _filters = const ['Semua', 'Aktif', 'Selesai'];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          TrackBloc()..add(const LoadApplications(filter: 'Semua')),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<TrackBloc, TrackState>(
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
                        StatusFilter(
                          filters: _filters,
                          selectedFilter: state.selectedFilter,
                          onFilterSelected: (filter) {
                            context.read<TrackBloc>().add(ChangeFilter(filter));
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        context.read<TrackBloc>().add(
                            LoadApplications(filter: state.selectedFilter));
                      },
                      child: state.status == TrackStatus.loading
                          ? const Center(child: CircularProgressIndicator())
                          : state.status == TrackStatus.failure
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: const [
                                    Center(
                                      child: Text(
                                          'Gagal memuat data pelacakan'),
                                    ),
                                  ],
                                )
                              : state.applications.isEmpty
                                  ? ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: const [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(32.0),
                                            child: Text(
                                                'Tidak ada lamaran ditemukan'),
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
                                      itemCount: state.applications.length,
                                      itemBuilder: (context, index) {
                                        return ApplicationCard(
                                          application:
                                              state.applications[index],
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
}
