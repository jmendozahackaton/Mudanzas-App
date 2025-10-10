import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_entities.dart';

abstract class AdminRepository {
  Future<Either<Failure, UserListEntity>> getUsers({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, void>> updateUserStatus({
    required int userId,
    required String status,
  });

  Future<Either<Failure, void>> updateUserRole({
    required int userId,
    required String role,
  });
}
