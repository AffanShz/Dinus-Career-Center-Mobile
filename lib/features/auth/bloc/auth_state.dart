import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthCancelled extends AuthState {}

class AuthOtpRequired extends AuthState {
  final String email;

  const AuthOtpRequired(this.email);

  @override
  List<Object> get props => [email];
}

class AuthRegisteredSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String error;

  const AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}
