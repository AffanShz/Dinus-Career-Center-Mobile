import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import '../models/application_model.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Logo + Title + Status pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                  image: application.logo.startsWith('http')
                      ? DecorationImage(
                          image: NetworkImage(application.logo),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: application.logo.startsWith('http')
                    ? null
                    : const Icon(Icons.business, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      application.role,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      application.company,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: application.statusBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  application.status,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: application.statusText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Progress timeline
          _buildTimeline(application.currentStep),
          const SizedBox(height: 32),

          const Divider(color: AppColors.divider, thickness: 1.5),
          const SizedBox(height: 16),

          // Footer: Dates
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dilamar Pada',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    application.appliedOn,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'UPDATE TERAKHIR',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    application.lastUpdate,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF3C56C6),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(int currentStep) {
    final steps = ['APPLIED', 'REVIEWED', 'INTERVIEW', 'SELESAI'];
    const activeColor = Color(0xFF3C56C6);
    const inactiveColor = Color(0xFFE2E8F0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index % 2 == 0) {
          final stepIdx = index ~/ 2;
          final isCompleted = stepIdx <= currentStep;
          final isCurrent = stepIdx == currentStep;
          return SizedBox(
            width: 55,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted ? activeColor : inactiveColor,
                    shape: BoxShape.circle,
                    border: isCurrent
                        ? Border.all(
                            color: activeColor.withOpacity(0.3),
                            width: 6,
                          )
                        : Border.all(color: Colors.transparent, width: 6),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  steps[stepIdx],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: isCompleted ? activeColor : AppColors.navInactive,
                  ),
                ),
              ],
            ),
          );
        } else {
          final lineIdx = index ~/ 2;
          final isLineCompleted = lineIdx < currentStep;
          return Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 10),
              height: 4,
              decoration: BoxDecoration(
                color: isLineCompleted ? activeColor : inactiveColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }
      }),
    );
  }
}
