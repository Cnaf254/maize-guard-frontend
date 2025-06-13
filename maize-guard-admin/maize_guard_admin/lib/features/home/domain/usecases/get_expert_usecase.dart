import 'package:dartz/dartz.dart';
import 'package:maize_guard_admin/core/error/failure.dart';
import 'package:maize_guard_admin/features/home/domain/entities/entity.dart';

import '../repository/home_repository.dart';

class GetExpertUsecase {
  final HomeRepository homeRepository;

  GetExpertUsecase(this.homeRepository);

  Future<Either<Failure, List<Expert>>> call() {
    return homeRepository.getExperts();
  }
}
