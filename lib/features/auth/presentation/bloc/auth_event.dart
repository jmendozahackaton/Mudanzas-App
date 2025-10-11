import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthEvent {
  final String nombre;
  final String apellido;
  final String email;
  final String password;
  final String? telefono;

  const RegisterEvent({
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.password,
    this.telefono,
  });

  @override
  List<Object> get props => [nombre, apellido, email, password];
}

class LogoutEvent extends AuthEvent {}

class CheckAuthStatusEvent extends AuthEvent {}

class UpdateAuthUserEvent extends AuthEvent {
  final UserEntity user;

  const UpdateAuthUserEvent({required this.user});

  @override
  List<Object> get props => [user];
}
