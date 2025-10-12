import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/auth_models.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, UserEntity>> login(LoginParams params) async {
    try {
      final request =
          LoginRequest(email: params.email, password: params.password);
      final response = await remoteDataSource.login(request);
      print('✅ Login exitoso, guardando token...');
      // Save token and user data
      await sharedPreferences.setString('auth_token', response.token);
      await sharedPreferences.setString(
          'user_data', jsonEncode(response.user.toJson()));

      final userEntity = UserEntity(
        id: response.user.id,
        uuid: '', // You might want to update this
        nombre: response.user.nombre,
        apellido: response.user.apellido,
        email: response.user.email,
        telefono: response.user.telefono,
        fotoPerfil: response.user.fotoPerfil,
        rol: response.user.rol,
        fechaRegistro: DateTime.now(), // Update this from API if available
        ultimoAcceso: DateTime.now(),
      );

      print('🔑 Token guardado: ${response.token.substring(0, 20)}...');
      print('👤 Usuario: ${response.user.email}');
      print('🎯 Rol: ${response.user.rol}');

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
  Future<Either<Failure, UserEntity>> register(RegisterParams params) async {
    try {
      final request = RegisterRequest(
        nombre: params.nombre,
        apellido: params.apellido,
        email: params.email,
        password: params.password,
        telefono: params.telefono,
      );

      final response = await remoteDataSource.register(request);

      // Save token and user data
      await sharedPreferences.setString('auth_token', response.token);
      await sharedPreferences.setString(
          'user_data', jsonEncode(response.user.toJson()));

      final userEntity = UserEntity(
        id: response.user.id,
        uuid: '',
        nombre: response.user.nombre,
        apellido: response.user.apellido,
        email: response.user.email,
        telefono: response.user.telefono,
        fotoPerfil: response.user.fotoPerfil,
        rol: response.user.rol,
        fechaRegistro: DateTime.now(),
        ultimoAcceso: DateTime.now(),
      );

      return Right(userEntity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      print('🔐 Cerrando sesión...');

      // ✅ LIMPIAR TODOS LOS DATOS DE AUTENTICACIÓN
      await sharedPreferences.remove('auth_token');
      await sharedPreferences.remove('user_data');

      // ✅ LIMPIAR CUALQUIER OTRO DATO RELACIONADO
      final keys = sharedPreferences.getKeys();
      for (final key in keys) {
        if (key.contains('auth') ||
            key.contains('user') ||
            key.contains('token')) {
          await sharedPreferences.remove(key);
        }
      }

      print('✅ Sesión cerrada exitosamente');
      return const Right(null);
    } catch (e) {
      print('❌ Error al cerrar sesión: $e');
      return Left(CacheFailure('Error al cerrar sesión: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final token = sharedPreferences.getString('auth_token');
      return Right(token != null && token.isNotEmpty);
    } catch (e) {
      return const Left(CacheFailure('Error al verificar sesión'));
    }
  }

  @override
  Future<Either<Failure, String>> getToken() async {
    try {
      final token = sharedPreferences.getString('auth_token');
      if (token != null) {
        return Right(token);
      } else {
        return const Left(UnauthorizedFailure('No hay token disponible'));
      }
    } catch (e) {
      return const Left(CacheFailure('Error al obtener token'));
    }
  }
}
