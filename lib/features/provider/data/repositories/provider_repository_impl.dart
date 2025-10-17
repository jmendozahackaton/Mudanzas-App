import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/provider_remote_data_source.dart';
import '../models/provider_models.dart';
import '../../domain/entities/provider_entities.dart';
import '../../domain/repositories/provider_repository.dart';

class ProviderRepositoryImpl implements ProviderRepository {
  final ProviderRemoteDataSource remoteDataSource;

  ProviderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProviderEntity>> registerProvider(
      Map<String, dynamic> providerData) async {
    try {
      final providerModel =
          await remoteDataSource.registerProvider(providerData);
      return Right(_mapModelToEntity(providerModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProviderEntity>> getProviderProfile() async {
    try {
      final providerModel = await remoteDataSource.getProviderProfile();
      return Right(_mapModelToEntity(providerModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProviderEntity>> updateProviderProfile(
      Map<String, dynamic> updateData) async {
    try {
      final providerModel =
          await remoteDataSource.updateProviderProfile(updateData);
      return Right(_mapModelToEntity(providerModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProviderAvailability(
      bool disponible, bool modoOcupado) async {
    try {
      await remoteDataSource.updateProviderAvailability(
          disponible, modoOcupado);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProviderLocation(
      double lat, double lng) async {
    try {
      await remoteDataSource.updateProviderLocation(lat, lng);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProviderStatisticsEntity>>
      getProviderStatistics() async {
    try {
      final statisticsModel = await remoteDataSource.getProviderStatistics();
      return Right(ProviderStatisticsEntity(
        totalServicios: statisticsModel.totalServicios,
        serviciosCompletados: statisticsModel.serviciosCompletados,
        serviciosCancelados: statisticsModel.serviciosCancelados,
        puntuacionPromedio: statisticsModel.puntuacionPromedio,
        ingresosTotales: statisticsModel.ingresosTotales,
        comisionAcumulada: statisticsModel.comisionAcumulada,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProviderEntity>>> getProviders(
      {int page = 1, int limit = 10}) async {
    try {
      final response =
          await remoteDataSource.getProviders(page: page, limit: limit);
      final providers = response.providers.map(_mapModelToEntity).toList();
      return Right(providers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProviderEntity>>> searchProvidersByLocation({
    required double lat,
    required double lng,
    double radius = 10,
    int limit = 10,
  }) async {
    try {
      final response = await remoteDataSource.searchProvidersByLocation(
        lat: lat,
        lng: lng,
        radius: radius,
        limit: limit,
      );
      final providers = response.providers.map(_mapModelToEntity).toList();
      return Right(providers);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  ProviderEntity _mapModelToEntity(ProviderModel model) {
    return ProviderEntity(
      id: model.id,
      usuarioId: model.usuarioId,
      nombre: model.nombre,
      apellido: model.apellido,
      email: model.email,
      telefono: model.telefono,
      fotoPerfil: model.fotoPerfil,
      tipoCuenta: model.tipoCuenta,
      razonSocial: model.razonSocial,
      documentoIdentidad: model.documentoIdentidad,
      licenciaConducir: model.licenciaConducir,
      categoriaLicencia: model.categoriaLicencia,
      seguroVehicular: model.seguroVehicular,
      estadoVerificacion: model.estadoVerificacion,
      nivelProveedor: model.nivelProveedor,
      puntuacionPromedio: model.puntuacionPromedio,
      totalServicios: model.totalServicios,
      serviciosCompletados: model.serviciosCompletados,
      serviciosCancelados: model.serviciosCancelados,
      ingresosTotales: model.ingresosTotales,
      comisionAcumulada: model.comisionAcumulada,
      fechaRegistro: model.fechaRegistro,
      fechaVerificacion: model.fechaVerificacion,
      radioServicio: model.radioServicio,
      tarifaBase: model.tarifaBase,
      tarifaPorKm: model.tarifaPorKm,
      tarifaHora: model.tarifaHora,
      tarifaMinima: model.tarifaMinima,
      disponible: model.disponible,
      modoOcupado: model.modoOcupado,
      enServicio: model.enServicio,
      ultimaUbicacionLat: model.ultimaUbicacionLat,
      ultimaUbicacionLng: model.ultimaUbicacionLng,
      ultimaActualizacion: model.ultimaActualizacion,
      metodosPagoAceptados: model.metodosPagoAceptados,
    );
  }
}
