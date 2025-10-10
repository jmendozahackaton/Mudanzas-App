import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserProfileEntity>> getProfile() async {
    try {
      final response = await remoteDataSource.getProfile();
      final userEntity = UserProfileEntity(
        id: response.user.id,
        uuid: response.user.uuid,
        nombre: response.user.nombre,
        apellido: response.user.apellido,
        email: response.user.email,
        telefono: response.user.telefono,
        fotoPerfil: response.user.fotoPerfil,
        fechaRegistro: response.user.fechaRegistro,
        ultimoAcceso: response.user.ultimoAcceso,
        estado: response.user.estado,
        rol: response.user.rol,
      );
      return Right(userEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateProfile({
    String? nombre,
    String? apellido,
    String? email,
    String? telefono,
    String? password,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (nombre != null) data['nombre'] = nombre;
      if (apellido != null) data['apellido'] = apellido;
      if (email != null) data['email'] = email;
      if (telefono != null) data['telefono'] = telefono;
      if (password != null) data['password'] = password;

      final response = await remoteDataSource.updateProfile(data);
      final userEntity = UserProfileEntity(
        id: response.user.id,
        uuid: response.user.uuid,
        nombre: response.user.nombre,
        apellido: response.user.apellido,
        email: response.user.email,
        telefono: response.user.telefono,
        fotoPerfil: response.user.fotoPerfil,
        fechaRegistro: response.user.fechaRegistro,
        ultimoAcceso: response.user.ultimoAcceso,
        estado: response.user.estado,
        rol: response.user.rol,
      );
      return Right(userEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    }
  }
}
