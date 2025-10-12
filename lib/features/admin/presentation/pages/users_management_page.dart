import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/admin_entities.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';

class UsersManagementPage extends StatefulWidget {
  const UsersManagementPage({super.key});

  @override
  State<UsersManagementPage> createState() => _UsersManagementPageState();
}

class _UsersManagementPageState extends State<UsersManagementPage> {
  @override
  void initState() {
    super.initState();
    // Load users when page opens
    context.read<AdminBloc>().add(const GetUsersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is UserStatusUpdated || state is UserRoleUpdated) {
            // Refresh users list after update
            context.read<AdminBloc>().add(const GetUsersEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Usuario actualizado correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminError) {
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
                    onPressed: () {
                      context.read<AdminBloc>().add(const GetUsersEvent());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is UsersLoaded) {
            final users = state.userList.users;

            return Column(
              children: [
                // Summary Card
                _buildSummaryCard(state.userList),

                // Users List
                Expanded(
                  child: ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return _buildUserCard(user);
                    },
                  ),
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildSummaryCard(UserListEntity userList) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildSummaryItem('Total', userList.pagination.total.toString()),
            _buildSummaryItem(
                'Clientes',
                userList.users
                    .where((u) => u.rol == 'cliente')
                    .length
                    .toString()),
            _buildSummaryItem(
                'Admins',
                userList.users
                    .where((u) => u.rol == 'admin')
                    .length
                    .toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(UserEntity user) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(user.rol),
          child: Text(
            user.nombre[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text('${user.nombre} ${user.apellido}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            const SizedBox(height: 4),
            Row(
              children: [
                _buildStatusChip(user.estado),
                const SizedBox(width: 8),
                _buildRoleChip(user.rol),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            _handleUserAction(value, user);
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit_role',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text('Cambiar Rol'),
                ],
              ),
            ),
            PopupMenuItem(
              value: user.estado == 'activo' ? 'deactivate' : 'activate',
              child: Row(
                children: [
                  Icon(
                    user.estado == 'activo' ? Icons.block : Icons.check_circle,
                    size: 20,
                    color: user.estado == 'activo' ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    user.estado == 'activo' ? 'Desactivar' : 'Activar',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status) {
      case 'activo':
        chipColor = Colors.green;
        break;
      case 'inactivo':
        chipColor = Colors.orange;
        break;
      case 'bloqueado':
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: chipColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildRoleChip(String role) {
    return Chip(
      label: Text(
        role.toUpperCase(),
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: _getRoleColor(role),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'cliente':
        return Colors.blue;
      case 'proveedor':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void _handleUserAction(String action, UserEntity user) {
    switch (action) {
      case 'edit_role':
        _showRoleDialog(user);
        break;
      case 'activate':
        _updateUserStatus(user.id, 'activo');
        break;
      case 'deactivate':
        _updateUserStatus(user.id, 'inactivo');
        break;
    }
  }

  void _showRoleDialog(UserEntity user) {
    String selectedRole = user.rol;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Cambiar Rol'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Selecciona el nuevo rol:'),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Rol',
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue!;
                  });
                },
                items: ['cliente', 'admin', 'proveedor']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value.toUpperCase(),
                      style: TextStyle(
                        color: _getRoleColor(value),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text(
                'Actual: ${user.rol.toUpperCase()}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: selectedRole == user.rol
                  ? null // Deshabilitar si no hay cambios
                  : () {
                      Navigator.pop(context);
                      _updateUserRole(user.id, selectedRole);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(
                  // ✅ Agregar este estilo
                  fontSize: 16, // Mismo tamaño que TextButton
                  fontWeight: FontWeight.normal,
                ),
              ),
              child: const Text('Actualizar Rol'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateUserStatus(int userId, String status) {
    context.read<AdminBloc>().add(
          UpdateUserStatusEvent(userId: userId, status: status),
        );
  }

  void _updateUserRole(int userId, String role) {
    context.read<AdminBloc>().add(
          UpdateUserRoleEvent(userId: userId, role: role),
        );
  }
}
