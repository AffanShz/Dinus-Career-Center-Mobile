import 'package:equatable/equatable.dart';
import '../models/application_model.dart';

enum TrackStatus { initial, loading, success, failure }

class TrackState extends Equatable {
  final TrackStatus status;
  final List<ApplicationModel> applications;
  final String selectedFilter;

  const TrackState({
    this.status = TrackStatus.initial,
    this.applications = const [],
    this.selectedFilter = 'Semua (12)',
  });

  TrackState copyWith({
    TrackStatus? status,
    List<ApplicationModel>? applications,
    String? selectedFilter,
  }) {
    return TrackState(
      status: status ?? this.status,
      applications: applications ?? this.applications,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }

  @override
  List<Object> get props => [status, applications, selectedFilter];
}
