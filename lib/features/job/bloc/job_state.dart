import 'package:equatable/equatable.dart';
import '../models/job_model.dart';

enum JobStatus { initial, loading, success, failure }

class JobState extends Equatable {
  final JobStatus status;
  final List<JobModel> jobs;
  final String selectedCategory;
  final String searchQuery;

  const JobState({
    this.status = JobStatus.initial,
    this.jobs = const [],
    this.selectedCategory = 'Semua',
    this.searchQuery = '',
  });

  JobState copyWith({
    JobStatus? status,
    List<JobModel>? jobs,
    String? selectedCategory,
    String? searchQuery,
  }) {
    return JobState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object> get props => [status, jobs, selectedCategory, searchQuery];
}
