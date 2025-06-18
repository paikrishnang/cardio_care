part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class AppStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested(this.email, this.password);
}

class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;

  AuthRegisterRequested(this.email, this.password);
}

class AuthLogoutRequested extends AuthEvent {}
