part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AuthLoginEvent extends AuthEvent {
  final String phoneNumber;
  final String password;

  const AuthLoginEvent({
    required this.phoneNumber,
    required this.password,
  });
}

final class AuthLogoutEvent extends AuthEvent {
  const AuthLogoutEvent();
}

final class AuthCheckEvent extends AuthEvent {
  const AuthCheckEvent();
}
