import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/moving_entities.dart';

abstract class MovingRepository {
  Future<Either<Failure, MovingRequestEntity>> createMovingRequest(
      Map<String, dynamic> requestData);
  Future<Either<Failure, MovingRequestListEntity>> getClientRequests(
      {int page = 1, int limit = 10});
  Future<Either<Failure, MovingRequestListEntity>> getAllRequests(
      {int page = 1, int limit = 10, String? estado});
  Future<Either<Failure, MovingListEntity>> getClientMovings(
      {int page = 1, int limit = 10});
  Future<Either<Failure, MovingEntity>> updateMovingStatus(
      int mudanzaId, String estado);
  Future<Either<Failure, MovingEntity>> assignProvider(
      Map<String, dynamic> assignData);
}
