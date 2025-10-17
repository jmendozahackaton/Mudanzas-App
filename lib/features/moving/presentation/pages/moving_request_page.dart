import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/moving_bloc.dart';
import '../bloc/moving_event.dart';
import '../bloc/moving_state.dart';

class MovingRequestPage extends StatefulWidget {
  const MovingRequestPage({super.key});

  @override
  State<MovingRequestPage> createState() => _MovingRequestPageState();
}

class _MovingRequestPageState extends State<MovingRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _direccionOrigenController = TextEditingController();
  final _direccionDestinoController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _volumenController = TextEditingController();
  final _distanciaController = TextEditingController();
  final _tiempoController = TextEditingController();
  final _cotizacionController = TextEditingController();

  DateTime _fechaProgramada = DateTime.now().add(const Duration(days: 1));
  String _urgencia = 'normal';
  final List<String> _tipoItems = [];
  final List<String> _serviciosAdicionales = [];

  final List<String> _tipoItemsOptions = [
    'muebles',
    'electrodomesticos',
    'cajas',
    'ropa',
    'otros'
  ];

  final List<String> _serviciosOptions = [
    'embalaje',
    'desembalaje',
    'montaje_muebles',
    'limpieza',
    'almacenamiento'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitar Mudanza'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<MovingBloc, MovingState>(
        listener: (context, state) {
          if (state is MovingRequestCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Solicitud de mudanza creada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is MovingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Ubicaciones'),
                _buildTextFormField(
                  controller: _direccionOrigenController,
                  label: 'Dirección de Origen',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requerido' : null,
                  maxLines: 2,
                ),
                _buildTextFormField(
                  controller: _direccionDestinoController,
                  label: 'Dirección de Destino',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requerido' : null,
                  maxLines: 2,
                ),
                _buildSectionTitle('Fecha y Urgencia'),
                _buildDatePicker(),
                const SizedBox(height: 16),
                _buildUrgenciaSelector(),
                _buildSectionTitle('Items a Mover'),
                _buildTextFormField(
                  controller: _descripcionController,
                  label: 'Descripción de Items',
                  maxLines: 3,
                ),
                _buildTipoItemsSelector(),
                _buildSectionTitle('Servicios Adicionales'),
                _buildServiciosAdicionales(),
                _buildSectionTitle('Estimaciones'),
                _buildEstimacionesSection(),
                const SizedBox(height: 32),
                BlocBuilder<MovingBloc, MovingState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is MovingLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: state is MovingLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Text(
                                'Crear Solicitud de Mudanza',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Fecha Programada',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_fechaProgramada.day}/${_fechaProgramada.month}/${_fechaProgramada.year}',
              style: const TextStyle(fontSize: 16),
            ),
            const Icon(Icons.calendar_today, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildUrgenciaSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildUrgenciaOption(
            'Normal',
            'normal',
            Icons.schedule,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildUrgenciaOption(
            'Urgente',
            'urgente',
            Icons.warning,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildUrgenciaOption(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: _urgencia == value ? 2 : 1,
      color: _urgencia == value ? color.withAlpha(10) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: _urgencia == value ? color : Colors.grey.shade300,
          width: _urgencia == value ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => setState(() => _urgencia = value),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipoItemsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _tipoItemsOptions.map((tipo) {
            return FilterChip(
              label: Text(_formatTipoItem(tipo)),
              selected: _tipoItems.contains(tipo),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _tipoItems.add(tipo);
                  } else {
                    _tipoItems.remove(tipo);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildServiciosAdicionales() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _serviciosOptions.map((servicio) {
            return FilterChip(
              label: Text(_formatServicio(servicio)),
              selected: _serviciosAdicionales.contains(servicio),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _serviciosAdicionales.add(servicio);
                  } else {
                    _serviciosAdicionales.remove(servicio);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEstimacionesSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextFormField(
                controller: _volumenController,
                label: 'Volumen Estimado (m³)',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextFormField(
                controller: _cotizacionController,
                label: 'Cotización Estimada (\$)',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextFormField(
                controller: _distanciaController,
                label: 'Distancia Estimada (km)',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextFormField(
                controller: _tiempoController,
                label: 'Tiempo Estimado (min)',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatTipoItem(String tipo) {
    switch (tipo) {
      case 'muebles':
        return 'Muebles';
      case 'electrodomesticos':
        return 'Electrodomésticos';
      case 'cajas':
        return 'Cajas';
      case 'ropa':
        return 'Ropa';
      case 'otros':
        return 'Otros';
      default:
        return tipo;
    }
  }

  String _formatServicio(String servicio) {
    switch (servicio) {
      case 'embalaje':
        return 'Embalaje';
      case 'desembalaje':
        return 'Desembalaje';
      case 'montaje_muebles':
        return 'Montaje Muebles';
      case 'limpieza':
        return 'Limpieza';
      case 'almacenamiento':
        return 'Almacenamiento';
      default:
        return servicio;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fechaProgramada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _fechaProgramada) {
      setState(() {
        _fechaProgramada = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final requestData = {
        'direccion_origen': _direccionOrigenController.text,
        'direccion_destino': _direccionDestinoController.text,
        'descripcion_items': _descripcionController.text,
        'tipo_items': _tipoItems,
        'servicios_adicionales': _serviciosAdicionales,
        'urgencia': _urgencia,
        'fecha_programada': _fechaProgramada.toIso8601String(),
        'volumen_estimado': double.tryParse(_volumenController.text) ?? 0,
        'cotizacion_estimada': double.tryParse(_cotizacionController.text) ?? 0,
        'distancia_estimada': double.tryParse(_distanciaController.text) ?? 0,
        'tiempo_estimado': int.tryParse(_tiempoController.text) ?? 0,
      };

      context.read<MovingBloc>().add(CreateMovingRequestEvent(requestData));
    }
  }

  @override
  void dispose() {
    _direccionOrigenController.dispose();
    _direccionDestinoController.dispose();
    _descripcionController.dispose();
    _volumenController.dispose();
    _distanciaController.dispose();
    _tiempoController.dispose();
    _cotizacionController.dispose();
    super.dispose();
  }
}
