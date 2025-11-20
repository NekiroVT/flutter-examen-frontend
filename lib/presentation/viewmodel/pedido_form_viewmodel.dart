import 'package:flutter/foundation.dart';

import '../../core/common/result.dart';
import '../../domain/model/pedido.dart';
import '../../domain/usecase/pedido_usecases.dart';

class PedidoFormViewModel extends ChangeNotifier {
  final CreatePedidoUseCase createPedido;
  final UpdatePedidoUseCase updatePedido;

  bool saving = false;
  String? error;

  PedidoFormViewModel({
    required this.createPedido,
    required this.updatePedido,
  });

  Future<Result<Pedido>> save(Pedido p) async {
    saving = true;
    error = null;
    notifyListeners();

    Result<Pedido> res;
    if (p.id == null) {
      res = await createPedido(p);
    } else {
      res = await updatePedido(p);
    }

    if (!res.isSuccess) {
      error = res.error;
    }

    saving = false;
    notifyListeners();
    return res;
  }
}
