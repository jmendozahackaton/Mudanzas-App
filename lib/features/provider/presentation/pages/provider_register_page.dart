import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/provider_bloc.dart';
import '../bloc/provider_event.dart';
import '../bloc/provider_state.dart';

class ProviderRegisterPage extends StatefulWidget {
  const ProviderRegisterPage({super.key});

  @override
  State<ProviderRegisterPage> createState() => _ProviderRegisterPageState();
}

class _ProviderRegisterPageState extends State<ProviderRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _telefonoController = TextEditingController();
  final _documentoController = TextEditingController();
  final _licenciaController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _razonSocialController = TextEditingController();
  final _seguroController = TextEditingController();

  String _tipoCuenta = 'individual';
  final List<String> _metodosPago = [];
  final List<String> _metodosPagoOptions = [
    'tarjeta_credito',
    'tarjeta_debito',
    'efectivo',
    'transferencia'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Proveedor'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ProviderBloc, ProviderState>(
        listener: (context, state) {
          if (state is ProviderRegistered) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Proveedor registrado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is ProviderError) {
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
                _buildSectionTitle('Información Personal'),
                _buildTextFormField(
                  controller: _nombreController,
                  label: 'Nombre',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requerido' : null,
                ),
                _buildTextFormField(
                  controller: _apellidoController,
                  label: 'Apellido',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requerido' : null,
                ),
                _buildTextFormField(
                  controller: _emailController,
                  label: 'Email',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requerido' : null,
                ),
                _buildTextFormField(
                  controller: _telefonoController,
                  label: 'Teléfono',
                  keyboardType: TextInputType.phone,
                ),
                _buildTextFormField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 6) {
                      return 'Mínimo 6 caracteres';
                    }
                    return null;
                  },
                ),
                _buildTextFormField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar Contraseña',
                  obscureText: true,
                  validator: (value) =>
                      value != _passwordController.text ? 'No coincide' : null,
                ),
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
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requerido' : null,
                ),
                _buildTextFormField(
                  controller: _licenciaController,
                  label: 'Licencia de Conducir',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requerido' : null,
                ),
                _buildTextFormField(
                  controller: _categoriaController,
                  label: 'Categoría de Licencia',
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requerido' : null,
                ),
                _buildTextFormField(
                  controller: _seguroController,
                  label: 'Seguro Vehicular (opcional)',
                ),
                _buildSectionTitle('Configuración de Servicios'),
                _buildTarifasSection(),
                _buildMetodosPagoSection(),
                const SizedBox(height: 32),
                BlocBuilder<ProviderBloc, ProviderState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            state is ProviderLoading ? null : _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: state is ProviderLoading
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
                                'Registrar Proveedor',
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
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
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
        //value: value,
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value.toUpperCase()),
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

  Widget _buildTarifasSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tarifas (opcional)',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildTextFormField(
                controller: TextEditingController(),
                label: 'Tarifa Base',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextFormField(
                controller: TextEditingController(),
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
                controller: TextEditingController(),
                label: 'Tarifa por Hora',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildTextFormField(
                controller: TextEditingController(),
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
          children: _metodosPagoOptions.map((metodo) {
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final providerData = {
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'email': _emailController.text,
        'telefono': _telefonoController.text,
        'password': _passwordController.text,
        'tipo_cuenta': _tipoCuenta,
        'documento_identidad': _documentoController.text,
        'licencia_conducir': _licenciaController.text,
        'categoria_licencia': _categoriaController.text,
        if (_razonSocialController.text.isNotEmpty)
          'razon_social': _razonSocialController.text,
        if (_seguroController.text.isNotEmpty)
          'seguro_vehicular': _seguroController.text,
        'metodos_pago_aceptados': _metodosPago,
      };

      context.read<ProviderBloc>().add(RegisterProviderEvent(providerData));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _telefonoController.dispose();
    _documentoController.dispose();
    _licenciaController.dispose();
    _categoriaController.dispose();
    _razonSocialController.dispose();
    _seguroController.dispose();
    super.dispose();
  }
}
