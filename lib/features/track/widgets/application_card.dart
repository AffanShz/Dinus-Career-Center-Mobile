import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import '../models/application_model.dart';

class ApplicationCard extends StatelessWidget {
  final ApplicationModel application;

  const ApplicationCard({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    final bool isAccepted = application.status == 'Accepted';
    final bool isRejected = application.status == 'Rejected';
    final bool isCompleted = application.status == 'Completed';
    final bool isFinal = isCompleted || isRejected || isAccepted;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isRejected ? const Color(0xFFFFF8F8) : AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: isRejected 
            ? Border.all(color: const Color(0xFFFCA5A5).withOpacity(0.4), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: isRejected 
                ? const Color(0xFFEF4444).withOpacity(0.08)
                : Colors.black.withOpacity(0.04),
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ColorFiltered(
                  colorFilter: isRejected
                      ? const ColorFilter.mode(Colors.grey, BlendMode.saturation)
                      : const ColorFilter.mode(Colors.transparent, BlendMode.multiply),
                  child: Container(
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
                ),
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
                        color: isRejected ? const Color(0xFFC62828) : AppColors.primary,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      application.company,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: isRejected ? Colors.red[300] : Colors.grey[600],
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
          _buildTimeline(application.currentStep, isFinal, isCompleted, isAccepted, isRejected),
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
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    application.appliedOn,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isRejected ? Colors.grey[600] : const Color(0xFF1E293B),
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
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    application.lastUpdate,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isRejected ? const Color(0xFFC62828) : const Color(0xFF3C56C6),
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

  Widget _buildTimeline(int currentStep, bool isFinal, bool isCompleted, bool isAccepted, bool isRejected) {
    final steps = ['APPLIED', 'REVIEWED', 'INTERVIEW', isRejected ? 'DITOLAK' : 'SELESAI'];
    Color activeColor = const Color(0xFF3C56C6);
    
    if (isCompleted || isAccepted) {
      activeColor = const Color(0xFF10B981); // Green
    } else if (isRejected) {
      activeColor = const Color(0xFFEF4444); // Red
    }
    
    const inactiveColor = Color(0xFFE2E8F0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index % 2 == 0) {
          final stepIdx = index ~/ 2;
          final isStepCompleted = stepIdx <= currentStep;
          final isCurrent = stepIdx == currentStep;
          return SizedBox(
            width: 55,
            child: Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isStepCompleted ? activeColor : inactiveColor,
                    shape: BoxShape.circle,
                    border: isCurrent && !isFinal
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
                    color: isStepCompleted ? activeColor : AppColors.navInactive,
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
