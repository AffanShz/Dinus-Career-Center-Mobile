import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/utils/dinus_email_parser.dart';
import '../models/profile_model.dart';

class PersonalInfoSection extends StatelessWidget {
  final UserProfile profile;

  const PersonalInfoSection({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Diri',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildInfoRow(
                Icons.badge_outlined,
                'No KTP',
                profile.noKtp ?? '-',
              ),
              _buildInfoRow(
                Icons.cake_outlined,
                'Tempat, Tgl Lahir',
                '${profile.tempatLahir ?? '-'}, ${profile.tanggalLahir ?? '-'}',
              ),
              _buildInfoRow(
                Icons.person_outline,
                'Jenis Kelamin',
                profile.jenisKelamin ?? '-',
              ),
              _buildInfoRow(
                Icons.location_on_outlined,
                'Alamat',
                '${profile.alamat ?? '-'}, ${profile.kota ?? '-'}',
              ),
              _buildInfoRow(
                Icons.phone_android_outlined,
                'No Handphone',
                profile.noHandphone ?? '-',
              ),
              _buildInfoRow(
                Icons.school_outlined,
                'Pendidikan',
                profile.pendidikanTertinggi ?? '-',
              ),
              _buildInfoRow(
                Icons.numbers_outlined,
                'NIM',
                _resolveNim(profile),
              ),
              _buildInfoRow(
                Icons.account_balance_outlined,
                'Jurusan / Bidang',
                _resolveBidang(profile),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Resolve NIM: prefer DB value, fallback to email parsing
  String _resolveNim(UserProfile profile) {
    if (profile.nim != null && profile.nim!.isNotEmpty) return profile.nim!;
    final parsed = DinusEmailParser.parse(profile.email);
    return parsed['nim'] ?? '-';
  }

  /// Resolve Bidang: prefer DB value, fallback to email parsing
  String _resolveBidang(UserProfile profile) {
    if (profile.bidang != null && profile.bidang!.isNotEmpty) return profile.bidang!;
    final parsed = DinusEmailParser.parse(profile.email);
    return parsed['bidang'] ?? '-';
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.accent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
