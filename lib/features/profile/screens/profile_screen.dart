import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_completion_card.dart';
import '../widgets/cv_builder_card.dart';
import '../widgets/tech_stack_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/academic_info_section.dart';
import '../widgets/education_section.dart';
import '../widgets/contact_info_section.dart';
import '../widgets/account_settings_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.status == ProfileStatus.loading &&
                state.userProfile == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ProfileStatus.failure &&
                state.userProfile == null) {
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 24.0),
                child: Column(
                  children: [
                    // 1. Profile Header
                    ProfileHeader(userProfile: profile),
                    const SizedBox(height: 32),

                    // 2. Profile Completion Card
                    if (profile.completionPercentage < 1.0) ...[
                      ProfileCompletionCard(userProfile: profile),
                      const SizedBox(height: 24),
                    ],

                    // 3. Contact Information Card
                    ContactInfoSection(
                      email: profile.email,
                      phone: profile.noHandphone,
                      city: profile.kota,
                    ),
                    const SizedBox(height: 24),

                    // 4. Academic Information Card
                    AcademicInfoSection(
                      gpa: profile.ipk,
                      nim: profile.nim,
                      bidang: profile.bidang,
                    ),
                    const SizedBox(height: 24),

                    // 5. Education History Card
                    EducationSection(
                      educationList: profile.education,
                      pendidikanTertinggi: profile.pendidikanTertinggi,
                    ),
                    const SizedBox(height: 24),

                    // 6. Skills Card
                    TechStackSection(
                        skills: profile.skills.isEmpty
                            ? [
                                'Fullstack Development',
                                'Mobile Development',
                                'UI/UX Design'
                              ]
                            : profile.skills),
                    const SizedBox(height: 24),

                    // 7. Experience Card
                    ExperienceSection(experiences: profile.experiences),
                    const SizedBox(height: 24),

                    // 7. Resume & Documents Card
                    const CVBuilderCard(),
                    const SizedBox(height: 24),

                    // 8. Account Settings Card
                    const AccountSettingsSection(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

