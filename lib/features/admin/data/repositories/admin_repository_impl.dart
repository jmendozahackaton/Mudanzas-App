import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/admin_entities.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';
import '../models/admin_models.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserListEntity>> getUsers({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response =
          await remoteDataSource.getUsers(page: page, limit: limit);

      final users = response.users
          .map((user) => UserEntity(
                id: user.id,
                uuid: user.uuid,
                nombre: user.nombre,
                apellido: user.apellido,
                email: user.email,
                telefono: user.telefono,
                fotoPerfil: user.fotoPerfil,
                fechaRegistro: user.fechaRegistro,
                ultimoAcceso: user.ultimoAcceso,
                estado: user.estado,
                rol: user.rol,
              ))
          .toList();

      final pagination = PaginationEntity(
        page: response.pagination.page,
        limit: response.pagination.limit,
        total: response.pagination.total,
        pages: response.pagination.pages,
      );

      final userListEntity = UserListEntity(
        users: users,
        pagination: pagination,
      );

      return Right(userListEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserStatus({
    required int userId,
    required String status,
  }) async {
    try {
      final request = UpdateUserStatusRequest(
        userId: userId,
        estado: status,
      );
      await remoteDataSource.updateUserStatus(request);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserRole({
    required int userId,
    required String role,
  }) async {
    try {
      final request = UpdateUserRoleRequest(
        userId: userId,
        rol: role,
      );
      await remoteDataSource.updateUserRole(request);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }
}
