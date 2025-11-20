import 'package:flutter/foundation.dart';

import '../../core/common/result.dart';
import '../../domain/model/pedido.dart';
import '../../domain/model/cliente.dart';
import '../../domain/model/plato.dart';
import '../../domain/usecase/pedido_usecases.dart';
import '../../domain/usecase/cliente_usecases.dart';
import '../../domain/usecase/plato_usecases.dart';

class PedidoListViewModel extends ChangeNotifier {
  final GetPedidosUseCase getPedidos;
  final DeletePedidoUseCase deletePedido;

  final GetClientesUseCase getClientes;
  final GetPlatosUseCase getPlatos;

  bool loading = false;
  String? error;
  List<Pedido> pedidos = [];

  final Map<String, String> _clienteNombrePorId = {};
  final Map<String, String> _platoNombrePorId = {};

  PedidoListViewModel({
    required this.getPedidos,
    required this.deletePedido,
    required this.getClientes,
    required this.getPlatos,
  });

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();

    // 1) Pedidos
    final resPedidos = await getPedidos();
    if (!resPedidos.isSuccess || resPedidos.data == null) {
      loading = false;
      error = resPedidos.error ?? 'Error al cargar pedidos';
      notifyListeners();
      return;
    }
    pedidos = resPedidos.data!;

    // 2) Cargar Clientes
    final resClientes = await getClientes();
    if (resClientes.isSuccess && resClientes.data != null) {
      for (Cliente c in resClientes.data!) {
        if (c.id != null) {
          _clienteNombrePorId[c.id!] = c.nombre;
        }
      }
    }

    // 3) Cargar Platos
    final resPlatos = await getPlatos();
    if (resPlatos.isSuccess && resPlatos.data != null) {
      for (Plato p in resPlatos.data!) {
        if (p.id != null) {
          _platoNombrePorId[p.id!] = p.nombre;
        }
      }
    }

    loading = false;
    notifyListeners();
  }

  String getClienteNombre(String? id) {
    if (id == null) return '—';
    return _clienteNombrePorId[id] ?? id; // Si no lo encuentra, muestra el UUID
  }

  String getPlatoNombre(String? id) {
    if (id == null) return '—';
    return _platoNombrePorId[id] ?? id;
  }

  Future<Result<void>> remove(String id) async {
    final res = await deletePedido(id);
    if (res.isSuccess) {
      pedidos.removeWhere((p) => p.id == id);
      notifyListeners();
    }
    return res;
  }
}
