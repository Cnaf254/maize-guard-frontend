import 'package:dartz/dartz.dart';
import 'package:maize_guard_admin/core/error/failure.dart';
import 'package:maize_guard_admin/features/auth/domain/repository/auth_repository.dart';

final class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase({
    required this.repository,
  });

  Future<Either<Failure, String>> call({
    required String phone,
    required String password,
  }) {
    return repository.login(
      phone: phone,
      password: password,
    );
  }
}
