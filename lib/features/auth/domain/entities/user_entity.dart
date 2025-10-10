class UserEntity {
  final int id;
  final String uuid;
  final String nombre;
  final String apellido;
  final String email;
  final String? telefono;
  final String? fotoPerfil;
  final String rol;
  final DateTime fechaRegistro;
  final DateTime? ultimoAcceso;

  UserEntity({
    required this.id,
    required this.uuid,
    required this.nombre,
    required this.apellido,
    required this.email,
    this.telefono,
    this.fotoPerfil,
    required this.rol,
    required this.fechaRegistro,
    this.ultimoAcceso,
  });
}
