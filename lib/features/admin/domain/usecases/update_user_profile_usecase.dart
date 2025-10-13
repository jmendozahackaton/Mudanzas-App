import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_entities.dart';
import '../repositories/admin_repository.dart';

class UpdateUserProfileUseCase {
  final AdminRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
      UpdateUserProfileParams params) async {
    return await repository.updateUserProfile(user: params.user);
  }
}

class UpdateUserProfileParams {
  final UserEntity user;

  UpdateUserProfileParams({required this.user});
}
