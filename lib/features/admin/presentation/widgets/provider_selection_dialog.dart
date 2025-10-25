import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../provider/domain/entities/provider_entities.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_event.dart';
import '../bloc/admin_state.dart';

class ProviderSelectionDialog extends StatefulWidget {
  final int solicitudId;
  final Function(int, int) onProviderSelected;

  const ProviderSelectionDialog({
    super.key,
    required this.solicitudId,
    required this.onProviderSelected,
  });

  @override
  State<ProviderSelectionDialog> createState() =>
      _ProviderSelectionDialogState();
}

class _ProviderSelectionDialogState extends State<ProviderSelectionDialog> {
  List<ProviderEntity> _providers = [];
  bool _loading = true;
  int? _selectedProviderId;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  void _loadProviders() {
    context.read<AdminBloc>().add(const GetProvidersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminBloc, AdminState>(
      listener: (context, state) {
        if (state is ProvidersLoaded) {
          setState(() {
            _providers = state.providerList.providers;
            _loading = false;
          });
        } else if (state is AdminError) {
          setState(() {
            _loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Seleccionar Proveedor'),
        content: _loading
            ? const Center(child: CircularProgressIndicator())
            : _providers.isEmpty
                ? const Text('No hay proveedores disponibles')
                : SizedBox(
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: _providers.length,
                      itemBuilder: (context, index) {
                        final provider = _providers[index];
                        return _buildProviderCard(provider);
                      },
                    ),
                  ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: _selectedProviderId != null
                ? () {
                    widget.onProviderSelected(
                      widget.solicitudId,
                      _selectedProviderId!,
                    );
                    Navigator.pop(context);
                  }
                : null,
            child: const Text('Asignar'),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard(ProviderEntity provider) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: _selectedProviderId == provider.id
          ? Colors.blue.shade50
          : Colors.white,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _getLevelColor(provider.nivelProveedor),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text('${provider.nombre} ${provider.apellido}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '⭐ ${provider.puntuacionPromedio?.toStringAsFixed(1) ?? '0.0'}'),
            Text(
              'Nivel: ${_formatNivel(provider.nivelProveedor)}',
              style: TextStyle(
                color: _getLevelColor(provider.nivelProveedor),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: provider.disponible
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.red),
        onTap: provider.disponible
            ? () {
                setState(() {
                  _selectedProviderId = provider.id;
                });
              }
            : null,
      ),
    );
  }

  Color _getLevelColor(String nivel) {
    switch (nivel) {
      case 'oro':
        return Colors.amber;
      case 'plata':
        return Colors.grey;
      case 'bronce':
        return Colors.brown;
      default:
        return Colors.blue;
    }
  }

  String _formatNivel(String nivel) {
    switch (nivel) {
      case 'oro':
        return 'Oro';
      case 'plata':
        return 'Plata';
      case 'bronce':
        return 'Bronce';
      default:
        return nivel;
    }
  }
}
