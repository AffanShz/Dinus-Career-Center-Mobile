import 'package:flutter/material.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/theme/text_styles.dart';
import 'package:dcc_mobile/features/auth/services/auth_service.dart';
import 'package:dcc_mobile/features/auth/screens/login.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/about_us_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/terms_conditions_screen.dart';

class AccountSettingsSection extends StatelessWidget {
  const AccountSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          _buildSettingItem(
            icon: Icons.manage_accounts_outlined,
            title: 'Edit Profil',
            onTap: () {
              final bloc = context.read<ProfileBloc>();
              final state = bloc.state;
              if (state.userProfile != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: bloc,
                      child: EditProfileScreen(profile: state.userProfile!),
                    ),
                  ),
                );
              }
            },
          ),

          const Divider(height: 1, color: AppColors.surfaceContainerHigh),
          _buildSettingItem(
            icon: Icons.info_outline_rounded,
            title: 'Tentang Kami',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()));
            },
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerHigh),
          _buildSettingItem(
            icon: Icons.policy_outlined,
            title: 'Kebijakan Privasi',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
            },
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerHigh),
          _buildSettingItem(
            icon: Icons.gavel_outlined,
            title: 'Syarat & Ketentuan',
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsConditionsScreen()));
            },
          ),
          const Divider(height: 1, color: AppColors.surfaceContainerHigh),
          _buildSettingItem(
            icon: Icons.logout_rounded,
            title: 'Keluar',
            textColor: AppColors.error,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Text('Konfirmasi', style: AppTextStyles.headlineMedium.copyWith(color: AppColors.primary)),
                    content: const Text('Apakah Anda yakin ingin keluar dari akun ini?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Batal', style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Keluar', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  );
                },
              );

              if (confirm == true && context.mounted) {
                await AuthService.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false,
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: textColor ?? AppColors.onSurfaceVariant, size: 20),
      title: Text(
        title,
        style: AppTextStyles.labelLarge.copyWith(
          color: textColor ?? AppColors.onSurface,
          fontSize: 14,
        ),
      ),
      trailing: textColor == null 
          ? const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant, size: 20)
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    );
  }
}
