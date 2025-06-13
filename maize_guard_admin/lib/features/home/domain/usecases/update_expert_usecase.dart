import 'package:dartz/dartz.dart';
import 'package:maize_guard_admin/core/error/failure.dart';
import 'package:maize_guard_admin/features/home/domain/entities/entity.dart';
import 'package:maize_guard_admin/features/home/domain/repository/home_repository.dart';

class UpdateExpertUsecase {
  final HomeRepository _homeRepository;

  UpdateExpertUsecase(this._homeRepository);

  Future<Either<Failure, void>> call(Expert expert) {
    return _homeRepository.updateExpert(expert: expert);
  }
}
