import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maize_guard_admin/features/home/domain/usecases/add_expert_usecase.dart';

import '../../domain/entities/entity.dart';
import '../../domain/usecases/delete_expert_usecase.dart';
import '../../domain/usecases/get_expert_usecase.dart';
import '../../domain/usecases/update_expert_usecase.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AddExpertUsecase addExpertUsecase;
  final UpdateExpertUsecase updateExpertUsecase;
  final GetExpertUsecase getExpertUsecase;
  final DeleteExpertUsecase deleteExpertUsecase;
  HomeBloc({
    required this.addExpertUsecase,
    required this.updateExpertUsecase,
    required this.getExpertUsecase,
    required this.deleteExpertUsecase,
  }) : super(HomeInitial()) {
    on<AddExpertEvent>((event, emit) async {
      emit(HomeInitial());
      await addExpertUsecase(event.expert).then((result) {
        result.fold(
          (failure) => emit(HomeFailureState(message: failure.message)),
          (_) =>
              emit(AddExpertSuccessState(message: 'Expert added successfully')),
        );
      });
    });
    on<UpdateExpertEvent>((event, emit) async {
      emit(HomeInitial());
      await updateExpertUsecase(event.expert).then((result) {
        result.fold(
          (failure) => emit(HomeFailureState(message: failure.message)),
          (_) => emit(
              UpdateExpertSuccessState(message: 'Expert updated successfully')),
        );
      });
    });
    on<GetExpertsEvent>((event, emit) async {
      emit(HomeInitial());
      await getExpertUsecase().then((result) {
        result.fold(
          (failure) => emit(HomeFailureState(message: failure.message)),
          (experts) => emit(GetExpertsSuccessState(experts: experts)),
        );
      });
    });
    on<DeleteExpertEvent>((event, emit) async {
      emit(HomeInitial());
      await deleteExpertUsecase(event.id).then((result) {
        result.fold(
          (failure) => emit(HomeFailureState(message: failure.message)),
          (_) => emit(
              DeleteExpertSuccessState(message: 'Expert deleted successfully')),
        );
      });
    });
  }
}
