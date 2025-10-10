import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';

class UpdateUserStatusParams {
  final int userId;
  final String status;

  UpdateUserStatusParams({required this.userId, required this.status});
}

class UpdateUserStatusUseCase {
  final AdminRepository repository;

  UpdateUserStatusUseCase(this.repository);

  Future<Either<Failure, void>> call(UpdateUserStatusParams params) async {
    return await repository.updateUserStatus(
      userId: params.userId,
      status: params.status,
    );
  }
}
