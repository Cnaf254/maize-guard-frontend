part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class AddExpertSuccessState extends HomeState {
  final String message;

  const AddExpertSuccessState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class HomeFailureState extends HomeState {
  final String message;

  const HomeFailureState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class UpdateExpertSuccessState extends HomeState {
  final String message;

  const UpdateExpertSuccessState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class DeleteExpertSuccessState extends HomeState {
  final String message;

  const DeleteExpertSuccessState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

final class GetExpertsSuccessState extends HomeState {
  final List<Expert> experts;

  const GetExpertsSuccessState({
    required this.experts,
  });

  @override
  List<Object> get props => [experts];
}
