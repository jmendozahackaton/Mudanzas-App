import 'package:equatable/equatable.dart';

class UserProfileResponse extends Equatable {
  final UserProfileModel user;

  const UserProfileResponse({required this.user});

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      user: UserProfileModel.fromJson(json['user']),
    );
  }

  @override
  List<Object?> get props => [user];
}

class UserProfileModel extends Equatable {
  final int id;
  final String uuid;
  final String nombre;
  final String apellido;
  final String email;
  final String? telefono;
  final String? fotoPerfil;
  final DateTime fechaRegistro;
  final DateTime? ultimoAcceso;
  final String estado;
  final String rol;
  final String password;

  const UserProfileModel({
    required this.id,
    required this.uuid,
    required this.nombre,
    required this.apellido,
    required this.email,
    this.telefono,
    this.fotoPerfil,
    required this.fechaRegistro,
    this.ultimoAcceso,
    required this.estado,
    required this.rol,
    required this.password,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'],
      uuid: json['uuid'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      telefono: json['telefono'],
      fotoPerfil: json['foto_perfil'],
      fechaRegistro: DateTime.parse(json['fecha_registro']),
      ultimoAcceso: json['ultimo_acceso'] != null
          ? DateTime.parse(json['ultimo_acceso'])
          : null,
      estado: json['estado'],
      rol: json['rol'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'telefono': telefono,
        'password': password,
      };

  Map<String, dynamic> toUpdateJson() {
    final map = <String, dynamic>{};
    map['nombre'] = nombre;
    map['apellido'] = apellido;
    map['email'] = email;
    if (telefono != null) map['telefono'] = telefono;
    map['password'] = password;
    return map;
  }

  @override
  List<Object?> get props => [
        id,
        uuid,
        nombre,
        apellido,
        email,
        telefono,
        fotoPerfil,
        fechaRegistro,
        ultimoAcceso,
        estado,
        rol,
      ];
}
