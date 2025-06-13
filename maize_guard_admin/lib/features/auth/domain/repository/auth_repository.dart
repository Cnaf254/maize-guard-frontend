import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/entities.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> login({
    required String phone,
    required String password,
  });
  Future<Either<Failure, void>> logOut();
  Future<Either<Failure, String>> isLoggedIn();
  Future<Either<Failure, void>> registerAdmin(User user);
}
