import 'package:equatable/equatable.dart';

class ProviderModel extends Equatable {
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

  const ProviderModel({
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

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'],
      usuarioId: json['usuario_id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      email: json['email'],
      telefono: json['telefono'],
      fotoPerfil: json['foto_perfil'],
      tipoCuenta: json['tipo_cuenta'],
      razonSocial: json['razon_social'],
      documentoIdentidad: json['documento_identidad'],
      licenciaConducir: json['licencia_conducir'],
      categoriaLicencia: json['categoria_licencia'],
      seguroVehicular: json['seguro_vehicular'],
      estadoVerificacion: json['estado_verificacion'],
      nivelProveedor: json['nivel_proveedor'],
      puntuacionPromedio:
          (json['puntuacion_promedio'] as num?)?.toDouble() ?? 0.0,
      totalServicios: json['total_servicios'] ?? 0,
      serviciosCompletados: json['servicios_completados'] ?? 0,
      serviciosCancelados: json['servicios_cancelados'] ?? 0,
      ingresosTotales: (json['ingresos_totales'] as num?)?.toDouble() ?? 0.0,
      comisionAcumulada:
          (json['comision_acumulada'] as num?)?.toDouble() ?? 0.0,
      fechaRegistro: DateTime.parse(json['fecha_registro']),
      fechaVerificacion: json['fecha_verificacion'] != null
          ? DateTime.parse(json['fecha_verificacion'])
          : null,
      radioServicio: json['radio_servicio'] ?? 10,
      tarifaBase: (json['tarifa_base'] as num?)?.toDouble() ?? 0.0,
      tarifaPorKm: (json['tarifa_por_km'] as num?)?.toDouble() ?? 0.0,
      tarifaHora: (json['tarifa_hora'] as num?)?.toDouble() ?? 0.0,
      tarifaMinima: (json['tarifa_minima'] as num?)?.toDouble() ?? 0.0,
      disponible: json['disponible'] ?? false,
      modoOcupado: json['modo_ocupado'] ?? false,
      enServicio: json['en_servicio'] ?? false,
      ultimaUbicacionLat: (json['ultima_ubicacion_lat'] as num?)?.toDouble(),
      ultimaUbicacionLng: (json['ultima_ubicacion_lng'] as num?)?.toDouble(),
      ultimaActualizacion: json['ultima_actualizacion'] != null
          ? DateTime.parse(json['ultima_actualizacion'])
          : null,
      metodosPagoAceptados:
          List<String>.from(json['metodos_pago_aceptados'] ?? []),
    );
  }

  @override
  List<Object?> get props => [
        id,
        usuarioId,
        nombre,
        apellido,
        email,
        telefono,
        fotoPerfil,
        tipoCuenta,
        razonSocial,
        documentoIdentidad,
        licenciaConducir,
        categoriaLicencia,
        seguroVehicular,
        estadoVerificacion,
        nivelProveedor,
        puntuacionPromedio,
        totalServicios,
        serviciosCompletados,
        serviciosCancelados,
        ingresosTotales,
        comisionAcumulada,
        fechaRegistro,
        fechaVerificacion,
        radioServicio,
        tarifaBase,
        tarifaPorKm,
        tarifaHora,
        tarifaMinima,
        disponible,
        modoOcupado,
        enServicio,
        ultimaUbicacionLat,
        ultimaUbicacionLng,
        ultimaActualizacion,
        metodosPagoAceptados,
      ];
}

class ProviderStatisticsModel extends Equatable {
  final int totalServicios;
  final int serviciosCompletados;
  final int serviciosCancelados;
  final double puntuacionPromedio;
  final double ingresosTotales;
  final double comisionAcumulada;

  const ProviderStatisticsModel({
    required this.totalServicios,
    required this.serviciosCompletados,
    required this.serviciosCancelados,
    required this.puntuacionPromedio,
    required this.ingresosTotales,
    required this.comisionAcumulada,
  });

  factory ProviderStatisticsModel.fromJson(Map<String, dynamic> json) {
    return ProviderStatisticsModel(
      totalServicios: json['total_servicios'] ?? 0,
      serviciosCompletados: json['servicios_completados'] ?? 0,
      serviciosCancelados: json['servicios_cancelados'] ?? 0,
      puntuacionPromedio:
          (json['puntuacion_promedio'] as num?)?.toDouble() ?? 0.0,
      ingresosTotales: (json['ingresos_totales'] as num?)?.toDouble() ?? 0.0,
      comisionAcumulada:
          (json['comision_acumulada'] as num?)?.toDouble() ?? 0.0,
    );
  }

  @override
  List<Object?> get props => [
        totalServicios,
        serviciosCompletados,
        serviciosCancelados,
        puntuacionPromedio,
        ingresosTotales,
        comisionAcumulada,
      ];
}

class ProviderListResponse extends Equatable {
  final List<ProviderModel> providers;
  final PaginationModel pagination;

  const ProviderListResponse({
    required this.providers,
    required this.pagination,
  });

  factory ProviderListResponse.fromJson(Map<String, dynamic> json) {
    return ProviderListResponse(
      providers: (json['providers'] as List)
          .map((provider) => ProviderModel.fromJson(provider))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }

  @override
  List<Object?> get props => [providers, pagination];
}

// Reutilizar PaginationModel del admin
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
