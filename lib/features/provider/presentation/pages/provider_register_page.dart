import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
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
  final _tarifaBaseController = TextEditingController();
  final _tarifaKmController = TextEditingController();
  final _tarifaHoraController = TextEditingController();
  final _tarifaMinimaController = TextEditingController();

  String _tipoCuenta = 'individual';
  final List<String> _metodosPago = [];
  final List<String> _metodosPagoOptions = [
    'tarjeta_credito',
    'tarjeta_debito',
    'efectivo',
    'transferencia'
  ];

  bool _isExistingUser = false;
  String? _existingUserEmail;

  @override
  void initState() {
    super.initState();
    _checkExistingUser();
  }

  void _checkExistingUser() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      setState(() {
        _isExistingUser = true;
        _existingUserEmail = authState.user.email;
        _emailController.text = authState.user.email;
        _nombreController.text = authState.user.nombre;
        _apellidoController.text = authState.user.apellido ?? '';
        _telefonoController.text = authState.user.telefono ?? '';
      });
    }
  }

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
          if (state is ProviderRegistered || state is ProviderConverted) {
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
                if (_isExistingUser) _buildExistingUserBanner(),
                _buildSectionTitle('Información Personal'),
                _buildTextFormField(
                  controller: _nombreController,
                  label: 'Nombre',
                  enabled: !_isExistingUser,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requerido' : null,
                ),
                _buildTextFormField(
                  controller: _apellidoController,
                  label: 'Apellido',
                  enabled: !_isExistingUser,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requerido' : null,
                ),
                _buildTextFormField(
                  controller: _emailController,
                  label: 'Email',
                  enabled:
                      false, // Siempre deshabilitado para usuarios existentes
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Requerido' : null,
                ),
                _buildTextFormField(
                  controller: _telefonoController,
                  label: 'Teléfono',
                  keyboardType: TextInputType.phone,
                  enabled: !_isExistingUser,
                ),
                if (!_isExistingUser) ...[
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
                    validator: (value) => value != _passwordController.text
                        ? 'No coincide'
                        : null,
                  ),
                ],
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
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Requerido para empresas'
                        : null,
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
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExistingUserBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.info, color: Colors.blue.shade600),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Completando registro como proveedor para: $_existingUserEmail',
              style: TextStyle(
                color: Colors.blue.shade800,
                fontWeight: FontWeight.w500,
              ),
            ),
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
    bool obscureText = false,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        enabled: enabled,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: enabled ? Colors.grey.shade50 : Colors.grey.shade200,
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

  Widget _buildSubmitButton() {
    return BlocBuilder<ProviderBloc, ProviderState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state is ProviderLoading ? null : _submitForm,
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
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _isExistingUser
                        ? 'Convertir a Proveedor'
                        : 'Registrar Proveedor',
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        );
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final providerData = {
        if (!_isExistingUser) ...{
          'nombre': _nombreController.text,
          'apellido': _apellidoController.text,
          'email': _emailController.text,
          'telefono': _telefonoController.text,
          'password': _passwordController.text,
        },
        'tipo_cuenta': _tipoCuenta,
        'documento_identidad': _documentoController.text,
        'licencia_conducir': _licenciaController.text,
        'categoria_licencia': _categoriaController.text,
        if (_razonSocialController.text.isNotEmpty)
          'razon_social': _razonSocialController.text,
        if (_seguroController.text.isNotEmpty)
          'seguro_vehicular': _seguroController.text,
        if (_tarifaBaseController.text.isNotEmpty)
          'tarifa_base': double.parse(_tarifaBaseController.text),
        if (_tarifaKmController.text.isNotEmpty)
          'tarifa_por_km': double.parse(_tarifaKmController.text),
        if (_tarifaHoraController.text.isNotEmpty)
          'tarifa_hora': double.parse(_tarifaHoraController.text),
        if (_tarifaMinimaController.text.isNotEmpty)
          'tarifa_minima': double.parse(_tarifaMinimaController.text),
        'metodos_pago_aceptados': _metodosPago,
      };

      if (_isExistingUser) {
        context.read<ProviderBloc>().add(ConvertToProviderEvent(providerData));
      } else {
        context.read<ProviderBloc>().add(RegisterProviderEvent(providerData));
      }
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
    _tarifaBaseController.dispose();
    _tarifaKmController.dispose();
    _tarifaHoraController.dispose();
    _tarifaMinimaController.dispose();
    super.dispose();
  }
}
