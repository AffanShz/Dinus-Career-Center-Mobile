import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dcc_mobile/core/theme/colors.dart';
import 'package:dcc_mobile/core/widgets/app_header.dart';

/// Job listing screen with search, category filter, and job cards.
class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final List<String> _categories = [
    'Semua',
    'Full-time',
    'Magang',
    'Part-time',
    'Freelance',
  ];
  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _dummyJobs = [
    {
      'title': 'Senior Product Designer',
      'company': 'TechNova Solutions',
      'location': 'Jakarta, Indonesia',
      'salary': 'Rp15jt - Rp22jt',
      'isBookmarked': false,
      'tags': [
        {
          'label': 'HOT JOB',
          'bg': const Color(0xFFFDE8D7),
          'text': const Color(0xFFBC5919),
        },
        {
          'label': 'FULL-TIME',
          'bg': const Color(0xFFE2E1FB),
          'text': const Color(0xFF4530B2),
        },
      ],
    },
    {
      'title': 'Software Engineer (Node.js)',
      'company': 'CloudPulse Systems',
      'location': 'Semarang, Indonesia',
      'salary': 'Rp7jt - Rp12jt',
      'isBookmarked': true,
      'tags': [
        {
          'label': 'ALUMNI PREFERRED',
          'bg': const Color(0xFFD6E4FF),
          'text': const Color(0xFF1E5BBF),
        },
        {
          'label': 'REMOTE',
          'bg': const Color(0xFFE2E1FB),
          'text': const Color(0xFF4530B2),
        },
      ],
    },
    {
      'title': 'UX Researcher Internship',
      'company': 'DesignFlow Studio',
      'location': 'Surabaya, Indonesia',
      'salary': 'Rp3jt - Rp4,5jt',
      'isBookmarked': false,
      'tags': [
        {
          'label': 'INTERNSHIP',
          'bg': const Color(0xFFE2E8F0),
          'text': const Color(0xFF4A5568),
        },
        {
          'label': 'ON-SITE',
          'bg': const Color(0xFFE2E1FB),
          'text': const Color(0xFF4530B2),
        },
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                // Shared app header
                const AppHeader(),
                const SizedBox(height: 32),

                // Search bar and filter button
                _buildSearchBar(),
                const SizedBox(height: 24),

                // Category chips
                _buildCategoryChips(),
                const SizedBox(height: 24),

                // Section header with count
                _buildSectionHeader(),
                const SizedBox(height: 16),

                // Job list cards
                _buildJobList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -- Search Bar --
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari lowongan',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey[500],
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.grey[500],
                  size: 26,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.tune_rounded, color: Colors.white, size: 24),
            onPressed: () {
              // TODO: Filter action
            },
          ),
        ),
      ],
    );
  }

  // -- Category Chips --
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategoryIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.secondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // -- Section Header --
  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Lowongan Tersedia',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFD6E4FF),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '142 Lowongan',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.accent,
            ),
          ),
        ),
      ],
    );
  }

  // -- Job List --
  Widget _buildJobList() {
    return Column(
      children: _dummyJobs.map((job) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Logo, Title, Bookmark
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Image.asset(
                      'assets/images/dcc.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.business),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job['title'],
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job['company'],
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.blueGrey[600],
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    job['isBookmarked']
                        ? Icons.bookmark
                        : Icons.bookmark_border_rounded,
                    color: job['isBookmarked']
                        ? AppColors.primary
                        : Colors.grey[400],
                    size: 28,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tags row
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: (job['tags'] as List).map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: tag['bg'],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag['label'],
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: tag['text'],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // Bottom row: Location, Salary
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        job['location'],
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      text: job['salary'],
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                      children: [
                        TextSpan(
                          text: '/bulan',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
