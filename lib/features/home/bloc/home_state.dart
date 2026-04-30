import 'package:equatable/equatable.dart';
import '../../job/models/job_model.dart';
import '../models/event_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final String userName;
  final double profileCompleteness;
  final List<JobModel> recommendedJobs;
  final Event? upcomingEvent;

  const HomeState({
    this.status = HomeStatus.initial,
    this.userName = '',
    this.profileCompleteness = 0.0,
    this.recommendedJobs = const [],
    this.upcomingEvent,
  });

  HomeState copyWith({
    HomeStatus? status,
    String? userName,
    double? profileCompleteness,
    List<JobModel>? recommendedJobs,
    Event? upcomingEvent,
  }) {
    return HomeState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      profileCompleteness: profileCompleteness ?? this.profileCompleteness,
      recommendedJobs: recommendedJobs ?? this.recommendedJobs,
      upcomingEvent: upcomingEvent ?? this.upcomingEvent,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userName,
        profileCompleteness,
        recommendedJobs,
        upcomingEvent,
      ];
}
