import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/provider_bloc.dart';
import '../bloc/provider_event.dart';
import '../bloc/provider_state.dart';

class ProviderProfilePage extends StatefulWidget {
  const ProviderProfilePage({super.key});

  @override
  State<ProviderProfilePage> createState() => _ProviderProfilePageState();
}

class _ProviderProfilePageState extends State<ProviderProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _razonSocialController = TextEditingController();
  final _documentoController = TextEditingController();
  final _licenciaController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _seguroController = TextEditingController();
  final _polizaController = TextEditingController();
  final _tarifaBaseController = TextEditingController();
  final _tarifaKmController = TextEditingController();
  final _tarifaHoraController = TextEditingController();
  final _tarifaMinimaController = TextEditingController();

  String _tipoCuenta = 'individual';
  int _radioServicio = 10;
  List<String> _metodosPago = [];
  bool _isFormInitialized = false;

  @override
  void initState() {
    super.initState();
    // Solo cargar datos si no los tenemos ya
    _initializeFromExistingState();
  }

  void _initializeFromExistingState() {
    final currentState = context.read<ProviderBloc>().state;

    if (currentState is ProviderDashboardLoaded) {
      _initializeFormData(currentState.provider);
      _isFormInitialized = true;
    } else if (currentState is ProviderProfileLoaded) {
      _initializeFormData(currentState.provider);
      _isFormInitialized = true;
    } else {
      // Si no tenemos datos, cargarlos
      context.read<ProviderBloc>().add(GetProviderProfileEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Proveedor'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
            tooltip: 'Guardar Cambios',
          ),
        ],
      ),
      body: BlocConsumer<ProviderBloc, ProviderState>(
        listener: (context, state) {
          if (state is ProviderProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Perfil actualizado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context); // Regresar al dashboard después de guardar
          } else if (state is ProviderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          print('🎯 ProfilePage: Estado actual - ${state.runtimeType}');

          // ✅ MANEJAR MULTIPLES ESTADOS
          if (state is ProviderLoading && !_isFormInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          // ✅ INICIALIZAR FORMULARIO CON DATOS EXISTENTES
          if (!_isFormInitialized) {
            if (state is ProviderDashboardLoaded) {
              _initializeFormData(state.provider);
              _isFormInitialized = true;
            } else if (state is ProviderProfileLoaded) {
              _initializeFormData(state.provider);
              _isFormInitialized = true;
            } else if (state is ProviderError) {
              return _buildErrorState(state.message);
            }
          }

          return _buildFormContent();
        },
      ),
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Información Profesional'),
            _buildDropdown(
              value: _tipoCuenta,
              items: const ['individual', 'empresa'],
              label: 'Tipo de Cuenta',
              onChanged: (value) => setState(() => _tipoCuenta = value!),
            ),
            if (_tipoCuenta == 'empresa')
              _buildTextFormField(
                controller: _razonSocialController,
                label: 'Razón Social',
              ),
            _buildTextFormField(
              controller: _documentoController,
              label: 'Documento de Identidad',
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            _buildTextFormField(
              controller: _licenciaController,
              label: 'Licencia de Conducir',
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            _buildTextFormField(
              controller: _categoriaController,
              label: 'Categoría de Licencia',
              validator: (value) => value?.isEmpty ?? true ? 'Requerido' : null,
            ),
            _buildTextFormField(
              controller: _seguroController,
              label: 'Seguro Vehicular',
            ),
            _buildTextFormField(
              controller: _polizaController,
              label: 'Póliza de Seguro',
            ),
            _buildSectionTitle('Configuración de Servicios'),
            _buildSlider(
              value: _radioServicio.toDouble(),
              min: 5,
              max: 50,
              divisions: 9,
              label: 'Radio de Servicio (km): $_radioServicio km',
              onChanged: (value) =>
                  setState(() => _radioServicio = value.toInt()),
            ),
            const SizedBox(height: 16),
            _buildTarifasSection(),
            const SizedBox(height: 16),
            _buildMetodosPagoSection(),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Guardar Cambios',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Error: $message',
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<ProviderBloc>().add(GetProviderProfileEvent());
            },
            child: const Text('Reintentar'),
          ),
        ],
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
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
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

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required String label,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(_formatTipoCuenta(value)),
          );
        }).toList(),
        onChanged: onChanged,
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

  String _formatTipoCuenta(String tipo) {
    switch (tipo) {
      case 'individual':
        return 'Individual';
      case 'empresa':
        return 'Empresa';
      default:
        return tipo;
    }
  }

  Widget _buildSlider({
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String label,
    required Function(double) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTarifasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tarifas',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextFormField(
                controller: _tarifaBaseController,
                label: 'Tarifa Base',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextFormField(
                controller: _tarifaKmController,
                label: 'Tarifa por Km',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextFormField(
                controller: _tarifaHoraController,
                label: 'Tarifa por Hora',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextFormField(
                controller: _tarifaMinimaController,
                label: 'Tarifa Mínima',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMetodosPagoSection() {
    final metodosPagoOptions = [
      'tarjeta_credito',
      'tarjeta_debito',
      'efectivo',
      'transferencia'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Métodos de Pago Aceptados',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: metodosPagoOptions.map((metodo) {
            return FilterChip(
              label: Text(_formatMetodoPago(metodo)),
              selected: _metodosPago.contains(metodo),
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _metodosPago.add(metodo);
                  } else {
                    _metodosPago.remove(metodo);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  String _formatMetodoPago(String metodo) {
    switch (metodo) {
      case 'tarjeta_credito':
        return 'Tarjeta Crédito';
      case 'tarjeta_debito':
        return 'Tarjeta Débito';
      case 'efectivo':
        return 'Efectivo';
      case 'transferencia':
        return 'Transferencia';
      default:
        return metodo;
    }
  }

  void _initializeFormData(provider) {
    print('🎯 ProfilePage: Inicializando formulario con datos del proveedor');

    _tipoCuenta = provider.tipoCuenta;
    _razonSocialController.text = provider.razonSocial ?? '';
    _documentoController.text = provider.documentoIdentidad;
    _licenciaController.text = provider.licenciaConducir;
    _categoriaController.text = provider.categoriaLicencia;
    _seguroController.text = provider.seguroVehicular ?? '';
    _polizaController.text = provider.polizaSeguro ?? '';
    _radioServicio = provider.radioServicio;
    _tarifaBaseController.text = provider.tarifaBase.toStringAsFixed(2);
    _tarifaKmController.text = provider.tarifaPorKm.toStringAsFixed(2);
    _tarifaHoraController.text = provider.tarifaHora.toStringAsFixed(2);
    _tarifaMinimaController.text = provider.tarifaMinima.toStringAsFixed(2);
    _metodosPago = List<String>.from(provider.metodosPagoAceptados);

    print(
        '🎯 ProfilePage: Formulario inicializado - Tipo: $_tipoCuenta, Tarifa: ${_tarifaBaseController.text}');
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final updateData = {
        'tipo_cuenta': _tipoCuenta,
        if (_razonSocialController.text.isNotEmpty)
          'razon_social': _razonSocialController.text,
        'documento_identidad': _documentoController.text,
        'licencia_conducir': _licenciaController.text,
        'categoria_licencia': _categoriaController.text,
        if (_seguroController.text.isNotEmpty)
          'seguro_vehicular': _seguroController.text,
        if (_polizaController.text.isNotEmpty)
          'poliza_seguro': _polizaController.text,
        'radio_servicio': _radioServicio,
        'tarifa_base': double.tryParse(_tarifaBaseController.text) ?? 0,
        'tarifa_por_km': double.tryParse(_tarifaKmController.text) ?? 0,
        'tarifa_hora': double.tryParse(_tarifaHoraController.text) ?? 0,
        'tarifa_minima': double.tryParse(_tarifaMinimaController.text) ?? 0,
        'metodos_pago_aceptados': _metodosPago,
      };

      print('🎯 ProfilePage: Enviando datos de actualización: $updateData');
      context.read<ProviderBloc>().add(UpdateProviderProfileEvent(updateData));
    }
  }

  @override
  void dispose() {
    _razonSocialController.dispose();
    _documentoController.dispose();
    _licenciaController.dispose();
    _categoriaController.dispose();
    _seguroController.dispose();
    _polizaController.dispose();
    _tarifaBaseController.dispose();
    _tarifaKmController.dispose();
    _tarifaHoraController.dispose();
    _tarifaMinimaController.dispose();
    super.dispose();
  }
}
