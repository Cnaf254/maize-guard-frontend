import 'package:dartz/dartz.dart';
import 'package:maize_guard_admin/core/error/failure.dart';
import 'package:maize_guard_admin/features/auth/domain/repository/auth_repository.dart';

class LogOutUsecase {
  final AuthRepository authRepository;

  LogOutUsecase({required this.authRepository});

  Future<Either<Failure, void>> call() {
    return authRepository.logOut();
  }
}
