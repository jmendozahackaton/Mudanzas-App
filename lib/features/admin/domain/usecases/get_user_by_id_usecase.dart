import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_entities.dart';
import '../repositories/admin_repository.dart';

class GetUserByIdUseCase {
  final AdminRepository repository;

  GetUserByIdUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(GetUserByIdParams params) async {
    return await repository.getUserById(userId: params.userId);
  }
}

class GetUserByIdParams {
  final int userId;

  GetUserByIdParams({required this.userId});
}
