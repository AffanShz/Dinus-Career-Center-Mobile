import 'package:equatable/equatable.dart';

abstract class JobEvent extends Equatable {
  const JobEvent();

  @override
  List<Object?> get props => [];
}

class LoadJobs extends JobEvent {
  final String category;
  final String query;
  final String? sektor;
  final String? jurusan;
  final String? lokasi;

  const LoadJobs({
    this.category = 'Semua',
    this.query = '',
    this.sektor,
    this.jurusan,
    this.lokasi,
  });

  @override
  List<Object?> get props => [category, query, sektor, jurusan, lokasi];
}

class ChangeCategory extends JobEvent {
  final String category;

  const ChangeCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchJobs extends JobEvent {
  final String query;

  const SearchJobs(this.query);

  @override
  List<Object?> get props => [query];
}

class ApplyJobSuccess extends JobEvent {
  final String jobId;

  const ApplyJobSuccess(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class CancelJobSuccess extends JobEvent {
  final String jobId;

  const CancelJobSuccess(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class ApplyAdvancedFilter extends JobEvent {
  final String? sektor;
  final String? jurusan;
  final String? lokasi;

  const ApplyAdvancedFilter({this.sektor, this.jurusan, this.lokasi});

  @override
  List<Object?> get props => [sektor, jurusan, lokasi];
}
