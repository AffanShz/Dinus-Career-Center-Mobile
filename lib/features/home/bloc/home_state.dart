import 'package:equatable/equatable.dart';
import '../../job/models/job_model.dart';
import '../models/event_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<JobModel> recommendedJobs;
  final Event? upcomingEvent;

  const HomeState({
    this.status = HomeStatus.initial,
    this.recommendedJobs = const [],
    this.upcomingEvent,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<JobModel>? recommendedJobs,
    Event? upcomingEvent,
  }) {
    return HomeState(
      status: status ?? this.status,
      recommendedJobs: recommendedJobs ?? this.recommendedJobs,
      upcomingEvent: upcomingEvent ?? this.upcomingEvent,
    );
  }

  @override
  List<Object?> get props => [
        status,
        recommendedJobs,
        upcomingEvent,
      ];
}
