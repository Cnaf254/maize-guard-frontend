import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maize_guard_admin/features/auth/domain/usecases/register_admin_usecase.dart';

import '../../domain/entities/entities.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterAdminUsecase registerAdminUsecase;
  RegisterBloc({required this.registerAdminUsecase})
      : super(RegisterInitial()) {
    on<AuthRegisterEvent>(
      (event, emit) async {
        emit(RegisterInitial());
        var result = await registerAdminUsecase(event.user);
        result.fold((l) {
          emit(AuthRegisterFailureState(message: l.message));
        },
            (r) => emit(AuthRegisterSuccessState(
                message: "Registeration Successfull!")));
      },
    );
  }
}
