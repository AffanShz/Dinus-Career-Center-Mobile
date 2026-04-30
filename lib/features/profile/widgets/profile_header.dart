import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import '../models/profile_model.dart';
import '../screens/edit_profile_screen.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfile userProfile;

  const ProfileHeader({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 3),
            ),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child:
                    (userProfile.photoUrl != null &&
                        userProfile.photoUrl!.isNotEmpty)
                    ? Image.network(
                        userProfile.photoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/dcc.png'),
                      )
                    : Image.asset(
                        'assets/images/dcc.png',
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          userProfile.name,
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userProfile.bidang != null && userProfile.bidang!.isNotEmpty
              ? '${userProfile.bidang}\nUniversitas Dian Nuswantoro'
              : 'Universitas Dian Nuswantoro',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 14, color: AppColors.secondary, height: 1.4),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildBadge('NIM ${userProfile.nim ?? "-"}'),
            const SizedBox(width: 8),
            _buildBadge('IPK ${userProfile.ipk ?? "0.0"}'),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE5EBF5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
