class UserListEntity {
  final List<UserEntity> users;
  final PaginationEntity pagination;

  UserListEntity({
    required this.users,
    required this.pagination,
  });
}

class UserEntity {
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

  UserEntity({
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
}

class PaginationEntity {
  final int page;
  final int limit;
  final int total;
  final int pages;

  PaginationEntity({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });
}
