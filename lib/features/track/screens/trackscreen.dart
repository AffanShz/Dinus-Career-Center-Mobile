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
      create: (context) => TrackBloc()..add(const LoadApplications(filter: 'Semua')),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<TrackBloc, TrackState>(
            builder: (context, state) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TrackBloc>().add(LoadApplications(filter: state.selectedFilter));
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
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, profileState) {
                            return AppHeader(
                                photoUrl: profileState.userProfile?.photoUrl);
                          },
                        ),
                        const SizedBox(height: 32),
                        StatusFilter(
                          filters: _filters,
                          selectedFilter: state.selectedFilter,
                          onFilterSelected: (filter) {
                            context.read<TrackBloc>().add(ChangeFilter(filter));
                          },
                        ),
                        const SizedBox(height: 32),
                        if (state.status == TrackStatus.loading)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: CircularProgressIndicator(),
                            ),
                          )
                        else if (state.status == TrackStatus.failure)
                          const Center(child: Text('Gagal memuat data pelacakan'))
                        else if (state.applications.isEmpty)
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text('Tidak ada lamaran ditemukan'),
                            ),
                          )
                        else
                          Column(
                            children: state.applications
                                .map((app) => ApplicationCard(application: app))
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
}
