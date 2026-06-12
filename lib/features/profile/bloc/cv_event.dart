import 'package:equatable/equatable.dart';
import '../models/profile_model.dart';
import '../services/cv_service.dart';

abstract class CVEvent extends Equatable {
  const CVEvent();

  @override
  List<Object> get props => [];
}

class GenerateCV extends CVEvent {
  final UserProfile profile;
  final CVTemplateType template;

  const GenerateCV({required this.profile, required this.template});

  @override
  List<Object> get props => [profile, template];
}
