import 'package:dartz/dartz.dart';
import 'package:maize_guard_admin/core/error/failure.dart';
import 'package:maize_guard_admin/features/home/domain/repository/home_repository.dart';

class DeleteExpertUsecase {
  final HomeRepository _homeRepository;

  DeleteExpertUsecase(this._homeRepository);

  Future<Either<Failure, void>> call(String id) {
    return _homeRepository.deleteExpert(id: id);
  }
}
