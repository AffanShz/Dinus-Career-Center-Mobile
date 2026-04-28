import 'package:flutter/material.dart';

class JobTag {
  final String label;
  final Color bg;
  final Color text;

  JobTag({
    required this.label,
    required this.bg,
    required this.text,
  });
}

class JobModel {
  final String title;
  final String company;
  final String location;
  final String salary;
  final bool isBookmarked;
  final List<JobTag> tags;

  JobModel({
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.isBookmarked,
    required this.tags,
  });

  JobModel copyWith({
    String? title,
    String? company,
    String? location,
    String? salary,
    bool? isBookmarked,
    List<JobTag>? tags,
  }) {
    return JobModel(
      title: title ?? this.title,
      company: company ?? this.company,
      location: location ?? this.location,
      salary: salary ?? this.salary,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      tags: tags ?? this.tags,
    );
  }
}
