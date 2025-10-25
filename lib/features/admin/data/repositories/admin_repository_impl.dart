import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../provider/domain/entities/provider_entities.dart';
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
  Future<Either<Failure, ProviderListEntity>> getProviders({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final providerListResponse = await remoteDataSource.getProviders(
        page: page,
        limit: limit,
      );

      // Convertir ProviderListResponse (model) a ProviderListEntity (entity)
      final providers = providerListResponse.providers
          .map((provider) => ProviderEntity(
                id: provider.id,
                usuarioId: provider.usuarioId,
                nombre: provider.nombre,
                apellido: provider.apellido,
                email: provider.email,
                telefono: provider.telefono,
                fotoPerfil: provider.fotoPerfil,
                tipoCuenta: provider.tipoCuenta,
                razonSocial: provider.razonSocial,
                documentoIdentidad: provider.documentoIdentidad,
                licenciaConducir: provider.licenciaConducir,
                categoriaLicencia: provider.categoriaLicencia,
                seguroVehicular: provider.seguroVehicular,
                polizaSeguro: provider.polizaSeguro,
                estadoVerificacion: provider.estadoVerificacion,
                nivelProveedor: provider.nivelProveedor,
                puntuacionPromedio: provider.puntuacionPromedio,
                totalServicios: provider.totalServicios,
                serviciosCompletados: provider.serviciosCompletados,
                serviciosCancelados: provider.serviciosCancelados,
                ingresosTotales: provider.ingresosTotales,
                comisionAcumulada: provider.comisionAcumulada,
                fechaRegistro: provider.fechaRegistro,
                fechaVerificacion: provider.fechaVerificacion,
                radioServicio: provider.radioServicio,
                tarifaBase: provider.tarifaBase,
                tarifaPorKm: provider.tarifaPorKm,
                tarifaHora: provider.tarifaHora,
                tarifaMinima: provider.tarifaMinima,
                disponible: provider.disponible,
                modoOcupado: provider.modoOcupado,
                enServicio: provider.enServicio,
                ultimaUbicacionLat: provider.ultimaUbicacionLat,
                ultimaUbicacionLng: provider.ultimaUbicacionLng,
                ultimaActualizacion: provider.ultimaActualizacion,
                metodosPagoAceptados: provider.metodosPagoAceptados,
              ))
          .toList();

      final pagination = PaginationEntity(
        page: providerListResponse.pagination.page,
        limit: providerListResponse.pagination.limit,
        total: providerListResponse.pagination.total,
        pages: providerListResponse.pagination.pages,
      );

      final providerListEntity = ProviderListEntity(
        providers: providers,
        pagination: pagination,
      );

      return Right(providerListEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
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

  @override
  Future<Either<Failure, UserListEntity>> searchUsers({
    required String query,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.searchUsers(
        query: query,
        page: page,
        limit: limit,
      );
      return _mapResponseToEntity(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getUserById({
    required int userId,
  }) async {
    try {
      final response = await remoteDataSource.getUserById(userId: userId);

      final user = UserEntity(
        id: response.id,
        uuid: response.uuid,
        nombre: response.nombre,
        apellido: response.apellido,
        email: response.email,
        telefono: response.telefono,
        fotoPerfil: response.fotoPerfil,
        fechaRegistro: response.fechaRegistro,
        ultimoAcceso: response.ultimoAcceso,
        estado: response.estado,
        rol: response.rol,
      );

      return Right(user);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateUserProfile({
    required UserEntity user,
  }) async {
    try {
      final response = await remoteDataSource.updateUserProfile(user: user);

      final updatedUser = UserEntity(
        id: response.id,
        uuid: response.uuid,
        nombre: response.nombre,
        apellido: response.apellido,
        email: response.email,
        telefono: response.telefono,
        fotoPerfil: response.fotoPerfil,
        fechaRegistro: response.fechaRegistro,
        ultimoAcceso: response.ultimoAcceso,
        estado: response.estado,
        rol: response.rol,
      );

      return Right(updatedUser);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }

  Either<Failure, UserListEntity> _mapResponseToEntity(
      UsersListResponse response) {
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
  }
}
