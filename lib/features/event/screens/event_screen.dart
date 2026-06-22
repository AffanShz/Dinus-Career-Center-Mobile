import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/widgets/app_header.dart';
import 'package:dcc_mobile/features/profile/bloc/profile_bloc.dart';
import 'package:dcc_mobile/features/profile/bloc/profile_state.dart';
import '../bloc/event_bloc.dart';
import '../bloc/event_event.dart';
import '../bloc/event_state.dart';
import '../widgets/event_card.dart';

class EventScreen extends StatelessWidget {
  const EventScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventBloc()..add(LoadEvents()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
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
                child: BlocBuilder<EventBloc, EventState>(
                  builder: (context, state) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        final eventBloc = context.read<EventBloc>();
                        eventBloc.add(LoadEvents());
                        await eventBloc.stream.firstWhere((state) => state.status != EventStatus.loading);
                      },
                      child: state.status == EventStatus.loading
                          ? const Center(child: CircularProgressIndicator())
                          : state.status == EventStatus.failure
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: const [
                                    Center(
                                        child:
                                            Text('Gagal memuat event')),
                                  ],
                                )
                              : state.events.isEmpty
                                  ? ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: const [
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.all(32.0),
                                            child: Text(
                                                'Tidak ada event ditemukan'),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24.0,
                                        vertical: 16.0,
                                      ),
                                      itemCount: state.events.length + 1,
                                      itemBuilder: (context, index) {
                                        if (index == 0) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0, bottom: 24.0),
                                            child: _buildSectionHeader(),
                                          );
                                        }
                                        return EventCard(
                                          event:
                                              state.events[index - 1],
                                        );
                                      },
                                    ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Text(
      'Event Mendatang',
      style: AppTextStyles.headlineMedium,
    );
  }
}
