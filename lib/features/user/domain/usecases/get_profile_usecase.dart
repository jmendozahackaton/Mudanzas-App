import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/user_repository.dart';

class GetProfileUseCase {
  final UserRepository repository;

  GetProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> call() async {
    return await repository.getProfile();
  }
}
