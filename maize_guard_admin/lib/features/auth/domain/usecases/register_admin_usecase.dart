import 'package:dartz/dartz.dart';
import 'package:maize_guard_admin/core/error/failure.dart';

import '../entities/entities.dart';
import '../repository/auth_repository.dart';

class RegisterAdminUsecase {
  final AuthRepository authRepository;

  RegisterAdminUsecase({required this.authRepository});
  Future<Either<Failure, void>> call(User user) {
    return authRepository.registerAdmin(user);
  }
}
