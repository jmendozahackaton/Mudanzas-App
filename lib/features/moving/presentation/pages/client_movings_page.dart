import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/moving_bloc.dart';
import '../bloc/moving_event.dart';
import '../bloc/moving_state.dart';

class ClientMovingsPage extends StatefulWidget {
  const ClientMovingsPage({super.key});

  @override
  State<ClientMovingsPage> createState() => _ClientMovingsPageState();
}

class _ClientMovingsPageState extends State<ClientMovingsPage> {
  int _currentPage = 1;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();
    _loadMovings();
  }

  void _loadMovings() {
    context.read<MovingBloc>().add(GetClientMovingsEvent(
          page: _currentPage,
          limit: _limit,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Mudanzas'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMovings,
            tooltip: 'Actualizar',
          ),
        ],
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
                    onPressed: _loadMovings,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is ClientMovingsLoaded) {
            final movings = state.movings.movings;
            final pagination = state.movings.pagination;

            if (movings.isEmpty) {
              return _buildEmptyState();
            }

            return Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _currentPage = 1;
                      _loadMovings();
                    },
                    child: ListView.builder(
                      itemCount: movings.length,
                      itemBuilder: (context, index) {
                        final moving = movings[index];
                        return _buildMovingCard(moving);
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
            'No tienes mudanzas activas',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Las mudanzas asignadas aparecerán aquí',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMovingCard(moving) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getStatusColor(moving.estado).withAlpha(20),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getStatusIcon(moving.estado),
            color: _getStatusColor(moving.estado),
            size: 24,
          ),
        ),
        title: Text(
          'Mudanza #${moving.codigoMudanza}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
                'Proveedor: ${moving.proveedorNombre ?? 'N/A'} ${moving.proveedorApellido ?? ''}'),
            Text('Origen: ${moving.direccionOrigen}'),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusChip(moving.estado),
                if (moving.prioridad == 'urgente')
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.withAlpha(10),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Text(
                      'URGENTE',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange,
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
              _formatDate(moving.fechaSolicitud),
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              '\$${moving.costoTotal.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        onTap: () {
          _showMovingDetails(moving);
        },
      ),
    );
  }

  Widget _buildStatusChip(String estado) {
    Color color;
    String text;

    switch (estado) {
      case 'asignada':
        color = Colors.blue;
        text = 'ASIGNADA';
        break;
      case 'en_camino':
        color = Colors.orange;
        text = 'EN CAMINO';
        break;
      case 'en_proceso':
        color = Colors.purple;
        text = 'EN PROCESO';
        break;
      case 'completada':
        color = Colors.green;
        text = 'COMPLETADA';
        break;
      case 'cancelada':
        color = Colors.red;
        text = 'CANCELADA';
        break;
      case 'disputa':
        color = Colors.red;
        text = 'DISPUTA';
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
                    _loadMovings();
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
                    _loadMovings();
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
      case 'asignada':
        return Colors.blue;
      case 'en_camino':
        return Colors.orange;
      case 'en_proceso':
        return Colors.purple;
      case 'completada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      case 'disputa':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String estado) {
    switch (estado) {
      case 'asignada':
        return Icons.assignment_turned_in;
      case 'en_camino':
        return Icons.directions_car;
      case 'en_proceso':
        return Icons.build;
      case 'completada':
        return Icons.check_circle;
      case 'cancelada':
        return Icons.cancel;
      case 'disputa':
        return Icons.warning;
      default:
        return Icons.local_shipping;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showMovingDetails(moving) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mudanza #${moving.codigoMudanza}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItem('Estado', moving.estado.toUpperCase()),
              _buildDetailItem('Proveedor',
                  '${moving.proveedorNombre ?? 'N/A'} ${moving.proveedorApellido ?? ''}'),
              _buildDetailItem('Origen', moving.direccionOrigen),
              _buildDetailItem('Destino', moving.direccionDestino),
              _buildDetailItem(
                  'Fecha de Solicitud', _formatDate(moving.fechaSolicitud)),
              if (moving.fechaAsignacion != null)
                _buildDetailItem('Fecha de Asignación',
                    _formatDate(moving.fechaAsignacion!)),
              if (moving.fechaInicio != null)
                _buildDetailItem(
                    'Fecha de Inicio', _formatDate(moving.fechaInicio!)),
              if (moving.fechaCompletacion != null)
                _buildDetailItem('Fecha de Completación',
                    _formatDate(moving.fechaCompletacion!)),
              _buildDetailItem(
                  'Costo Base', '\$${moving.costoBase.toStringAsFixed(2)}'),
              if (moving.costoAdicional > 0)
                _buildDetailItem('Costo Adicional',
                    '\$${moving.costoAdicional.toStringAsFixed(2)}'),
              _buildDetailItem(
                  'Costo Total', '\$${moving.costoTotal.toStringAsFixed(2)}'),
              _buildDetailItem('Comisión Plataforma',
                  '\$${moving.comisionPlataforma.toStringAsFixed(2)}'),
              if (moving.distanciaReal != null)
                _buildDetailItem(
                    'Distancia Real', '${moving.distanciaReal} km'),
              if (moving.tiempoReal != null)
                _buildDetailItem('Tiempo Real', '${moving.tiempoReal} min'),
              if (moving.calificacionCliente != null)
                _buildDetailItem(
                    'Tu Calificación', '⭐ ${moving.calificacionCliente}/5'),
              if (moving.calificacionProveedor != null)
                _buildDetailItem('Calificación del Proveedor',
                    '⭐ ${moving.calificacionProveedor}/5'),
              if (moving.notas != null && moving.notas!.isNotEmpty)
                _buildDetailItem('Notas', moving.notas!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
          if (moving.estado == 'completada' &&
              moving.calificacionCliente == null)
            ElevatedButton(
              onPressed: () => _rateMoving(moving),
              child: const Text('Calificar'),
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

  void _rateMoving(moving) {
    // Implementar calificación de mudanza
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Funcionalidad de calificación en desarrollo')),
    );
  }
}
