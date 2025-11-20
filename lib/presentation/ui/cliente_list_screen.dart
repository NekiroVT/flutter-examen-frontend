import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/common/result.dart';
import '../../core/di/service_locator.dart';
import '../../domain/model/cliente.dart';
import '../../domain/usecase/cliente_usecases.dart';
import '../adapter/app_navigator.dart';
import '../viewmodel/cliente_list_viewmodel.dart';

class ClienteListScreen extends StatelessWidget {
  const ClienteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ClienteListViewModel(
        getClientes: getIt<GetClientesUseCase>(),
        deleteCliente: getIt<DeleteClienteUseCase>(),
      )..load(),
      child: const _ClienteListBody(),
    );
  }
}

class _ClienteListBody extends StatelessWidget {
  const _ClienteListBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ClienteListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigator.goToNuevoCliente(context),
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (context) {
          if (vm.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.error != null) {
            return Center(
              child: Text(
                vm.error!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          if (vm.clientes.isEmpty) {
            return const Center(child: Text('No hay clientes registrados'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vm.clientes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final c = vm.clientes[index];
              return _ClienteItem(
                cliente: c,
                onEdit: () => AppNavigator.goToEditarCliente(context, c),
                onDelete: () async {
                  if (c.id == null) return;

                  final Result<void> res = await vm.remove(c.id!);
                  if (!context.mounted) return;

                  if (!res.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          res.error ?? 'Error al eliminar cliente',
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _ClienteItem extends StatelessWidget {
  final Cliente cliente;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ClienteItem({
    required this.cliente,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(cliente.nombre),
        subtitle: Text('Teléfono: ${cliente.telefono}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}
