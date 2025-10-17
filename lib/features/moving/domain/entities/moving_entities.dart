class MovingRequestEntity {
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

  MovingRequestEntity({
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
}

class MovingEntity {
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

  MovingEntity({
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
}

class MovingRequestListEntity {
  final List<MovingRequestEntity> requests;
  final PaginationEntity pagination;

  MovingRequestListEntity({
    required this.requests,
    required this.pagination,
  });
}

class MovingListEntity {
  final List<MovingEntity> movings;
  final PaginationEntity pagination;

  MovingListEntity({
    required this.movings,
    required this.pagination,
  });
}

// Reutilizar PaginationEntity del admin
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
