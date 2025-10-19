import 'package:flutter/material.dart';

class MovingTrackingPage extends StatefulWidget {
  const MovingTrackingPage({super.key});

  @override
  State<MovingTrackingPage> createState() => _MovingTrackingPageState();
}

class _MovingTrackingPageState extends State<MovingTrackingPage> {
  // Simulación de datos de seguimiento
  final Map<String, dynamic> _trackingData = {
    'codigo_mudanza': 'MOV-20241225-ABC123',
    'proveedor': 'Juan Pérez',
    'estado': 'en_camino',
    'ubicacion_actual': 'Av. Principal 123',
    'tiempo_estimado': '15 min',
    'distancia_restante': '2.5 km',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seguimiento en Tiempo Real'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tarjeta de información de la mudanza
            _buildMovingInfoCard(),
            const SizedBox(height: 20),

            // Mapa de seguimiento (simulado)
            _buildMapSection(),
            const SizedBox(height: 20),

            // Timeline del progreso
            _buildProgressTimeline(),
            const SizedBox(height: 20),

            // Información del proveedor
            _buildProviderInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildMovingInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Seguimiento Activo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        _getStatusColor(_trackingData['estado']).withAlpha(25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _getStatusColor(_trackingData['estado']),
                    ),
                  ),
                  child: Text(
                    _getStatusText(_trackingData['estado']),
                    style: TextStyle(
                      color: _getStatusColor(_trackingData['estado']),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Código', _trackingData['codigo_mudanza']),
            _buildInfoRow(
                'Ubicación Actual', _trackingData['ubicacion_actual']),
            _buildInfoRow('Tiempo Estimado', _trackingData['tiempo_estimado']),
            _buildInfoRow(
                'Distancia Restante', _trackingData['distancia_restante']),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ubicación en Tiempo Real',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map,
                      size: 50,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Mapa de Seguimiento',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Integración con Google Maps en desarrollo',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressTimeline() {
    final steps = [
      {'step': 'Solicitud Creada', 'completed': true, 'time': '10:00 AM'},
      {'step': 'Proveedor Asignado', 'completed': true, 'time': '10:30 AM'},
      {'step': 'En Camino', 'completed': true, 'time': '11:15 AM'},
      {'step': 'En Proceso', 'completed': false, 'time': '--:-- --'},
      {'step': 'Completado', 'completed': false, 'time': '--:-- --'},
    ];

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progreso de la Mudanza',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isLast = index == steps.length - 1;

              return _buildTimelineStep(
                step: step['step'] as String,
                completed: step['completed'] as bool,
                time: step['time'] as String,
                isLast: isLast,
                isCurrent: index == 2, // "En Camino" es el actual
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineStep({
    required String step,
    required bool completed,
    required String time,
    required bool isLast,
    required bool isCurrent,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Línea vertical y punto
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: completed
                    ? Colors.green
                    : (isCurrent ? Colors.orange : Colors.grey.shade300),
                border: Border.all(
                  color: completed
                      ? Colors.green
                      : (isCurrent ? Colors.orange : Colors.grey.shade400),
                  width: 2,
                ),
              ),
              child: completed
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : (isCurrent
                      ? const Icon(Icons.directions_car,
                          size: 12, color: Colors.white)
                      : null),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: completed ? Colors.green : Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: completed
                      ? Colors.green
                      : (isCurrent ? Colors.orange : Colors.grey.shade700),
                  fontSize: 14,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              if (isCurrent) ...[
                const SizedBox(height: 4),
                Text(
                  'En progreso...',
                  style: TextStyle(
                    color: Colors.orange.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProviderInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del Proveedor',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.blue,
                  size: 24,
                ),
              ),
              title: Text(
                _trackingData['proveedor'],
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: const Text('Proveedor de servicios'),
              trailing: IconButton(
                icon: const Icon(Icons.phone, color: Colors.green),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Llamando al proveedor...'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pendiente':
        return Colors.orange;
      case 'asignada':
        return Colors.blue;
      case 'en_camino':
        return Colors.green;
      case 'en_proceso':
        return Colors.purple;
      case 'completada':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pendiente':
        return 'PENDIENTE';
      case 'asignada':
        return 'ASIGNADA';
      case 'en_camino':
        return 'EN CAMINO';
      case 'en_proceso':
        return 'EN PROCESO';
      case 'completada':
        return 'COMPLETADA';
      default:
        return status.toUpperCase();
    }
  }
}
