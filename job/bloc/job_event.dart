import 'package:equatable/equatable.dart';

abstract class JobEvent extends Equatable {
  const JobEvent();

  @override
  List<Object> get props => [];
}

class LoadJobs extends JobEvent {
  final String category;
  final String query;

  const LoadJobs({this.category = 'Semua', this.query = ''});

  @override
  List<Object> get props => [category, query];
}

class ChangeCategory extends JobEvent {
  final String category;

  const ChangeCategory(this.category);

  @override
  List<Object> get props => [category];
}

class SearchJobs extends JobEvent {
  final String query;

  const SearchJobs(this.query);

  @override
  List<Object> get props => [query];
}

class ToggleJobBookmark extends JobEvent {
  final String jobTitle;

  const ToggleJobBookmark(this.jobTitle);

  @override
  List<Object> get props => [jobTitle];
}
