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
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      final userProfile = await _profileService.fetchUserProfile();
      emit(state.copyWith(status: ProfileStatus.success, userProfile: userProfile));
    } catch (_) {
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }
}
