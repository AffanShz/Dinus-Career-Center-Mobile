import 'package:flutter/material.dart';

class ApplicationModel {
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
}
