import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/admin_entities.dart';
import '../repositories/admin_repository.dart';

class SearchUsersUseCase {
  final AdminRepository repository;

  SearchUsersUseCase(this.repository);

  Future<Either<Failure, UserListEntity>> call(SearchUsersParams params) async {
    return await repository.searchUsers(
      query: params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}

class SearchUsersParams {
  final String query;
  final int page;
  final int limit;

  SearchUsersParams({
    required this.query,
    this.page = 1,
    this.limit = 10,
  });
}
