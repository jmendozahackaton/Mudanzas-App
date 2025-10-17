import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/moving_bloc.dart';
import '../bloc/moving_event.dart';
import '../bloc/moving_state.dart';

class ClientRequestsPage extends StatefulWidget {
  const ClientRequestsPage({super.key});

  @override
  State<ClientRequestsPage> createState() => _ClientRequestsPageState();
}

class _ClientRequestsPageState extends State<ClientRequestsPage> {
  int _currentPage = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  void _loadRequests() {
    context.read<MovingBloc>().add(GetClientRequestsEvent(
          page: _currentPage,
          limit: _limit,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Solicitudes de Mudanza'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadRequests,
            tooltip: 'Actualizar',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/moving/request');
        },
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<MovingBloc, MovingState>(
        builder: (context, state) {
          if (state is MovingLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is MovingError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadRequests,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is ClientRequestsLoaded) {
            final requests = state.requests.requests;
            final pagination = state.requests.pagination;

            if (requests.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _currentPage = 1;
                      _loadRequests();
                    },
                    child: ListView.builder(
                      itemCount: requests.length,
                      itemBuilder: (context, index) {
                        final request = requests[index];
                        return _buildRequestCard(request);
                      },
                    ),
                  ),
                ),
                _buildPagination(pagination),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_shipping,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          const Text(
            'No tienes solicitudes de mudanza',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crea tu primera solicitud para comenzar',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/moving/request');
            },
            child: const Text('Crear Solicitud'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(request) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getStatusColor(request.estado).withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getStatusIcon(request.estado),
            color: _getStatusColor(request.estado),
            size: 24,
          ),
        ),
        title: Text(
          'Solicitud #${request.codigoSolicitud}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Origen: ${request.direccionOrigen}'),
            Text('Destino: ${request.direccionDestino}'),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusChip(request.estado),
                if (request.tieneMudanzaAsignada)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(10),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Text(
                      'ASIGNADA',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatDate(request.fechaProgramada),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (request.cotizacionEstimada > 0)
              Text(
                '\$${request.cotizacionEstimada.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
          ],
        ),
        onTap: () {
          _showRequestDetails(request);
        },
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
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(10),
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
          Text(
            'Página ${pagination.page} de ${pagination.pages}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
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

  Color _getStatusColor(String estado) {
    switch (estado) {
      case 'pendiente':
        return Colors.orange;
      case 'buscando_proveedor':
        return Colors.blue;
      case 'asignada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String estado) {
    switch (estado) {
      case 'pendiente':
        return Icons.schedule;
      case 'buscando_proveedor':
        return Icons.search;
      case 'asignada':
        return Icons.check_circle;
      case 'cancelada':
        return Icons.cancel;
      default:
        return Icons.local_shipping;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showRequestDetails(request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Solicitud #${request.codigoSolicitud}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Estado', request.estado.toUpperCase()),
              _buildDetailItem('Origen', request.direccionOrigen),
              _buildDetailItem('Destino', request.direccionDestino),
              _buildDetailItem(
                  'Fecha Programada', _formatDate(request.fechaProgramada)),
              _buildDetailItem('Urgencia', request.urgencia.toUpperCase()),
              if (request.descripcionItems.isNotEmpty)
                _buildDetailItem('Descripción', request.descripcionItems),
              if (request.tipoItems.isNotEmpty)
                _buildDetailItem(
                    'Tipos de Items', request.tipoItems.join(', ')),
              if (request.serviciosAdicionales.isNotEmpty)
                _buildDetailItem('Servicios Adicionales',
                    request.serviciosAdicionales.join(', ')),
              if (request.volumenEstimado > 0)
                _buildDetailItem(
                    'Volumen Estimado', '${request.volumenEstimado} m³'),
              if (request.distanciaEstimada > 0)
                _buildDetailItem(
                    'Distancia Estimada', '${request.distanciaEstimada} km'),
              if (request.cotizacionEstimada > 0)
                _buildDetailItem('Cotización Estimada',
                    '\$${request.cotizacionEstimada.toStringAsFixed(2)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          Text(value),
        ],
      ),
    );
  }
}
