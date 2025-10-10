class UserProfileEntity {
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

  UserProfileEntity({
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
