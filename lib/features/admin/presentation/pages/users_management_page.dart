import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mudanzas/features/admin/presentation/pages/profile_admin_page.dart';
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
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  String _currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    // Cargar usuarios al iniciar
    context.read<AdminBloc>().add(const GetUsersEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchDebounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // Cancelar búsqueda anterior
    _searchDebounce?.cancel();

    if (query.isEmpty) {
      // Si la búsqueda está vacía, cargar todos los usuarios
      _currentSearchQuery = '';
      context.read<AdminBloc>().add(const GetUsersEvent());
    } else {
      // Búsqueda con debounce
      _searchDebounce = Timer(const Duration(milliseconds: 500), () {
        _currentSearchQuery = query;
        context.read<AdminBloc>().add(SearchUsersEvent(query: query));
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _currentSearchQuery = '';
    context.read<AdminBloc>().add(const GetUsersEvent());
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Buscar usuarios por nombre, email o teléfono...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  Widget _buildSummaryCard(UserListEntity userList) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
                'Total', userList.pagination.total.toString(), Icons.people),
            _buildStatItem(
                'Página',
                '${userList.pagination.page}/${userList.pagination.pages}',
                Icons.pageview),
            _buildStatItem(
                'Clientes',
                userList.users
                    .where((u) => u.rol == 'cliente')
                    .length
                    .toString(),
                Icons.person),
            _buildStatItem(
                'Admins',
                userList.users.where((u) => u.rol == 'admin').length.toString(),
                Icons.admin_panel_settings),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade700, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildUserCard(UserEntity user) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Text(
            user.nombre[0].toUpperCase(),
            style: TextStyle(
              color: Colors.blue.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '${user.nombre} ${user.apellido}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: _buildRoleChip(user.rol),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildStatusChip(user.estado),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () => _showRoleDialog(user),
              tooltip: 'Cambiar rol',
              color: Colors.blue.shade600,
            ),
            IconButton(
              icon: const Icon(Icons.swap_vert, size: 20),
              onPressed: () => _showStatusDialog(user),
              tooltip: 'Cambiar estado',
              color: Colors.orange.shade600,
            ),
            IconButton(
              icon: const Icon(Icons.visibility, size: 20),
              onPressed: () => _openUserProfile(user),
              tooltip: 'Ver y editar perfil',
              color: Colors.green.shade600,
            ),
          ],
        ),
        onTap: () => _openUserProfile(user),
      ),
    );
  }

  Widget _buildRoleChip(String role) {
    Color color;
    switch (role) {
      case 'admin':
        color = Colors.red;
        break;
      case 'proveedor':
        color = Colors.orange;
        break;
      case 'cliente':
      default:
        color = Colors.green;
    }

    return Chip(
      label: Text(
        role.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: color,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildStatusChip(String status) {
    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: status == 'activo' ? Colors.green : Colors.red,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
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
              DropdownButton<String>(
                value: selectedRole,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedRole = newValue!;
                  });
                },
                items: ['cliente', 'admin', 'proveedor']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toUpperCase()),
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
                  ? null
                  : () {
                      Navigator.pop(context);
                      _updateUserRole(user.id, selectedRole);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 14),
              ),
              child: const Text('Actualizar Rol'),
            ),
          ],
        ),
      ),
    );
  }

  void _showStatusDialog(UserEntity user) {
    String selectedStatus = user.estado;
    String newStatus = selectedStatus == 'activo' ? 'inactivo' : 'activo';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cambiar Estado'),
        content: Text(
          '¿Estás seguro de que quieres cambiar el estado de ${user.nombre} ${user.apellido} a ${newStatus.toUpperCase()}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updateUserStatus(user.id, newStatus);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  newStatus == 'activo' ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Cambiar a ${newStatus.toUpperCase()}'),
          ),
        ],
      ),
    );
  }

  void _openUserProfile(UserEntity user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileAdminPage(user: user),
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

  Widget _buildSearchResultsInfo(UserListEntity userList) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _currentSearchQuery.isEmpty
                ? 'Todos los usuarios (${userList.pagination.total})'
                : 'Resultados para "$_currentSearchQuery" (${userList.pagination.total})',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          if (_currentSearchQuery.isNotEmpty)
            TextButton(
              onPressed: _clearSearch,
              child: const Text('Limpiar búsqueda'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_currentSearchQuery.isEmpty) {
                context.read<AdminBloc>().add(const GetUsersEvent());
              } else {
                context.read<AdminBloc>().add(
                      SearchUsersEvent(query: _currentSearchQuery),
                    );
              }
            },
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state is UserStatusUpdated || state is UserRoleUpdated) {
            // Refresh users list after update
            if (_currentSearchQuery.isEmpty) {
              context.read<AdminBloc>().add(const GetUsersEvent());
            } else {
              context.read<AdminBloc>().add(
                    SearchUsersEvent(query: _currentSearchQuery),
                  );
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Usuario actualizado correctamente'),
                backgroundColor: Colors.green,
              ),
            );
          }

          if (state is AdminError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
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
                      if (_currentSearchQuery.isEmpty) {
                        context.read<AdminBloc>().add(const GetUsersEvent());
                      } else {
                        context.read<AdminBloc>().add(
                              SearchUsersEvent(query: _currentSearchQuery),
                            );
                      }
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is UsersLoaded || state is UsersSearchLoaded) {
            final userList = state is UsersLoaded
                ? state.userList
                : (state as UsersSearchLoaded).userList;
            final users = userList.users;

            if (users.isEmpty) {
              return Column(
                children: [
                  _buildSearchBar(),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _currentSearchQuery.isEmpty
                                ? 'No hay usuarios registrados'
                                : 'No se encontraron usuarios para "$_currentSearchQuery"',
                            style: const TextStyle(fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          if (_currentSearchQuery.isNotEmpty)
                            TextButton(
                              onPressed: _clearSearch,
                              child: const Text('Ver todos los usuarios'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }

            return Column(
              children: [
                _buildSearchBar(),
                _buildSearchResultsInfo(userList),
                const SizedBox(height: 16),
                // Summary Card
                _buildSummaryCard(userList),
                const SizedBox(height: 16),
                // Users List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      if (_currentSearchQuery.isEmpty) {
                        context.read<AdminBloc>().add(const GetUsersEvent());
                      } else {
                        context.read<AdminBloc>().add(
                              SearchUsersEvent(query: _currentSearchQuery),
                            );
                      }
                    },
                    child: ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return _buildUserCard(user);
                      },
                    ),
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
}
