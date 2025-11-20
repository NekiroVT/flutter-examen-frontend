import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/common/result.dart';
import '../../core/di/service_locator.dart';
import '../../domain/model/pedido.dart';
import '../../domain/usecase/pedido_usecases.dart';
import '../../domain/usecase/cliente_usecases.dart';
import '../../domain/usecase/plato_usecases.dart';
import '../adapter/app_navigator.dart';
import '../viewmodel/pedido_list_viewmodel.dart';

class PedidoListScreen extends StatelessWidget {
  const PedidoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PedidoListViewModel(
        getPedidos: getIt<GetPedidosUseCase>(),
        deletePedido: getIt<DeletePedidoUseCase>(),
        getClientes: getIt<GetClientesUseCase>(),
        getPlatos: getIt<GetPlatosUseCase>(),
      )..load(),
      child: const _PedidoListBody(),
    );
  }
}

class _PedidoListBody extends StatelessWidget {
  const _PedidoListBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PedidoListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigator.goToNuevoPedido(context),
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
          if (vm.pedidos.isEmpty) {
            return const Center(child: Text('No hay pedidos registrados'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vm.pedidos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final p = vm.pedidos[index];
              final clienteNombre = vm.getClienteNombre(p.clienteId);
              final platoNombre = vm.getPlatoNombre(p.platoId);

              return _PedidoItem(
                pedido: p,
                clienteNombre: clienteNombre,
                platoNombre: platoNombre,
                onEdit: () => AppNavigator.goToEditarPedido(context, p),
                onDelete: () async {
                  if (p.id == null) return;

                  final Result<void> res = await vm.remove(p.id!);
                  if (!context.mounted) return;

                  if (!res.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          res.error ?? 'Error al eliminar pedido',
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

class _PedidoItem extends StatelessWidget {
  final Pedido pedido;
  final String clienteNombre;
  final String platoNombre;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PedidoItem({
    required this.pedido,
    required this.clienteNombre,
    required this.platoNombre,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Mesa ${pedido.numeroMesa}'),
        subtitle: Text(
          'Cliente: $clienteNombre\nPlato: $platoNombre',
        ),
        isThreeLine: true,
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
