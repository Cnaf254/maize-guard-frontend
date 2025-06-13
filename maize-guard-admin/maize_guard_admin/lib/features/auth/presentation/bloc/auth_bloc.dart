import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:maize_guard_admin/features/auth/domain/usecases/is_logged_in.dart';
import 'package:maize_guard_admin/features/auth/domain/usecases/log_out_usecase.dart';
import 'package:maize_guard_admin/features/auth/domain/usecases/login_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogOutUsecase logOutUsecase;
  final IsLoggedInUsecase isLoggedInUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.logOutUsecase,
    required this.isLoggedInUsecase,
  }) : super(AuthInitial()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthInitial());
      final result = await loginUsecase(
        phone: event.phoneNumber,
        password: event.password,
      );
      result.fold(
        (failure) => emit(AuthLoginFailureState(message: failure.message)),
        (token) => emit(AuthLoginSuccessState(token: token)),
      );
    });

    on<AuthLogoutEvent>((event, emit) async {
      emit(AuthInitial());
      final result = await logOutUsecase();
      result.fold(
        (failure) => emit(AuthLogoutFailureState(message: failure.message)),
        (_) => emit(AuthLogoutSuccessState()),
      );
    });
    on<AuthCheckEvent>((event, emit) async {
      emit(AuthInitial());
      final result = await isLoggedInUsecase();
      result.fold(
        (failure) => emit(AuthCheckFailureState(message: failure.message)),
        (token) => emit(AuthCheckSuccessState(token: token)),
      );
    });
  }
}
