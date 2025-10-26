import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../datasources/moving_remote_data_source.dart';
import '../models/moving_models.dart';
import '../../domain/entities/moving_entities.dart';
import '../../domain/repositories/moving_repository.dart';

class MovingRepositoryImpl implements MovingRepository {
  final MovingRemoteDataSource remoteDataSource;

  MovingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MovingRequestEntity>> createMovingRequest(
      Map<String, dynamic> requestData) async {
    try {
      final requestModel =
          await remoteDataSource.createMovingRequest(requestData);
      return Right(_mapRequestModelToEntity(requestModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovingRequestListEntity>> getClientRequests(
      {int page = 1, int limit = 10}) async {
    try {
      final response =
          await remoteDataSource.getClientRequests(page: page, limit: limit);

      // ✅ SIMPLE: Usar la respuesta ya procesada del data source
      final requests = response.requests.map(_mapRequestModelToEntity).toList();

      return Right(MovingRequestListEntity(
        requests: requests,
        pagination: PaginationEntity(
          page: response.pagination.page,
          limit: response.pagination.limit,
          total: response.pagination.total,
          pages: response.pagination.pages,
        ),
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovingRequestListEntity>> getAllRequests(
      {int page = 1, int limit = 10, String? estado}) async {
    try {
      final response = await remoteDataSource.getAllRequests(
          page: page, limit: limit, estado: estado);
      final requests = response.requests.map(_mapRequestModelToEntity).toList();
      return Right(MovingRequestListEntity(
        requests: requests,
        pagination: PaginationEntity(
          page: response.pagination.page,
          limit: response.pagination.limit,
          total: response.pagination.total,
          pages: response.pagination.pages,
        ),
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovingListEntity>> getClientMovings(
      {int page = 1, int limit = 10}) async {
    try {
      final response =
          await remoteDataSource.getClientMovings(page: page, limit: limit);
      final movings = response.movings.map(_mapMovingModelToEntity).toList();
      return Right(MovingListEntity(
        movings: movings,
        pagination: PaginationEntity(
          page: response.pagination.page,
          limit: response.pagination.limit,
          total: response.pagination.total,
          pages: response.pagination.pages,
        ),
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovingListEntity>> getProviderMovings({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response =
          await remoteDataSource.getProviderMovings(page: page, limit: limit);
      final movings = response.movings.map(_mapMovingModelToEntity).toList();
      return Right(MovingListEntity(
        movings: movings,
        pagination: PaginationEntity(
          page: response.pagination.page,
          limit: response.pagination.limit,
          total: response.pagination.total,
          pages: response.pagination.pages,
        ),
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovingEntity>> updateMovingStatus(
      int mudanzaId, String estado) async {
    try {
      final movingModel =
          await remoteDataSource.updateMovingStatus(mudanzaId, estado);
      return Right(_mapMovingModelToEntity(movingModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovingEntity>> assignProvider(
      Map<String, dynamic> assignData) async {
    try {
      final movingModel = await remoteDataSource.assignProvider(assignData);
      return Right(_mapMovingModelToEntity(movingModel));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.toString()));
    }
  }

  MovingRequestEntity _mapRequestModelToEntity(MovingRequestModel model) {
    return MovingRequestEntity(
      id: model.id,
      clienteId: model.clienteId,
      codigoSolicitud: model.codigoSolicitud,
      direccionOrigen: model.direccionOrigen,
      direccionDestino: model.direccionDestino,
      latOrigen: model.latOrigen,
      lngOrigen: model.lngOrigen,
      latDestino: model.latDestino,
      lngDestino: model.lngDestino,
      descripcionItems: model.descripcionItems,
      tipoItems: model.tipoItems,
      volumenEstimado: model.volumenEstimado,
      serviciosAdicionales: model.serviciosAdicionales,
      urgencia: model.urgencia,
      fechaSolicitud: model.fechaSolicitud,
      fechaProgramada: model.fechaProgramada,
      estado: model.estado,
      cotizacionEstimada: model.cotizacionEstimada,
      distanciaEstimada: model.distanciaEstimada,
      tiempoEstimado: model.tiempoEstimado,
      tieneMudanzaAsignada: model.tieneMudanzaAsignada,
      clienteNombre: model.clienteNombre,
      clienteApellido: model.clienteApellido,
    );
  }

  MovingEntity _mapMovingModelToEntity(MovingModel model) {
    return MovingEntity(
      id: model.id,
      solicitudId: model.solicitudId,
      clienteId: model.clienteId,
      proveedorId: model.proveedorId,
      codigoMudanza: model.codigoMudanza,
      estado: model.estado,
      prioridad: model.prioridad,
      fechaSolicitud: model.fechaSolicitud,
      fechaAsignacion: model.fechaAsignacion,
      fechaInicio: model.fechaInicio,
      fechaCompletacion: model.fechaCompletacion,
      costoBase: model.costoBase,
      costoAdicional: model.costoAdicional,
      costoTotal: model.costoTotal,
      comisionPlataforma: model.comisionPlataforma,
      distanciaReal: model.distanciaReal,
      tiempoReal: model.tiempoReal,
      calificacionCliente: model.calificacionCliente,
      calificacionProveedor: model.calificacionProveedor,
      notas: model.notas,
      direccionOrigen: model.direccionOrigen,
      direccionDestino: model.direccionDestino,
      clienteNombre: model.clienteNombre,
      clienteApellido: model.clienteApellido,
      proveedorNombre: model.proveedorNombre,
      proveedorApellido: model.proveedorApellido,
    );
  }
}
