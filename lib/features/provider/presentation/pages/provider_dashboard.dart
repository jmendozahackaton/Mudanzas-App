import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/provider_bloc.dart';
import '../bloc/provider_event.dart';
import '../bloc/provider_state.dart';

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
    context.read<ProviderBloc>().add(GetProviderProfileEvent());
    context.read<ProviderBloc>().add(GetProviderStatisticsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ],
      ),
      body: BlocConsumer<ProviderBloc, ProviderState>(
        listener: (context, state) {
          if (state is ProviderError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ProviderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Estado de disponibilidad
                _buildAvailabilityCard(),
                const SizedBox(height: 20),

                // Estadísticas
                if (state is ProviderStatisticsLoaded)
                  _buildStatisticsCard(state.statistics),
                const SizedBox(height: 20),

                // Información del perfil
                if (state is ProviderProfileLoaded)
                  _buildProfileCard(state.provider),
                const SizedBox(height: 20),

                // Acciones rápidas
                _buildQuickActions(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvailabilityCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estado de Disponibilidad',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
            const SizedBox(height: 8),
            Text(
              _disponible
                  ? (_modoOcupado
                      ? '✅ Disponible (Ocupado)'
                      : '✅ Disponible para nuevos servicios')
                  : '❌ No disponible',
              style: TextStyle(
                color: _disponible ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
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
    return Row(
      children: [
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: activeColor,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard(statistics) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Estadísticas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
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
                  statistics.puntuacionPromedio.toStringAsFixed(1),
                  Icons.star,
                  Colors.orange,
                ),
                _buildStatItem(
                  'Ingresos',
                  '\$${statistics.ingresosTotales.toStringAsFixed(2)}',
                  Icons.attach_money,
                  Colors.green,
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

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withAlpha(10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 30, color: color),
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
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(provider) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información del Perfil',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: const Text('Nombre'),
              subtitle: Text('${provider.nombre} ${provider.apellido}'),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text('Email'),
              subtitle: Text(provider.email),
            ),
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.blue),
              title: const Text('Teléfono'),
              subtitle: Text(provider.telefono ?? 'No especificado'),
            ),
            ListTile(
              leading: const Icon(Icons.work, color: Colors.blue),
              title: const Text('Tipo de Cuenta'),
              subtitle: Text(provider.tipoCuenta.toUpperCase()),
            ),
            ListTile(
              leading: const Icon(Icons.verified, color: Colors.blue),
              title: const Text('Estado de Verificación'),
              subtitle: Text(
                provider.estadoVerificacion.toUpperCase(),
                style: TextStyle(
                  color: _getVerificationColor(provider.estadoVerificacion),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acciones Rápidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
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
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
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

  void _updateAvailability(bool disponible, bool modoOcupado) {
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

  void _navigateToProfile() {
    // Navigator.pushNamed(context, AppRoutes.providerProfile);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidad en desarrollo')),
    );
  }

  void _navigateToServices() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidad en desarrollo')),
    );
  }

  void _updateLocation() {
    // Simular actualización de ubicación
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Actualizando ubicación...')),
    );

    // En una app real, aquí obtendrías la ubicación actual del dispositivo
    final lat = 19.4326; // Ejemplo: Ciudad de México
    final lng = -99.1332;

    context.read<ProviderBloc>().add(
          UpdateProviderLocationEvent(lat: lat, lng: lng),
        );
  }

  void _contactSupport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidad en desarrollo')),
    );
  }
}
