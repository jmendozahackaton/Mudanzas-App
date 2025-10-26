import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../domain/entities/provider_entities.dart';
import '../bloc/provider_bloc.dart';
import '../bloc/provider_event.dart';
import '../bloc/provider_state.dart';
import 'provider_profile_page.dart';
import 'provider_services_page.dart';

class ProviderDashboard extends StatefulWidget {
  const ProviderDashboard({super.key});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  bool _disponible = true;
  bool _modoOcupado = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    print('🔄 Dashboard: Cargando datos del proveedor...');
    context.read<ProviderBloc>().add(GetProviderProfileEvent());
    context.read<ProviderBloc>().add(GetProviderStatisticsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is AuthUnauthenticated) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (route) => false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard Proveedor'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadData,
              tooltip: 'Actualizar',
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => _showLogoutDialog(context),
              tooltip: 'Cerrar Sesión',
            ),
          ],
        ),
        body: BlocConsumer<ProviderBloc, ProviderState>(
          listener: (context, state) {
            print(
                '🎯 Dashboard: Estado del ProviderBloc - ${state.runtimeType}');

            if (state is ProviderError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            } else if (state is ProviderAvailabilityUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Disponibilidad actualizada'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is ProviderLocationUpdated) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Ubicación actualizada'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          builder: (context, state) {
            print('🎯 Dashboard: Rebuild con estado - ${state.runtimeType}');

            // ✅ ESTADO DE CARGA PRINCIPAL
            if (state is ProviderLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando dashboard...'),
                  ],
                ),
              );
            }

            // ✅ ESTADO PRINCIPAL - DATOS CARGADOS
            if (state is ProviderDashboardLoaded) {
              return _buildDashboardContent(state);
            }

            // ✅ ESTADO DE ERROR
            if (state is ProviderError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadData,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            // ✅ ESTADOS DE ACTUALIZACIÓN - EL BLOC YA ESTÁ RECARGANDO DATOS
            if (state is ProviderLocationUpdated ||
                state is ProviderAvailabilityUpdated) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Actualizando datos...'),
                  ],
                ),
              );
            }

            // ✅ ESTADO INICIAL O NO MANEJADO
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Inicializando dashboard...'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboardContent(ProviderDashboardLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Sección de Bienvenida
          _buildWelcomeSection(state.provider),
          const SizedBox(height: 20),

          // Estado de disponibilidad
          _buildAvailabilityCard(),
          const SizedBox(height: 20),

          // Estadísticas
          _buildStatisticsCard(state.statistics),
          const SizedBox(height: 20),

          // Información del perfil
          _buildProfileCard(state.provider),
          const SizedBox(height: 20),

          // Acciones rápidas
          _buildQuickActions(),
        ],
      ),
    );
  }

  // ✅ MÉTODO SIMPLIFICADO PARA LA SECCIÓN DE BIENVENIDA
  Widget _buildWelcomeSection(ProviderEntity provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade700,
            Colors.blue.shade500,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withAlpha(64),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(51),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Hola, ${provider.nombre}!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      provider.email,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Gestiona tus servicios de mudanza',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(ProviderStatisticsEntity statistics) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.analytics, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Estadísticas del Mes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatItem(
                  'Servicios Totales',
                  statistics.totalServicios.toString(),
                  Icons.local_shipping,
                  Colors.blue,
                ),
                _buildStatItem(
                  'Completados',
                  statistics.serviciosCompletados.toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatItem(
                  'Cancelados',
                  statistics.serviciosCancelados.toString(),
                  Icons.cancel,
                  Colors.red,
                ),
                _buildStatItem(
                  'Puntuación',
                  '${statistics.puntuacionPromedio.toStringAsFixed(1)}/5',
                  Icons.star,
                  Colors.orange,
                ),
                _buildStatItem(
                  'Ingresos',
                  '\$${statistics.ingresosTotales.toStringAsFixed(2)}',
                  Icons.attach_money,
                  Colors.green.shade700,
                ),
                _buildStatItem(
                  'Comisión',
                  '\$${statistics.comisionAcumulada.toStringAsFixed(2)}',
                  Icons.percent,
                  Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(ProviderEntity provider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.person_outline, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Información del Perfil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProfileInfoItem(
              icon: Icons.person,
              label: 'Nombre',
              value: '${provider.nombre} ${provider.apellido}',
            ),
            _buildProfileInfoItem(
              icon: Icons.email,
              label: 'Email',
              value: provider.email,
            ),
            _buildProfileInfoItem(
              icon: Icons.phone,
              label: 'Teléfono',
              value: provider.telefono ?? 'No especificado',
            ),
            _buildProfileInfoItem(
              icon: Icons.business_center,
              label: 'Tipo de Cuenta',
              value: _formatTipoCuenta(provider.tipoCuenta),
            ),
            _buildProfileInfoItem(
              icon: Icons.verified_user,
              label: 'Estado de Verificación',
              value: _formatVerificationStatus(provider.estadoVerificacion),
              valueColor: _getVerificationColor(provider.estadoVerificacion),
            ),
            if (provider.polizaSeguro != null &&
                provider.polizaSeguro!.isNotEmpty)
              _buildProfileInfoItem(
                icon: Icons.security,
                label: 'Póliza de Seguro',
                value: provider.polizaSeguro!,
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _navigateToProfile,
                icon: const Icon(Icons.edit),
                label: const Text('Editar Perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade50,
                  foregroundColor: Colors.blue.shade700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.schedule, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Estado de Disponibilidad',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildAvailabilitySwitch(
                    title: 'Disponible',
                    value: _disponible,
                    onChanged: (value) =>
                        _updateAvailability(value, _modoOcupado),
                    activeColor: Colors.green,
                  ),
                ),
                Expanded(
                  child: _buildAvailabilitySwitch(
                    title: 'Modo Ocupado',
                    value: _modoOcupado,
                    onChanged: (value) =>
                        _updateAvailability(_disponible, value),
                    activeColor: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _disponible
                    ? (_modoOcupado
                        ? Colors.orange.shade50
                        : Colors.green.shade50)
                    : Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _disponible
                      ? (_modoOcupado
                          ? Colors.orange.shade200
                          : Colors.green.shade200)
                      : Colors.red.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    _disponible ? Icons.check_circle : Icons.cancel,
                    color: _disponible
                        ? (_modoOcupado ? Colors.orange : Colors.green)
                        : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _disponible
                          ? (_modoOcupado
                              ? 'Disponible para servicios urgentes'
                              : 'Disponible para nuevos servicios')
                          : 'No disponible temporalmente',
                      style: TextStyle(
                        color: _disponible
                            ? (_modoOcupado
                                ? Colors.orange.shade800
                                : Colors.green.shade800)
                            : Colors.red.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilitySwitch({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required Color activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withAlpha(50)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(30),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfoItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey.shade600),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.grey.shade800,
                fontWeight:
                    valueColor != null ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.dashboard, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Acciones Rápidas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildActionCard(
                  'Actualizar Perfil',
                  Icons.edit,
                  Colors.blue,
                  () => _navigateToProfile(),
                ),
                _buildActionCard(
                  'Mis Servicios',
                  Icons.list_alt,
                  Colors.green,
                  () => _navigateToServices(),
                ),
                _buildActionCard(
                  'Actualizar Ubicación',
                  Icons.location_on,
                  Colors.orange,
                  () => _updateLocation(),
                ),
                _buildActionCard(
                  'Soporte',
                  Icons.support_agent,
                  Colors.purple,
                  () => _contactSupport(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 24, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProviderProfilePage(),
      ),
    ).then((_) {
      _loadData();
    });
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthBloc>().add(LogoutEvent());
            },
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToServices() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProviderServicesPage()),
    );
  }

  void _updateLocation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Actualizar Ubicación'),
        content: const Text('¿Deseas actualizar tu ubicación actual?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final lat = 12.128974;
              final lng = -86.265477;

              context.read<ProviderBloc>().add(
                    UpdateProviderLocationEvent(lat: lat, lng: lng),
                  );
            },
            child: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }

  void _contactSupport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Soporte Técnico'),
        content: const Text(
          'Para soporte técnico, contacta a:\n\n'
          '📧 soporte@mudanzasapp.com\n'
          '📞 +505 1234 5678\n\n'
          'Horario: Lunes a Viernes 8:00 AM - 5:00 PM',
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

  void _updateAvailability(bool disponible, bool modoOcupado) {
    _debugAvailabilityValues(disponible, modoOcupado);
    setState(() {
      _disponible = disponible;
      _modoOcupado = modoOcupado;
    });

    context.read<ProviderBloc>().add(
          UpdateProviderAvailabilityEvent(
            disponible: disponible,
            modoOcupado: modoOcupado,
          ),
        );
  }

  void _debugAvailabilityValues(bool disponible, bool modoOcupado) {
    print('🔍 DEBUG - Valores de disponibilidad:');
    print('   disponible: $disponible -> ${disponible ? 1 : 0}');
    print('   modoOcupado: $modoOcupado -> ${modoOcupado ? 1 : 0}');
    print('   tipos: ${disponible.runtimeType}, ${modoOcupado.runtimeType}');
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

  String _formatVerificationStatus(String estado) {
    switch (estado) {
      case 'verificado':
        return 'Verificado ✅';
      case 'pendiente':
        return 'Pendiente ⏳';
      case 'rechazado':
        return 'Rechazado ❌';
      case 'suspendido':
        return 'Suspendido ⚠️';
      default:
        return estado;
    }
  }

  Color _getVerificationColor(String estado) {
    switch (estado) {
      case 'verificado':
        return Colors.green;
      case 'pendiente':
        return Colors.orange;
      case 'rechazado':
        return Colors.red;
      case 'suspendido':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
