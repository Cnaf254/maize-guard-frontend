import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maize_guard/features/help/domain/usecases/ask_usecase.dart';
import 'package:maize_guard/features/help/domain/usecases/delete_history_usecase.dart';
import 'package:maize_guard/features/help/domain/usecases/get_history_usecase.dart';
import 'package:maize_guard/features/help/domain/usecases/save_history_usecase.dart';
import 'package:maize_guard/features/help/presentation/bloc/bloc/history_bloc.dart';

import '../../domain/entities/history_entities.dart';

part 'help_event.dart';
part 'help_state.dart';

class HelpBloc extends Bloc<HelpEvent, HelpState> {
  final AskUsecase askUsecase;
  final GetHistoryUsecase getHistoryUsecase;
  final SaveHistoryUsecase saveHistoryUsecase;
  final DeleteHistoryUsecase deleteHistoryUsecase;
  List<HistoryModel> history = [];
  HelpBloc({
    required this.askUsecase,
    required this.getHistoryUsecase,
    required this.saveHistoryUsecase,
    required this.deleteHistoryUsecase,
  }) : super(HistoryInitial()) {
    on<UpdateStateEvent>(
      (event, emit) {
        history.clear();
        emit(UpdateState(
            message: "State updated successfully!",
            history: history,
            isLowProbability: false));
      },
    );
    on<AskEvent>(
      (event, emit) async {
        history.clear();
        history.insert(
            0,
            HistoryModel(
                imageLink: "",
                name: "name",
                scientificName: "scientificName",
                probability: 100,
                createdAt: "createdAt",
                uploading: true));
        emit(AskLoadingState(history: history));
        var result = await askUsecase(event.imagePath);
        result.fold((l) {
          history.removeAt(0);
          emit(HistoryErrorState(message: l.message, history: history));
        }, (r) {
          var hist = HistoryModel(
              description: r.description,
              imageLink: r.imageLink,
              name: r.name,
              scientificName: r.scientificName,
              probability: r.probability,
              createdAt: r.createdAt,
              treatments: r.treatments,
              isNew: true,
              uploading: false);
          history.removeAt(0);
          print("probability: ${r.probability}");
          if (r.probability > 75) {
            history.clear();
            history.insert(0, hist);
            emit(AskSuccessState(
                message: "Question sent successfully!",
                history: history,
                isLowProbability: false));
          } else {
            history.clear();
            history.insert(0, hist);
            emit(AskSuccessState(
                message: "Question sent successfully!",
                history: history,
                isLowProbability: true));
          }
        });
      },
    );

    on<SaveHistoryEvent>(
      (event, emit) async {
        var result = await saveHistoryUsecase(event.history);
        result.fold(
            (l) =>
                emit(HistoryErrorState(message: l.message, history: history)),
            (id) {
          for (HistoryModel his in history) {
            if (his.id == event.history.id) {
              history.remove(his);
              break;
            }
          }
          event.history.id = id;
          event.history.isNew = false;
          history.insert(0, event.history);
          emit(SaveHistorySuccessState(
              message: "Saved Successfully!", history: history));
        });
      },
    );
  }
}
