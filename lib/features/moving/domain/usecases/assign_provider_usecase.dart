import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/moving_entities.dart';
import '../repositories/moving_repository.dart';

class AssignProviderUseCase {
  final MovingRepository repository;

  AssignProviderUseCase(this.repository);

  Future<Either<Failure, MovingEntity>> call(Map<String, dynamic> assignData) {
    return repository.assignProvider(assignData);
  }
}
