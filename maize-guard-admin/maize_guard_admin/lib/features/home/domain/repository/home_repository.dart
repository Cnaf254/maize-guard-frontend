import 'package:dartz/dartz.dart';
import 'package:maize_guard_admin/core/error/failure.dart';
import 'package:maize_guard_admin/features/home/domain/entities/entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<Expert>>> getExperts();
  Future<Either<Failure, void>> addExpert({required Expert expert});
  Future<Either<Failure, void>> updateExpert({required Expert expert});
  Future<Either<Failure, void>> deleteExpert({required String id});
}
