import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/cv_builder_card.dart';
import '../widgets/tech_stack_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/education_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc()..add(LoadProfile()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state.status == ProfileStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state.status == ProfileStatus.failure) {
                return const Center(child: Text('Gagal memuat profil'));
              }

              if (state.userProfile == null) {
                return const Center(child: Text('Profil tidak ditemukan'));
              }

              final profile = state.userProfile!;

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ProfileBloc>().add(LoadProfile());
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      ProfileHeader(userProfile: profile),
                      const SizedBox(height: 32),
                      const CVBuilderCard(),
                      const SizedBox(height: 32),
                      TechStackSection(skills: profile.skills),
                      const SizedBox(height: 32),
                      ExperienceSection(experiences: profile.experiences),
                      const SizedBox(height: 32),
                      EducationSection(educationList: profile.education),
                      const SizedBox(height: 32),
                    ],
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
