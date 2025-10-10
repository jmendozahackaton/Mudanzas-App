import 'package:equatable/equatable.dart';

// Request Models
class LoginRequest extends Equatable {
  final String email;
  final String password;

  const LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };

  @override
  List<Object?> get props => [email, password];
}

class RegisterRequest extends Equatable {
  final String nombre;
  final String apellido;
  final String email;
  final String password;
  final String? telefono;

  const RegisterRequest({
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.password,
    this.telefono,
  });

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'password': password,
        if (telefono != null) 'telefono': telefono,
      };

  @override
  List<Object?> get props => [nombre, apellido, email, password, telefono];
}

// Response Models
class LoginResponse extends Equatable {
  final UserModel user;
  final String token;

  const LoginResponse({required this.user, required this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      user: UserModel.fromJson(json['user']),
      token: json['token'],
    );
  }

  @override
  List<Object?> get props => [user, token];
}

class UserModel extends Equatable {
  final int id;
  final String nombre;
  final String apellido;
  final String email;
  final String? telefono;
  final String? fotoPerfil;
  final String rol;

  const UserModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    this.telefono,
    this.fotoPerfil,
    required this.rol,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      telefono: json['telefono'],
      fotoPerfil: json['foto_perfil'],
      rol: json['rol'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'apellido': apellido,
        'email': email,
        'telefono': telefono,
        'foto_perfil': fotoPerfil,
        'rol': rol,
      };

  @override
  List<Object?> get props =>
      [id, nombre, apellido, email, telefono, fotoPerfil, rol];
}
