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
    // ✅ VALIDAR CAMPOS REQUERIDOS
    if (json['user'] == null) {
      throw const FormatException('Campo "user" es requerido en LoginResponse');
    }
    if (json['token'] == null) {
      throw const FormatException(
          'Campo "token" es requerido en LoginResponse');
    }

    return LoginResponse(
      user: UserModel.fromJson(json['user']),
      token: json['token'] as String,
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
    // ✅ VALIDAR CAMPOS REQUERIDOS EN USER
    if (json['id'] == null) {
      throw const FormatException('Campo "id" es requerido');
    }
    if (json['nombre'] == null) {
      throw const FormatException('Campo "nombre" es requerido');
    }
    if (json['apellido'] == null) {
      throw const FormatException('Campo "apellido" es requerido');
    }
    if (json['email'] == null) {
      throw const FormatException('Campo "email" es requerido');
    }
    if (json['rol'] == null) {
      throw const FormatException('Campo "rol" es requerido');
    }

    return UserModel(
      id: json['id'] as int,
      nombre: json['nombre'] as String,
      apellido: json['apellido'] as String,
      email: json['email'] as String,
      telefono: json['telefono'],
      fotoPerfil: json['foto_perfil'],
      rol: json['rol'] as String,
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
