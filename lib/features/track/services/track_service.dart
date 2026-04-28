import 'package:flutter/material.dart';
import '../models/application_model.dart';

class TrackService {
  Future<List<ApplicationModel>> fetchApplications({String filter = 'Semua (12)'}) async {
    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 1));

    final List<ApplicationModel> allApplications = [
      ApplicationModel(
        role: 'Senior UX Architect',
        company: 'Skyline Tech Solutions',
        logo: 'assets/images/dcc.png',
        status: 'Interview',
        statusBg: const Color(0xFF9E9BF0).withOpacity(0.8),
        statusText: const Color(0xFF4530B2),
        currentStep: 2,
        appliedOn: '24 Oktober 2025',
        lastUpdate: 'Kemarin',
      ),
      ApplicationModel(
        role: 'Product Strategy Lead',
        company: 'Global Logistics Inc.',
        logo: 'assets/images/dcc.png',
        status: 'Reviewed',
        statusBg: const Color(0xFFD3E2FF),
        statusText: const Color(0xFF1E5BBF),
        currentStep: 1,
        appliedOn: '28 Oktober 2025',
        lastUpdate: '2 jam yang lalu',
      ),
    ];

    if (filter.contains('Semua')) return allApplications;
    if (filter.contains('Aktif')) {
      return allApplications.where((app) => app.currentStep < 3).toList();
    }
    if (filter.contains('Selesai')) {
      return allApplications.where((app) => app.currentStep == 3).toList();
    }
    
    return allApplications;
  }
}
