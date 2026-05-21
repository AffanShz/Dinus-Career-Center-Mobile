import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ApplicationModel {
  final String id;
  final String role;
  final String company;
  final String logo;
  final String status;
  final Color statusBg;
  final Color statusText;
  final int currentStep;
  final String appliedOn;
  final String lastUpdate;

  ApplicationModel({
    required this.id,
    required this.role,
    required this.company,
    required this.logo,
    required this.status,
    required this.statusBg,
    required this.statusText,
    required this.currentStep,
    required this.appliedOn,
    required this.lastUpdate,
  });

  factory ApplicationModel.fromMap(Map<String, dynamic> map) {
    final lowongan = map['lowongan'] as Map<String, dynamic>? ?? {};
    final perusahaan = lowongan['perusahaan'] as Map<String, dynamic>? ?? {};
    
    final statusRaw = map['status_terakhir']?.toString().toLowerCase() ?? 'applied';
    
    // Status mapping
    String statusDisplay;
    Color statusBg;
    Color statusText;
    int currentStep;

    switch (statusRaw) {
      case 'applied':
        statusDisplay = 'Applied';
        statusBg = const Color(0xFFE3F2FD);
        statusText = const Color(0xFF1976D2);
        currentStep = 0;
        break;
      case 'reviewed':
        statusDisplay = 'Reviewed';
        statusBg = const Color(0xFFD3E2FF);
        statusText = const Color(0xFF1E5BBF);
        currentStep = 1;
        break;
      case 'interview':
        statusDisplay = 'Interview';
        statusBg = const Color(0xFF9E9BF0).withOpacity(0.8);
        statusText = const Color(0xFF4530B2);
        currentStep = 2;
        break;
      case 'accepted':
        statusDisplay = 'Accepted';
        statusBg = const Color(0xFFE8F5E9);
        statusText = const Color(0xFF2E7D32);
        currentStep = 3;
        break;
      case 'rejected':
        statusDisplay = 'Rejected';
        statusBg = const Color(0xFFFFEBEE);
        statusText = const Color(0xFFC62828);
        currentStep = 3;
        break;
      default:
        statusDisplay = statusRaw.toUpperCase();
        statusBg = const Color(0xFFF5F5F5);
        statusText = const Color(0xFF616161);
        currentStep = 0;
    }

    final createdAt = DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String());
    final updatedAt = DateTime.parse(map['updated_at'] ?? map['created_at'] ?? DateTime.now().toIso8601String());

    return ApplicationModel(
      id: map['lamaran_id']?.toString() ?? '',
      role: lowongan['judul']?.toString() ?? 'Unknown Role',
      company: perusahaan['nama_perusahaan']?.toString() ?? 'Unknown Company',
      logo: perusahaan['logo_url']?.toString() ?? 'assets/images/dcc.png',
      status: statusDisplay,
      statusBg: statusBg,
      statusText: statusText,
      currentStep: currentStep,
      appliedOn: DateFormat('dd MMMM yyyy', 'id_ID').format(createdAt),
      lastUpdate: _formatLastUpdate(updatedAt),
    );
  }

  static String _formatLastUpdate(DateTime updatedAt) {
    final now = DateTime.now();
    final difference = now.difference(updatedAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else {
      return DateFormat('dd MMM', 'id_ID').format(updatedAt);
    }
  }
}
