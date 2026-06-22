import 'package:equatable/equatable.dart';
import '../models/job_model.dart';

enum JobStatus { initial, loading, success, failure }

class JobState extends Equatable {
  final JobStatus status;
  final List<JobModel> jobs;
  final String selectedCategory;
  final String searchQuery;
  final String? selectedSektor;
  final String? selectedJurusan;
  final String? selectedLokasi;

  const JobState({
    this.status = JobStatus.initial,
    this.jobs = const [],
    this.selectedCategory = 'Semua',
    this.searchQuery = '',
    this.selectedSektor,
    this.selectedJurusan,
    this.selectedLokasi,
  });

  JobState copyWith({
    JobStatus? status,
    List<JobModel>? jobs,
    String? selectedCategory,
    String? searchQuery,
    String? selectedSektor,
    String? selectedJurusan,
    String? selectedLokasi,
  }) {
    return JobState(
      status: status ?? this.status,
      jobs: jobs ?? this.jobs,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSektor: selectedSektor ?? this.selectedSektor,
      selectedJurusan: selectedJurusan ?? this.selectedJurusan,
      selectedLokasi: selectedLokasi ?? this.selectedLokasi,
    );
  }

  @override
  List<Object?> get props => [
        status,
        jobs,
        selectedCategory,
        searchQuery,
        selectedSektor,
        selectedJurusan,
        selectedLokasi,
      ];
}
