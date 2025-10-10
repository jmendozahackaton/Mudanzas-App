import 'package:equatable/equatable.dart';

class UsersListResponse extends Equatable {
  final List<UserModel> users;
  final PaginationModel pagination;

  const UsersListResponse({
    required this.users,
    required this.pagination,
  });

  factory UsersListResponse.fromJson(Map<String, dynamic> json) {
    return UsersListResponse(
      users: (json['users'] as List)
          .map((user) => UserModel.fromJson(user))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }

  @override
  List<Object?> get props => [users, pagination];
}

class UserModel extends Equatable {
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

  const UserModel({
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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
    );
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

class PaginationModel extends Equatable {
  final int page;
  final int limit;
  final int total;
  final int pages;

  const PaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      page: json['page'],
      limit: json['limit'],
      total: json['total'],
      pages: json['pages'],
    );
  }

  @override
  List<Object?> get props => [page, limit, total, pages];
}

class UpdateUserStatusRequest extends Equatable {
  final int userId;
  final String estado;

  const UpdateUserStatusRequest({
    required this.userId,
    required this.estado,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'estado': estado,
      };

  @override
  List<Object?> get props => [userId, estado];
}

class UpdateUserRoleRequest extends Equatable {
  final int userId;
  final String rol;

  const UpdateUserRoleRequest({
    required this.userId,
    required this.rol,
  });

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'rol': rol,
      };

  @override
  List<Object?> get props => [userId, rol];
}
