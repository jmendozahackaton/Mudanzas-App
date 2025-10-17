import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/moving_entities.dart';
import '../repositories/moving_repository.dart';

class UpdateMovingStatusUseCase {
  final MovingRepository repository;

  UpdateMovingStatusUseCase(this.repository);

  Future<Either<Failure, MovingEntity>> call(int mudanzaId, String estado) {
    return repository.updateMovingStatus(mudanzaId, estado);
  }
}
