import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../provider/data/models/provider_models.dart';

class MovingRequestModel extends Equatable {
  final int id;
  final int clienteId;
  final String codigoSolicitud;
  final String direccionOrigen;
  final String direccionDestino;
  final double? latOrigen;
  final double? lngOrigen;
  final double? latDestino;
  final double? lngDestino;
  final String descripcionItems;
  final List<String> tipoItems;
  final double volumenEstimado;
  final List<String> serviciosAdicionales;
  final String urgencia;
  final DateTime fechaSolicitud;
  final DateTime fechaProgramada;
  final String estado;
  final double cotizacionEstimada;
  final double distanciaEstimada;
  final int tiempoEstimado;
  final bool tieneMudanzaAsignada;
  final String? clienteNombre;
  final String? clienteApellido;

  const MovingRequestModel({
    required this.id,
    required this.clienteId,
    required this.codigoSolicitud,
    required this.direccionOrigen,
    required this.direccionDestino,
    this.latOrigen,
    this.lngOrigen,
    this.latDestino,
    this.lngDestino,
    required this.descripcionItems,
    required this.tipoItems,
    required this.volumenEstimado,
    required this.serviciosAdicionales,
    required this.urgencia,
    required this.fechaSolicitud,
    required this.fechaProgramada,
    required this.estado,
    required this.cotizacionEstimada,
    required this.distanciaEstimada,
    required this.tiempoEstimado,
    required this.tieneMudanzaAsignada,
    this.clienteNombre,
    this.clienteApellido,
  });

  factory MovingRequestModel.fromJson(Map<String, dynamic> json) {
    // Función helper para parsear arrays de forma segura
    List<String> parseStringList(dynamic value) {
      if (value == null) return [];
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      if (value is String) {
        try {
          // Intentar parsear el string como JSON
          final parsed = jsonDecode(value) as List;
          return parsed.map((e) => e.toString()).toList();
        } catch (e) {
          // Si falla, devolver lista vacía
          return [];
        }
      }
      return [];
    }

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

    // Función helper para parsear enteros de forma segura
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

    // Función helper para parsear fechas de forma segura
    DateTime safeParseDateTime(dynamic value) {
      if (value == null) return DateTime.now();
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    return MovingRequestModel(
      id: safeParseInt(json['id']),
      clienteId: safeParseInt(json['cliente_id']),
      codigoSolicitud: json['codigo_solicitud']?.toString() ?? '',
      direccionOrigen: json['direccion_origen']?.toString() ?? '',
      direccionDestino: json['direccion_destino']?.toString() ?? '',
      latOrigen: safeParseDouble(json['lat_origen']),
      lngOrigen: safeParseDouble(json['lng_origen']),
      latDestino: safeParseDouble(json['lat_destino']),
      lngDestino: safeParseDouble(json['lng_destino']),
      descripcionItems: json['descripcion_items']?.toString() ?? '',

      // ✅ CORREGIDO: Usar el parser seguro
      tipoItems: parseStringList(json['tipo_items']),
      volumenEstimado: safeParseDouble(json['volumen_estimado']),
      serviciosAdicionales: parseStringList(json['servicios_adicionales']),

      urgencia: json['urgencia']?.toString() ?? 'normal',
      fechaSolicitud: safeParseDateTime(json['fecha_solicitud']),
      fechaProgramada: safeParseDateTime(json['fecha_programada']),
      estado: json['estado']?.toString() ?? 'pendiente',
      cotizacionEstimada: safeParseDouble(json['cotizacion_estimada']),
      distanciaEstimada: safeParseDouble(json['distancia_estimada']),
      tiempoEstimado: safeParseInt(json['tiempo_estimado']),
      tieneMudanzaAsignada: json['tiene_mudanza_asignada'] == 1 ||
          json['tiene_mudanza_asignada'] == true ||
          (json['tiene_mudanza_asignada'] is String &&
              json['tiene_mudanza_asignada'] == '1'),
      clienteNombre: json['cliente_nombre']?.toString(),
      clienteApellido: json['cliente_apellido']?.toString(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        clienteId,
        codigoSolicitud,
        direccionOrigen,
        direccionDestino,
        latOrigen,
        lngOrigen,
        latDestino,
        lngDestino,
        descripcionItems,
        tipoItems,
        volumenEstimado,
        serviciosAdicionales,
        urgencia,
        fechaSolicitud,
        fechaProgramada,
        estado,
        cotizacionEstimada,
        distanciaEstimada,
        tiempoEstimado,
        tieneMudanzaAsignada,
        clienteNombre,
        clienteApellido,
      ];
}

class MovingModel extends Equatable {
  final int id;
  final int solicitudId;
  final int clienteId;
  final int proveedorId;
  final String codigoMudanza;
  final String estado;
  final String prioridad;
  final DateTime fechaSolicitud;
  final DateTime? fechaAsignacion;
  final DateTime? fechaInicio;
  final DateTime? fechaCompletacion;
  final double costoBase;
  final double costoAdicional;
  final double costoTotal;
  final double comisionPlataforma;
  final double? distanciaReal;
  final int? tiempoReal;
  final int? calificacionCliente;
  final int? calificacionProveedor;
  final String? notas;
  final String direccionOrigen;
  final String direccionDestino;
  final String? clienteNombre;
  final String? clienteApellido;
  final String? proveedorNombre;
  final String? proveedorApellido;

  const MovingModel({
    required this.id,
    required this.solicitudId,
    required this.clienteId,
    required this.proveedorId,
    required this.codigoMudanza,
    required this.estado,
    required this.prioridad,
    required this.fechaSolicitud,
    this.fechaAsignacion,
    this.fechaInicio,
    this.fechaCompletacion,
    required this.costoBase,
    required this.costoAdicional,
    required this.costoTotal,
    required this.comisionPlataforma,
    this.distanciaReal,
    this.tiempoReal,
    this.calificacionCliente,
    this.calificacionProveedor,
    this.notas,
    required this.direccionOrigen,
    required this.direccionDestino,
    this.clienteNombre,
    this.clienteApellido,
    this.proveedorNombre,
    this.proveedorApellido,
  });

  factory MovingModel.fromJson(Map<String, dynamic> json) {
    // Reutilizar las mismas funciones helper
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

    DateTime? safeParseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is DateTime) return value;
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    return MovingModel(
      id: safeParseInt(json['id']),
      solicitudId: safeParseInt(json['solicitud_id']),
      clienteId: safeParseInt(json['cliente_id']),
      proveedorId: safeParseInt(json['proveedor_id']),
      codigoMudanza: json['codigo_mudanza']?.toString() ?? '',
      estado: json['estado']?.toString() ?? '',
      prioridad: json['prioridad']?.toString() ?? 'normal',
      fechaSolicitud:
          safeParseDateTime(json['fecha_solicitud']) ?? DateTime.now(),
      fechaAsignacion: safeParseDateTime(json['fecha_asignacion']),
      fechaInicio: safeParseDateTime(json['fecha_inicio']),
      fechaCompletacion: safeParseDateTime(json['fecha_completacion']),
      costoBase: safeParseDouble(json['costo_base']),
      costoAdicional: safeParseDouble(json['costo_adicional']),
      costoTotal: safeParseDouble(json['costo_total']),
      comisionPlataforma: safeParseDouble(json['comision_plataforma']),
      distanciaReal: safeParseDouble(json['distancia_real']),
      tiempoReal: safeParseInt(json['tiempo_real']),
      calificacionCliente: safeParseInt(json['calificacion_cliente']),
      calificacionProveedor: safeParseInt(json['calificacion_proveedor']),
      notas: json['notas']?.toString(),
      direccionOrigen: json['direccion_origen']?.toString() ?? '',
      direccionDestino: json['direccion_destino']?.toString() ?? '',
      clienteNombre: json['cliente_nombre']?.toString(),
      clienteApellido: json['cliente_apellido']?.toString(),
      proveedorNombre: json['proveedor_nombre']?.toString(),
      proveedorApellido: json['proveedor_apellido']?.toString(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        solicitudId,
        clienteId,
        proveedorId,
        codigoMudanza,
        estado,
        prioridad,
        fechaSolicitud,
        fechaAsignacion,
        fechaInicio,
        fechaCompletacion,
        costoBase,
        costoAdicional,
        costoTotal,
        comisionPlataforma,
        distanciaReal,
        tiempoReal,
        calificacionCliente,
        calificacionProveedor,
        notas,
        direccionOrigen,
        direccionDestino,
        clienteNombre,
        clienteApellido,
        proveedorNombre,
        proveedorApellido,
      ];
}

class MovingRequestListResponse extends Equatable {
  final List<MovingRequestModel> requests;
  final PaginationModel pagination;

  const MovingRequestListResponse({
    required this.requests,
    required this.pagination,
  });

  factory MovingRequestListResponse.fromJson(Map<String, dynamic> json) {
    return MovingRequestListResponse(
      requests: (json['solicitudes'] as List)
          .map((request) => MovingRequestModel.fromJson(request))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }

  @override
  List<Object?> get props => [requests, pagination];
}

class MovingListResponse extends Equatable {
  final List<MovingModel> movings;
  final PaginationModel pagination;

  const MovingListResponse({
    required this.movings,
    required this.pagination,
  });

  factory MovingListResponse.fromJson(Map<String, dynamic> json) {
    return MovingListResponse(
      movings: (json['mudanzas'] as List)
          .map((moving) => MovingModel.fromJson(moving))
          .toList(),
      pagination: PaginationModel.fromJson(json['pagination']),
    );
  }

  @override
  List<Object?> get props => [movings, pagination];
}
