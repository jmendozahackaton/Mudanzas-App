import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends UserEvent {}

class UpdateProfileEvent extends UserEvent {
  final String? nombre;
  final String? apellido;
  final String? email;
  final String? telefono;
  final String? password;

  const UpdateProfileEvent({
    this.nombre,
    this.apellido,
    this.email,
    this.telefono,
    this.password,
  });

  @override
  List<Object> get props => [
        if (nombre != null) nombre!,
        if (apellido != null) apellido!,
        if (email != null) email!,
        if (telefono != null) telefono!,
        if (password != null) password!,
      ];
}
