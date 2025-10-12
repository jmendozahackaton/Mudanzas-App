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
    // ✅ VALIDAR CAMPOS REQUERIDOS
    if (json['id'] == null) throw FormatException('Campo "id" es requerido');
    if (json['nombre'] == null)
      throw FormatException('Campo "nombre" es requerido');
    if (json['apellido'] == null)
      throw FormatException('Campo "apellido" es requerido');
    if (json['email'] == null)
      throw FormatException('Campo "email" es requerido');
    if (json['rol'] == null) throw FormatException('Campo "rol" es requerido');

    return UserProfileModel(
      id: json['id'] as int,
      uuid: json['uuid'] as String? ??
          '', // Proporcionar valor por defecto si es null
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      email: json['email'] as String,
      telefono: json['telefono'],
      fotoPerfil: json['foto_perfil'],
      fechaRegistro: DateTime.parse(
          json['fecha_registro'] as String? ?? DateTime.now().toString()),
      ultimoAcceso: json['ultimo_acceso'] != null
          ? DateTime.parse(json['ultimo_acceso'] as String)
          : null,
      estado: json['estado'] as String? ?? 'activo',
      rol: json['rol'] as String,
      password:
          json['password'] as String? ?? '', // Proporcionar valor por defecto
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
