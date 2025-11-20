import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/common/result.dart';
import '../../core/di/service_locator.dart';
import '../../domain/model/plato.dart';
import '../../domain/usecase/plato_usecases.dart';
import '../adapter/app_navigator.dart';
import '../viewmodel/plato_list_viewmodel.dart';

class PlatoListScreen extends StatelessWidget {
  const PlatoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlatoListViewModel(
        getPlatos: getIt<GetPlatosUseCase>(),
        deletePlato: getIt<DeletePlatoUseCase>(),
      )..load(),
      child: const _PlatoListBody(),
    );
  }
}

class _PlatoListBody extends StatelessWidget {
  const _PlatoListBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlatoListViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platos'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AppNavigator.goToNuevoPlato(context),
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (context) {
          if (vm.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.error != null) {
            return Center(child: Text(vm.error!, style: const TextStyle(color: Colors.red)));
          }
          if (vm.platos.isEmpty) {
            return const Center(child: Text('No hay platos registrados'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: vm.platos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, index) {
              final p = vm.platos[index];
              return _PlatoItem(
                plato: p,
                onEdit: () => AppNavigator.goToEditarPlato(context, p),
                onDelete: () async {
                  if (p.id == null) return;
                  final Result<void> res = await vm.remove(p.id!);
                  if (!context.mounted) return;
                  if (!res.isSuccess) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(res.error ?? 'Error al eliminar plato')),
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

class _PlatoItem extends StatelessWidget {
  final Plato plato;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _PlatoItem({
    required this.plato,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(plato.nombre),
        subtitle: Text('${plato.descripcion}\nS/ ${plato.precio.toStringAsFixed(2)}'),
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
