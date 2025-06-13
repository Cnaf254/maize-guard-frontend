part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

final class AddExpertEvent extends HomeEvent {
  final Expert expert;

  const AddExpertEvent({
    required this.expert,
  });
}

final class UpdateExpertEvent extends HomeEvent {
  final Expert expert;

  const UpdateExpertEvent({
    required this.expert,
  });
}

final class DeleteExpertEvent extends HomeEvent {
  final String id;

  const DeleteExpertEvent({
    required this.id,
  });
}

final class GetExpertsEvent extends HomeEvent {
  const GetExpertsEvent();
}
