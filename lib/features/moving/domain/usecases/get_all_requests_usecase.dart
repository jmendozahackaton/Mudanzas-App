import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/moving_entities.dart';
import '../repositories/moving_repository.dart';

class GetAllRequestsUseCase {
  final MovingRepository repository;

  GetAllRequestsUseCase(this.repository);

  Future<Either<Failure, MovingRequestListEntity>> call(
      {int page = 1, int limit = 10, String? estado}) {
    return repository.getAllRequests(page: page, limit: limit, estado: estado);
  }
}
