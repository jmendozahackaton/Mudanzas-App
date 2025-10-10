import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterParams {
  final String nombre;
  final String apellido;
  final String email;
  final String password;
  final String? telefono;

  RegisterParams({
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.password,
    this.telefono,
  });
}

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.register(params);
  }
}
