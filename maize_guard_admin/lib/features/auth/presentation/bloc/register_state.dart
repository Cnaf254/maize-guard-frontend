part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class AuthRegisterSuccessState extends RegisterState {
  final String message;

  const AuthRegisterSuccessState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class AuthRegisterFailureState extends RegisterState {
  final String message;

  const AuthRegisterFailureState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}
