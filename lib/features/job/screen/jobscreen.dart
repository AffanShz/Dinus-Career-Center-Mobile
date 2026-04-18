import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  final List<String> _categories = [
    'All Jobs',
    'Full-time',
    'Internship',
    'Part-time',
    'Freelance'
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
        {'label': 'HOT JOB', 'bg': const Color(0xFFFDE8D7), 'text': const Color(0xFFBC5919)},
        {'label': 'FULL-TIME', 'bg': const Color(0xFFE2E1FB), 'text': const Color(0xFF4530B2)},
      ],
    },
    {
      'title': 'Software Engineer (Node.js)',
      'company': 'CloudPulse Systems',
      'location': 'Semarang, Indonesia',
      'salary': 'Rp7jt - Rp12jt',
      'isBookmarked': true,
      'tags': [
        {'label': 'ALUMNI PREFERRED', 'bg': const Color(0xFFD6E4FF), 'text': const Color(0xFF1E5BBF)},
        {'label': 'REMOTE', 'bg': const Color(0xFFE2E1FB), 'text': const Color(0xFF4530B2)},
      ],
    },
    {
      'title': 'UX Researcher Internship',
      'company': 'DesignFlow Studio',
      'location': 'Surabaya, Indonesia',
      'salary': 'Rp3jt - Rp4,5jt',
      'isBookmarked': false,
      'tags': [
        {'label': 'INTERNSHIP', 'bg': const Color(0xFFE2E8F0), 'text': const Color(0xFF4A5568)},
        {'label': 'ON-SITE', 'bg': const Color(0xFFE2E1FB), 'text': const Color(0xFF4530B2)},
      ],
    },
  ];

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
                // Header: Avatar, Name, Notification
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
                                // Fallback icon jika image tidak ditemukan saat development
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
                      color: Color(0xFF032D60),
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Search Bar and Filter
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search dream jobs...',
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
                        color: const Color(0xFF032D60),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF032D60).withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {
                          // TODO: Filter action
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Daftar Kategori / Chip
                SizedBox(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF032D60) // Biru tua bila terpilih
                                : Colors.grey[200], // Abu abu bila tidak terpilih
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              _categories[index],
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight:
                                    isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF424751),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                
                // Header Title List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Opportunity for you',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF032D60),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6E4FF),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '142 FOUND',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E5BBF),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Job List Cards
                Column(
                  children: _dummyJobs.map((job) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
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
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Image.asset(
                                  'assets/images/dcc.png', // ganti dengan path logo company asli nantinya
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.business), // fallback
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
                                        color: const Color(0xFF032D60),
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
                                    ? const Color(0xFF032D60)
                                    : Colors.grey[400],
                                size: 28,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          
                          // Tags Row
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
                                    color: const Color(0xFF1E5BBF), // biru terang
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '/mo',
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
                ),
              ], // Ini yang kurang
            ),
          ),
        ),
      ),
    );
  }
}
