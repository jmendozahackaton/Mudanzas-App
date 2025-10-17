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
    return MovingRequestModel(
      id: json['id'],
      clienteId: json['cliente_id'],
      codigoSolicitud: json['codigo_solicitud'],
      direccionOrigen: json['direccion_origen'],
      direccionDestino: json['direccion_destino'],
      latOrigen: (json['lat_origen'] as num?)?.toDouble(),
      lngOrigen: (json['lng_origen'] as num?)?.toDouble(),
      latDestino: (json['lat_destino'] as num?)?.toDouble(),
      lngDestino: (json['lng_destino'] as num?)?.toDouble(),
      descripcionItems: json['descripcion_items'] ?? '',
      tipoItems: List<String>.from(json['tipo_items'] ?? []),
      volumenEstimado: (json['volumen_estimado'] as num?)?.toDouble() ?? 0.0,
      serviciosAdicionales:
          List<String>.from(json['servicios_adicionales'] ?? []),
      urgencia: json['urgencia'] ?? 'normal',
      fechaSolicitud: DateTime.parse(json['fecha_solicitud']),
      fechaProgramada: DateTime.parse(json['fecha_programada']),
      estado: json['estado'],
      cotizacionEstimada:
          (json['cotizacion_estimada'] as num?)?.toDouble() ?? 0.0,
      distanciaEstimada:
          (json['distancia_estimada'] as num?)?.toDouble() ?? 0.0,
      tiempoEstimado: json['tiempo_estimado'] ?? 0,
      tieneMudanzaAsignada: json['tiene_mudanza_asignada'] == 1 ||
          json['tiene_mudanza_asignada'] == true,
      clienteNombre: json['cliente_nombre'],
      clienteApellido: json['cliente_apellido'],
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
    return MovingModel(
      id: json['id'],
      solicitudId: json['solicitud_id'],
      clienteId: json['cliente_id'],
      proveedorId: json['proveedor_id'],
      codigoMudanza: json['codigo_mudanza'],
      estado: json['estado'],
      prioridad: json['prioridad'] ?? 'normal',
      fechaSolicitud: DateTime.parse(json['fecha_solicitud']),
      fechaAsignacion: json['fecha_asignacion'] != null
          ? DateTime.parse(json['fecha_asignacion'])
          : null,
      fechaInicio: json['fecha_inicio'] != null
          ? DateTime.parse(json['fecha_inicio'])
          : null,
      fechaCompletacion: json['fecha_completacion'] != null
          ? DateTime.parse(json['fecha_completacion'])
          : null,
      costoBase: (json['costo_base'] as num).toDouble(),
      costoAdicional: (json['costo_adicional'] as num?)?.toDouble() ?? 0.0,
      costoTotal: (json['costo_total'] as num).toDouble(),
      comisionPlataforma: (json['comision_plataforma'] as num).toDouble(),
      distanciaReal: (json['distancia_real'] as num?)?.toDouble(),
      tiempoReal: json['tiempo_real'],
      calificacionCliente: json['calificacion_cliente'],
      calificacionProveedor: json['calificacion_proveedor'],
      notas: json['notas'],
      direccionOrigen: json['direccion_origen'],
      direccionDestino: json['direccion_destino'],
      clienteNombre: json['cliente_nombre'],
      clienteApellido: json['cliente_apellido'],
      proveedorNombre: json['proveedor_nombre'],
      proveedorApellido: json['proveedor_apellido'],
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
