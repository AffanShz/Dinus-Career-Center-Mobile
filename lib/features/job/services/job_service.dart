import 'package:flutter/material.dart';
import '../models/job_model.dart';

class JobService {
  Future<List<JobModel>> fetchJobs({String category = 'Semua', String query = ''}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    final List<JobModel> allJobs = [
      JobModel(
        title: 'Senior Product Designer',
        company: 'TechNova Solutions',
        location: 'Jakarta, Indonesia',
        salary: 'Rp15jt - Rp22jt',
        isBookmarked: false,
        tags: [
          JobTag(
            label: 'HOT JOB',
            bg: const Color(0xFFFDE8D7),
            text: const Color(0xFFBC5919),
          ),
          JobTag(
            label: 'FULL-TIME',
            bg: const Color(0xFFE2E1FB),
            text: const Color(0xFF4530B2),
          ),
        ],
      ),
      JobModel(
        title: 'Software Engineer (Node.js)',
        company: 'CloudPulse Systems',
        location: 'Semarang, Indonesia',
        salary: 'Rp7jt - Rp12jt',
        isBookmarked: true,
        tags: [
          JobTag(
            label: 'ALUMNI PREFERRED',
            bg: const Color(0xFFD6E4FF),
            text: const Color(0xFF1E5BBF),
          ),
          JobTag(
            label: 'REMOTE',
            bg: const Color(0xFFE2E1FB),
            text: const Color(0xFF4530B2),
          ),
        ],
      ),
      JobModel(
        title: 'UX Researcher Internship',
        company: 'DesignFlow Studio',
        location: 'Surabaya, Indonesia',
        salary: 'Rp3jt - Rp4,5jt',
        isBookmarked: false,
        tags: [
          JobTag(
            label: 'INTERNSHIP',
            bg: const Color(0xFFE2E8F0),
            text: const Color(0xFF4A5568),
          ),
          JobTag(
            label: 'ON-SITE',
            bg: const Color(0xFFE2E1FB),
            text: const Color(0xFF4530B2),
          ),
        ],
      ),
    ];

    // Simple filtering logic
    return allJobs.where((job) {
      final matchesQuery = job.title.toLowerCase().contains(query.toLowerCase()) ||
          job.company.toLowerCase().contains(query.toLowerCase());
      
      if (category == 'Semua') return matchesQuery;
      
      final matchesCategory = job.tags.any((tag) => tag.label.toLowerCase() == category.toLowerCase());
      return matchesQuery && matchesCategory;
    }).toList();
  }
}
