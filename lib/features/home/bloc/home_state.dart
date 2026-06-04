import 'package:equatable/equatable.dart';
import '../../job/models/job_model.dart';
import '../../profile/models/profile_model.dart';
import '../models/event_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final String userName;
  final double profileCompleteness;
  final UserProfile? userProfile;
  final List<JobModel> recommendedJobs;
  final Event? upcomingEvent;

  const HomeState({
    this.status = HomeStatus.initial,
    this.userName = '',
    this.profileCompleteness = 0.0,
    this.userProfile,
    this.recommendedJobs = const [],
    this.upcomingEvent,
  });

  HomeState copyWith({
    HomeStatus? status,
    String? userName,
    double? profileCompleteness,
    UserProfile? userProfile,
    List<JobModel>? recommendedJobs,
    Event? upcomingEvent,
  }) {
    return HomeState(
      status: status ?? this.status,
      userName: userName ?? this.userName,
      profileCompleteness: profileCompleteness ?? this.profileCompleteness,
      userProfile: userProfile ?? this.userProfile,
      recommendedJobs: recommendedJobs ?? this.recommendedJobs,
      upcomingEvent: upcomingEvent ?? this.upcomingEvent,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userName,
        profileCompleteness,
        userProfile,
        recommendedJobs,
        upcomingEvent,
      ];
}
