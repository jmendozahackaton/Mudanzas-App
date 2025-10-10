import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_entities.dart';
import '../repositories/admin_repository.dart';

class GetUsersParams {
  final int page;
  final int limit;

  GetUsersParams({this.page = 1, this.limit = 10});
}

class GetUsersUseCase {
  final AdminRepository repository;

  GetUsersUseCase(this.repository);

  Future<Either<Failure, UserListEntity>> call(GetUsersParams params) async {
    return await repository.getUsers(
      page: params.page,
      limit: params.limit,
    );
  }
}
