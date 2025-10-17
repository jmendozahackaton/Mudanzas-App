import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/moving_entities.dart';
import '../repositories/moving_repository.dart';

class GetClientMovingsUseCase {
  final MovingRepository repository;

  GetClientMovingsUseCase(this.repository);

  Future<Either<Failure, MovingListEntity>> call(
      {int page = 1, int limit = 10}) {
    return repository.getClientMovings(page: page, limit: limit);
  }
}
