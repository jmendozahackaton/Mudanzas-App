import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';
import 'users_management_page.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  void initState() {
    super.initState();
    // Cargar usuarios al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminBloc>().add(const GetUsersEvent(page: 1, limit: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // ✅ ESCUCHAR AuthUnauthenticated PARA LOGOUT
        if (state is AuthUnauthenticated) {
          print('🚪 Sesión cerrada - Redirigiendo a login');
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false, // Remover todas las rutas
          );
        }
        // ✅ TAMBIÉN MANEJAR ERRORES DURANTE LOGOUT
        else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        // ✅ TU SCAFFOLD ACTUAL SE MANTIENE IGUAL
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Panel Administrador'),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              _buildWelcomeSection(context),
              const SizedBox(height: 32),

              // Statistics
              _buildStatisticsSection(),
              const SizedBox(height: 32),

              // Quick Actions
              _buildAdminActions(context),
              const SizedBox(height: 32),

              // Recent Activity
              _buildRecentActivity(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userName = 'Administrador';
        if (state is AuthAuthenticated) {
          userName = state.user.nombre;
        }

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
                color: Colors.blue.withValues(alpha: 0.3),
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
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '¡Bienvenido, $userName!',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Panel de control administrativo',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatisticsSection() {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        int usersCount = 0;
        if (state is UsersLoaded) {
          usersCount = state.userList.pagination.total;
        }
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildStatCard(
              'Total Usuarios',
              usersCount.toString(),
              Icons.people,
              Colors.blue,
            ),
            _buildStatCard(
              'Mudanzas Activas',
              '23',
              Icons.local_shipping,
              Colors.green,
            ),
            _buildStatCard(
              'Ingresos Mensuales',
              '\$12,450',
              Icons.attach_money,
              Colors.orange,
            ),
            _buildStatCard(
              'Soporte Pendiente',
              '8',
              Icons.support_agent,
              Colors.purple,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Acciones Administrativas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
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
            _buildAdminActionCard(
              Icons.people,
              'Gestión Usuarios',
              Colors.blue,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UsersManagementPage()),
              ),
            ),
            _buildAdminActionCard(
              Icons.local_shipping,
              'Gestión Mudanzas',
              Colors.green,
              () => _showMovingManagement(context),
            ),
            _buildAdminActionCard(
              Icons.work,
              'Gestión Proveedores',
              Colors.orange,
              () => _showProviderManagement(context),
            ),
            _buildAdminActionCard(
              Icons.bar_chart,
              'Reportes',
              Colors.purple,
              () => _showReports(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdminActionCard(
      IconData icon, String title, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Actividad Reciente',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildAdminActivityItem(
                    'Nuevo usuario registrado', 'Hace 5 min'),
                const Divider(),
                _buildAdminActivityItem('Mudanza completada', 'Hace 1 hora'),
                const Divider(),
                _buildAdminActivityItem('Pago procesado', 'Hace 2 horas'),
                const Divider(),
                _buildAdminActivityItem('Solicitud de soporte', 'Hace 3 horas'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAdminActivityItem(String title, String time) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.notifications, color: Colors.blue, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        time,
        style: const TextStyle(color: Colors.grey),
      ),
    );
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
              print('1️⃣ Diálogo: Usuario confirmó logout');
              Navigator.pop(context);
              print('2️⃣ Diálogo: Navegando a AuthBloc...');
              context.read<AuthBloc>().add(LogoutEvent());
              print('3️⃣ Diálogo: LogoutEvent enviado');
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

  void _showMovingManagement(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gestión de mudanzas - Funcionalidad en desarrollo'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showProviderManagement(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gestión de proveedores - Funcionalidad en desarrollo'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _showReports(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reportes y analytics - Funcionalidad en desarrollo'),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
