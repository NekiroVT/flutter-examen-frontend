import 'package:flutter/foundation.dart';

import '../../core/common/result.dart';
import '../../domain/model/cliente.dart';
import '../../domain/usecase/cliente_usecases.dart';

class ClienteListViewModel extends ChangeNotifier {
  final GetClientesUseCase getClientes;
  final DeleteClienteUseCase deleteCliente;

  ClienteListViewModel({
    required this.getClientes,
    required this.deleteCliente,
  });

  List<Cliente> clientes = [];
  bool loading = false;
  String? error;

  Future<void> load() async {
    loading = true;
    notifyListeners();

    final res = await getClientes();
    if (res.isSuccess) {
      clientes = res.data!;
      error = null;
    } else {
      error = res.error;
    }
    loading = false;
    notifyListeners();
  }

  Future<Result<void>> remove(String id) async {
    final res = await deleteCliente(id);
    if (res.isSuccess) {
      clientes.removeWhere((c) => c.id == id);
      notifyListeners();
    }
    return res;
  }
}
