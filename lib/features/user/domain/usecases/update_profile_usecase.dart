import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/user_repository.dart';

class UpdateProfileParams {
  final String? nombre;
  final String? apellido;
  final String? email;
  final String? telefono;
  final String? password;

  UpdateProfileParams({
    this.nombre,
    this.apellido,
    this.email,
    this.telefono,
    this.password,
  });
}

class UpdateProfileUseCase {
  final UserRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(
      UpdateProfileParams params) async {
    return await repository.updateProfile(
      nombre: params.nombre,
      apellido: params.apellido,
      email: params.email,
      telefono: params.telefono,
      password: params.password,
    );
  }
}
