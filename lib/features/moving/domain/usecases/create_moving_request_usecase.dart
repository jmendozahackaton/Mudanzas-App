import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/moving_entities.dart';
import '../repositories/moving_repository.dart';

class CreateMovingRequestUseCase {
  final MovingRepository repository;

  CreateMovingRequestUseCase(this.repository);

  Future<Either<Failure, MovingRequestEntity>> call(
      Map<String, dynamic> requestData) {
    return repository.createMovingRequest(requestData);
  }
}
