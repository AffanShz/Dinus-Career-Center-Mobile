import 'dart:io';
import 'package:equatable/equatable.dart';
import '../models/profile_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final UserProfile profile;

  const UpdateProfile(this.profile);

  @override
  List<Object?> get props => [profile];
}

class UploadProfilePicture extends ProfileEvent {
  final File file;

  const UploadProfilePicture(this.file);

  @override
  List<Object?> get props => [file];
}

class DeleteProfilePicture extends ProfileEvent {
  const DeleteProfilePicture();
}

