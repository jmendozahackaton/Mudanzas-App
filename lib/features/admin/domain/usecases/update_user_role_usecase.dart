import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/admin_repository.dart';

class UpdateUserRoleParams {
  final int userId;
  final String role;

  UpdateUserRoleParams({required this.userId, required this.role});
}

class UpdateUserRoleUseCase {
  final AdminRepository repository;

  UpdateUserRoleUseCase(this.repository);

  Future<Either<Failure, void>> call(UpdateUserRoleParams params) async {
    return await repository.updateUserRole(
      userId: params.userId,
      role: params.role,
    );
  }
}
