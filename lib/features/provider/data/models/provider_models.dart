import 'dart:convert';

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
  final String? polizaSeguro;
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
  final DateTime? fechaRenovacion;
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
    this.polizaSeguro,
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
    this.fechaRenovacion,
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
    // Función helper para parsear números de forma segura
    double safeParseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        try {
          return double.parse(value);
        } catch (e) {
          return 0.0;
        }
      }
      return 0.0;
    }

    int safeParseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) {
        try {
          return int.parse(value);
        } catch (e) {
          return 0;
        }
      }
      return 0;
    }

    bool safeParseBool(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) {
        return value.toLowerCase() == 'true' || value == '1';
      }
      return false;
    }

    // Parsear lista de métodos de pago de forma segura - CORREGIDO
    List<String> parseMetodosPago(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      if (value is String) {
        try {
          final parsed = jsonDecode(value) as List; // ✅ Cambiado a jsonDecode
          return parsed.map((e) => e.toString()).toList();
        } catch (e) {
          return [];
        }
      }
      return [];
    }

    return ProviderModel(
      id: safeParseInt(json['id']),
      usuarioId: safeParseInt(json['usuario_id']),
      nombre: json['nombre']?.toString() ?? '',
      apellido: json['apellido']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      telefono: json['telefono']?.toString(),
      fotoPerfil: json['foto_perfil']?.toString(),
      tipoCuenta: json['tipo_cuenta']?.toString() ?? 'individual',
      razonSocial: json['razon_social']?.toString(),
      documentoIdentidad: json['documento_identidad']?.toString() ?? '',
      licenciaConducir: json['licencia_conducir']?.toString() ?? '',
      categoriaLicencia: json['categoria_licencia']?.toString() ?? '',
      seguroVehicular: json['seguro_vehicular']?.toString(),
      polizaSeguro: json['poliza_seguro']?.toString(),
      estadoVerificacion:
          json['estado_verificacion']?.toString() ?? 'pendiente',
      nivelProveedor: json['nivel_proveedor']?.toString() ?? 'bronce',
      puntuacionPromedio: safeParseDouble(json['puntuacion_promedio']),
      totalServicios: safeParseInt(json['total_servicios']),
      serviciosCompletados: safeParseInt(json['servicios_completados']),
      serviciosCancelados: safeParseInt(json['servicios_cancelados']),
      ingresosTotales: safeParseDouble(json['ingresos_totales']),
      comisionAcumulada: safeParseDouble(json['comision_acumulada']),
      fechaRegistro: DateTime.parse(
          json['fecha_registro']?.toString() ?? DateTime.now().toString()),
      fechaVerificacion: json['fecha_verificacion'] != null
          ? DateTime.tryParse(json['fecha_verificacion'].toString())
          : null,
      fechaRenovacion: json['fecha_renovacion'] != null
          ? DateTime.tryParse(json['fecha_renovacion'].toString())
          : null,
      radioServicio: safeParseInt(json['radio_servicio']),
      tarifaBase: safeParseDouble(json['tarifa_base']),
      tarifaPorKm: safeParseDouble(json['tarifa_por_km']),
      tarifaHora: safeParseDouble(json['tarifa_hora']),
      tarifaMinima: safeParseDouble(json['tarifa_minima']),
      disponible: safeParseBool(json['disponible']),
      modoOcupado: safeParseBool(json['modo_ocupado']),
      enServicio: safeParseBool(json['en_servicio']),
      ultimaUbicacionLat: json['ultima_ubicacion_lat'] != null
          ? safeParseDouble(json['ultima_ubicacion_lat'])
          : null,
      ultimaUbicacionLng: json['ultima_ubicacion_lng'] != null
          ? safeParseDouble(json['ultima_ubicacion_lng'])
          : null,
      ultimaActualizacion: json['ultima_actualizacion'] != null
          ? DateTime.tryParse(json['ultima_actualizacion'].toString())
          : null,
      metodosPagoAceptados: parseMetodosPago(json['metodos_pago_aceptados']),
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
