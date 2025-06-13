part of 'register_bloc.dart';

sealed class RegisterEvent {
  const RegisterEvent();
}

final class AuthRegisterEvent extends RegisterEvent {
  final User user;
  const AuthRegisterEvent({
    required this.user,
  });
}
