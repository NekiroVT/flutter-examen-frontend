import 'package:flutter/foundation.dart';

import '../../core/common/result.dart';
import '../../domain/model/cliente.dart';
import '../../domain/usecase/cliente_usecases.dart';

class ClienteFormViewModel extends ChangeNotifier {
  final CreateClienteUseCase createCliente;
  final UpdateClienteUseCase updateCliente;

  bool saving = false;
  String? error;

  ClienteFormViewModel({
    required this.createCliente,
    required this.updateCliente,
  });

  Future<Result<Cliente>> save(Cliente c) async {
    saving = true;
    error = null;
    notifyListeners();

    Result<Cliente> res;
    if (c.id == null) {
      res = await createCliente(c);
    } else {
      res = await updateCliente(c);
    }

    if (!res.isSuccess) {
      error = res.error;
    }

    saving = false;
    notifyListeners();
    return res;
  }
}
