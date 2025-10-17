class ProviderEntity {
  final int id;
  final int usuarioId;
  final String nombre;
  final String apellido;
  final String email;
  final String? telefono;
  final String? fotoPerfil;
  final String tipoCuenta;
  final String? razonSocial;
  final String documentoIdentidad;
  final String licenciaConducir;
  final String categoriaLicencia;
  final String? seguroVehicular;
  final String estadoVerificacion;
  final String nivelProveedor;
  final double puntuacionPromedio;
  final int totalServicios;
  final int serviciosCompletados;
  final int serviciosCancelados;
  final double ingresosTotales;
  final double comisionAcumulada;
  final DateTime fechaRegistro;
  final DateTime? fechaVerificacion;
  final int radioServicio;
  final double tarifaBase;
  final double tarifaPorKm;
  final double tarifaHora;
  final double tarifaMinima;
  final bool disponible;
  final bool modoOcupado;
  final bool enServicio;
  final double? ultimaUbicacionLat;
  final double? ultimaUbicacionLng;
  final DateTime? ultimaActualizacion;
  final List<String> metodosPagoAceptados;

  ProviderEntity({
    required this.id,
    required this.usuarioId,
    required this.nombre,
    required this.apellido,
    required this.email,
    this.telefono,
    this.fotoPerfil,
    required this.tipoCuenta,
    this.razonSocial,
    required this.documentoIdentidad,
    required this.licenciaConducir,
    required this.categoriaLicencia,
    this.seguroVehicular,
    required this.estadoVerificacion,
    required this.nivelProveedor,
    required this.puntuacionPromedio,
    required this.totalServicios,
    required this.serviciosCompletados,
    required this.serviciosCancelados,
    required this.ingresosTotales,
    required this.comisionAcumulada,
    required this.fechaRegistro,
    this.fechaVerificacion,
    required this.radioServicio,
    required this.tarifaBase,
    required this.tarifaPorKm,
    required this.tarifaHora,
    required this.tarifaMinima,
    required this.disponible,
    required this.modoOcupado,
    required this.enServicio,
    this.ultimaUbicacionLat,
    this.ultimaUbicacionLng,
    this.ultimaActualizacion,
    required this.metodosPagoAceptados,
  });
}

class ProviderStatisticsEntity {
  final int totalServicios;
  final int serviciosCompletados;
  final int serviciosCancelados;
  final double puntuacionPromedio;
  final double ingresosTotales;
  final double comisionAcumulada;

  ProviderStatisticsEntity({
    required this.totalServicios,
    required this.serviciosCompletados,
    required this.serviciosCancelados,
    required this.puntuacionPromedio,
    required this.ingresosTotales,
    required this.comisionAcumulada,
  });
}

class ProviderLocationEntity {
  final double lat;
  final double lng;

  ProviderLocationEntity({
    required this.lat,
    required this.lng,
  });
}

class ProviderAvailabilityEntity {
  final bool disponible;
  final bool modoOcupado;

  ProviderAvailabilityEntity({
    required this.disponible,
    required this.modoOcupado,
  });
}
