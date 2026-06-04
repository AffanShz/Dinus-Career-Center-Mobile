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
    on<UploadProfilePicture>(_onUploadProfilePicture);
    on<DeleteProfilePicture>(_onDeleteProfilePicture);
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
      print('ProfileBloc ERROR: _onLoadProfile: $e');
      emit(state.copyWith(status: ProfileStatus.failure));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    final previousProfile = state.userProfile;
    emit(state.copyWith(status: ProfileStatus.loading));
    try {
      await _profileService.updateProfile(event.profile);
      emit(state.copyWith(status: ProfileStatus.success, userProfile: event.profile));
    } catch (e) {
      print('ProfileBloc ERROR: _onUpdateProfile: $e');
      // Restore previous profile and emit failure so the screen can show the error
      emit(state.copyWith(
        status: ProfileStatus.failure,
        userProfile: previousProfile,
      ));
    }
  }

  Future<void> _onUploadProfilePicture(
    UploadProfilePicture event,
    Emitter<ProfileState> emit,
  ) async {
    print('DEBUG: _onUploadProfilePicture called, file: ${event.file.path}');
    if (state.userProfile == null) {
      print('WARN: _onUploadProfilePicture - state.userProfile is null, skipping');
      return;
    }
    
    final previousProfile = state.userProfile!;
    emit(state.copyWith(status: ProfileStatus.loading));
    
    try {
      // 1. Delete old picture if exists
      if (previousProfile.photoUrl != null && 
          previousProfile.photoUrl!.contains('supabase.co')) {
        await _profileService.deleteProfilePicture(previousProfile.photoUrl!);
      }
      
      // 2. Upload new picture
      final newUrl = await _profileService.uploadProfilePicture(event.file);
      
      if (newUrl != null) {
        final updatedProfile = previousProfile.copyWith(photoUrl: newUrl);
        // 3. Update profile record with new URL
        await _profileService.updateProfile(updatedProfile);
        emit(state.copyWith(status: ProfileStatus.success, userProfile: updatedProfile));
      } else {
        emit(state.copyWith(status: ProfileStatus.failure, userProfile: previousProfile));
      }
    } catch (e) {
      print('ProfileBloc ERROR: _onUploadProfilePicture: $e');
      emit(state.copyWith(status: ProfileStatus.failure, userProfile: previousProfile));
    }
  }

  Future<void> _onDeleteProfilePicture(
    DeleteProfilePicture event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.userProfile == null) return;
    
    final previousProfile = state.userProfile!;
    if (previousProfile.photoUrl == null) return;
    
    emit(state.copyWith(status: ProfileStatus.loading));
    
    try {
      // 1. Delete from storage
      if (previousProfile.photoUrl!.contains('supabase.co')) {
        await _profileService.deleteProfilePicture(previousProfile.photoUrl!);
      }
      
      // 2. Update profile record
      final updatedProfile = previousProfile.copyWith(photoUrl: '');
      await _profileService.updateProfile(updatedProfile);
      
      emit(state.copyWith(status: ProfileStatus.success, userProfile: updatedProfile));
    } catch (e) {
      print('ProfileBloc ERROR: _onDeleteProfilePicture: $e');
      emit(state.copyWith(status: ProfileStatus.failure, userProfile: previousProfile));
    }
  }
}

