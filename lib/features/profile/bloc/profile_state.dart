import 'package:equatable/equatable.dart';
import '../models/profile_model.dart';

enum ProfileStatus { initial, loading, success, failure }

class ProfileState extends Equatable {
  final ProfileStatus status;
  final UserProfile? userProfile;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.userProfile,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserProfile? userProfile,
  }) {
    return ProfileState(
      status: status ?? this.status,
      userProfile: userProfile ?? this.userProfile,
    );
  }

  @override
  List<Object?> get props => [status, userProfile];
}
