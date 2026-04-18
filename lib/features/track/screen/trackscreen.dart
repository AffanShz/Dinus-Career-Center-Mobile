import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TrackScreen extends StatefulWidget {
  const TrackScreen({super.key});

  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  final List<String> _filters = ['All (12)', 'Active (4)', 'Past (8)'];
  int _selectedFilterIndex = 0;

  final List<Map<String, dynamic>> _dummyApplications = [
    {
      'role': 'Senior UX Architect',
      'company': 'Skyline Tech Solutions',
      'logo': 'assets/images/dcc.png',
      'status': 'INTERVIEW\nSCHEDULED',
      'status_bg': const Color(0xFF9E9BF0).withOpacity(0.8), // Faded purple
      'status_text': const Color(0xFF4530B2), // Dark purple
      'current_step': 2, // 0: Applied, 1: Reviewed, 2: Interview, 3: Hired
      'applied_on': 'Oct 24, 2023',
      'last_update': 'Yesterday',
    },
    {
      'role': 'Product Strategy Lead',
      'company': 'Global Logistics Inc.',
      'logo': 'assets/images/dcc.png',
      'status': 'UNDER\nREVIEW',
      'status_bg': const Color(0xFFD3E2FF), // Faded blue
      'status_text': const Color(0xFF1E5BBF), // Dark blue
      'current_step': 1, // Reviewed
      'applied_on': 'Oct 28, 2023',
      'last_update': '2 hours ago',
    },
  ];

  Widget _buildTimeline(int currentStep) {
    final steps = ['APPLIED', 'REVIEWED', 'INTERVIEW', 'HIRED'];
    final activeColor = const Color(0xFF3C56C6);
    final inactiveColor = const Color(0xFFE2E8F0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index % 2 == 0) {
          int stepIdx = index ~/ 2;
          bool isCompleted = stepIdx <= currentStep;
          bool isCurrent = stepIdx == currentStep;
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
                    color: isCompleted ? activeColor : const Color(0xFFA0AEC0),
                  ),
                ),
              ],
            ),
          );
        } else {
          int lineIdx = index ~/ 2;
          bool isLineCompleted = lineIdx < currentStep;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF032D60),
                              width: 1.5,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset(
                              'assets/images/dcc.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  color: Color(0xFF032D60),
                                  size: 24,
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'DCC Mobile',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF003A75),
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFF003A75),
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Filter Chips (All, Active, Past)
                Row(
                  children: List.generate(_filters.length, (index) {
                    final isSelected = _selectedFilterIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF032D60)
                              : Colors.grey[200], // Abu-abu muda
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          _filters[index],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected ? Colors.white : Colors.grey[800],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 32),

                // Daftar status lamaran
                Column(
                  children: _dummyApplications.map((app) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.all(24),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Logo + Title + Status Pill
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF1E293B,
                                  ), // Dark bg like Skyline
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.business, // Dummy company icon
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      app['role'],
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF032D60),
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      app['company'],
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
                                  color: app['status_bg'],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  app['status'],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: app['status_text'],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),

                          // Progress Timeline
                          _buildTimeline(app['current_step']),

                          const SizedBox(height: 32),
                          const Divider(
                            color: Color(0xFFF1F5F9),
                            thickness: 1.5,
                          ),
                          const SizedBox(height: 16),

                          // Footer: Dates
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'APPLIED ON',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    app['applied_on'],
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
                                    'LAST UPDATE',
                                    style: GoogleFonts.poppins(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    app['last_update'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF3C56C6), // Blue
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
