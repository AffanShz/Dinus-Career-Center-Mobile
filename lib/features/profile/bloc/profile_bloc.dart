import 'package:flutter_bloc/flutter_bloc.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import '../services/profile_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileService _profileService;

  ProfileBloc({ProfileService? profileService})
      : _profileService = profileService ?? ProfileService(),
        super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final profile = await _profileService.fetchUserProfile();
      emit(state.copyWith(status: ProfileStatus.success, userProfile: profile));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await _profileService.updateProfile(event.profile);
      emit(state.copyWith(status: ProfileStatus.success, userProfile: event.profile));
    } catch (e) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }
}

