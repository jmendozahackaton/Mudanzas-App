import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile_entity.dart';

abstract class UserRepository {
  Future<Either<Failure, UserProfileEntity>> getProfile();
  Future<Either<Failure, UserProfileEntity>> updateProfile({
    String? nombre,
    String? apellido,
    String? email,
    String? telefono,
    String? password,
  });
}
