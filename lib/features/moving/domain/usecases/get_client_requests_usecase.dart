import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/moving_entities.dart';
import '../repositories/moving_repository.dart';

class GetClientRequestsUseCase {
  final MovingRepository repository;

  GetClientRequestsUseCase(this.repository);

  Future<Either<Failure, MovingRequestListEntity>> call(
      {int page = 1, int limit = 10}) {
    return repository.getClientRequests(page: page, limit: limit);
  }
}
