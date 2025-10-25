import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../moving/presentation/bloc/moving_bloc.dart';
import '../../../moving/presentation/bloc/moving_event.dart';
import '../../../moving/presentation/bloc/moving_state.dart';
import '../widgets/provider_selection_dialog.dart';

class MovingManagementPage extends StatefulWidget {
  const MovingManagementPage({super.key});

  @override
  State<MovingManagementPage> createState() => _MovingManagementPageState();
}

class _MovingManagementPageState extends State<MovingManagementPage> {
  int _currentPage = 1;
  final int _limit = 10;
  String? _estadoFiltro;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    context.read<MovingBloc>().add(GetAllRequestsEvent(
          page: _currentPage,
          limit: _limit,
          estado: _estadoFiltro,
        ));
  }

  void _assignProvider(int solicitudId, int proveedorId) {
    final assignData = {
      'solicitud_id': solicitudId,
      'proveedor_id': proveedorId,
      'costo_base': 0, // El admin puede ajustar esto
      'costo_total': 0,
      'comision_plataforma': 0,
    };

    print('🎯 Asignando solicitud $solicitudId al proveedor $proveedorId');
    context.read<MovingBloc>().add(AssignProviderEvent(assignData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Mudanzas'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRequests,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(),
          Expanded(
            child: BlocConsumer<MovingBloc, MovingState>(
              listener: (context, state) {
                if (state is ProviderAssigned) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          '✅ Proveedor asignado a mudanza #${state.moving.codigoMudanza}'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  _loadRequests(); // Recargar lista
                } else if (state is MovingError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Error: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is MovingLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is MovingError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(state.message, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadRequests,
                          child: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                if (state is AllRequestsLoaded) {
                  final requests = state.requests.requests;
                  final pagination = state.requests.pagination;

                  if (requests.isEmpty) {
                    return _buildEmptyState();
                  }

                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            final request = requests[index];
                            return _buildRequestCard(request);
                          },
                        ),
                      ),
                      _buildPagination(pagination),
                    ],
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          const Text('Filtrar por estado:'),
          const SizedBox(width: 12),
          DropdownButton<String>(
            value: _estadoFiltro,
            hint: const Text('Todos'),
            items: ['pendiente', 'buscando_proveedor', 'asignada', 'cancelada']
                .map((estado) {
              return DropdownMenuItem(
                value: estado,
                child: Text(_formatEstado(estado)),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _estadoFiltro = value;
                _currentPage = 1;
                _loadRequests();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(request) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ CORREGIDO: Row con Expanded para evitar overflow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Solicitud #${request.codigoSolicitud}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                _buildStatusChip(request.estado),
              ],
            ),
            const SizedBox(height: 12),

            // ✅ TAMBIÉN CORREGIR LAS FILAS DE DETALLES
            _buildDetailRow('Cliente',
                '${request.clienteNombre} ${request.clienteApellido}'),
            _buildDetailRow('Origen', request.direccionOrigen),
            _buildDetailRow('Destino', request.direccionDestino),
            _buildDetailRow(
                'Fecha Programada', _formatDate(request.fechaProgramada)),
            _buildDetailRow('Urgencia', request.urgencia.toUpperCase()),

            if (request.cotizacionEstimada > 0)
              _buildDetailRow('Cotización',
                  '\$${request.cotizacionEstimada.toStringAsFixed(2)}'),

            const SizedBox(height: 12),

            if (request.estado == 'pendiente' ||
                request.estado == 'buscando_proveedor')
              _buildAssignSection(request),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignSection(request) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        const Text(
          'Asignar Proveedor:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // En una implementación real, aquí iría un dropdown con proveedores disponibles
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showProviderSelection(request.id),
                icon: const Icon(Icons.person_add),
                label: const Text('Seleccionar Proveedor'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showProviderSelection(int solicitudId) {
    showDialog(
      context: context,
      builder: (context) => ProviderSelectionDialog(
        solicitudId: solicitudId,
        onProviderSelected: _assignProvider,
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            // ✅ AGREGAR EXPANDED AQUÍ TAMBIÉN
            child: Text(
              value,
              overflow: TextOverflow.ellipsis, // ✅ AGREGAR ELLIPSIS
              maxLines: 2, // ✅ LIMITAR A 2 LÍNEAS
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String estado) {
    Color color;
    String text;

    switch (estado) {
      case 'pendiente':
        color = Colors.orange;
        text = 'PENDIENTE';
        break;
      case 'buscando_proveedor':
        color = Colors.blue;
        text = 'BUSCANDO PROVEEDOR';
        break;
      case 'asignada':
        color = Colors.green;
        text = 'ASIGNADA';
        break;
      case 'cancelada':
        color = Colors.red;
        text = 'CANCELADA';
        break;
      default:
        color = Colors.grey;
        text = estado.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPagination(pagination) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 1
                ? () {
                    _currentPage--;
                    _loadRequests();
                  }
                : null,
            child: const Text('Anterior'),
          ),
          Text('Página ${pagination.page} de ${pagination.pages}'),
          ElevatedButton(
            onPressed: _currentPage < pagination.pages
                ? () {
                    _currentPage++;
                    _loadRequests();
                  }
                : null,
            child: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_shipping, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          const Text('No hay solicitudes disponibles'),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatEstado(String estado) {
    switch (estado) {
      case 'pendiente':
        return 'Pendientes';
      case 'buscando_proveedor':
        return 'Buscando Proveedor';
      case 'asignada':
        return 'Asignadas';
      case 'cancelada':
        return 'Canceladas';
      default:
        return estado;
    }
  }
}
