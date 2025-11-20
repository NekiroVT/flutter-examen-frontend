import 'package:flutter/foundation.dart';

import '../../core/common/result.dart';
import '../../domain/model/plato.dart';
import '../../domain/usecase/plato_usecases.dart';

class PlatoListViewModel extends ChangeNotifier {
  final GetPlatosUseCase getPlatos;
  final DeletePlatoUseCase deletePlato;

  PlatoListViewModel({
    required this.getPlatos,
    required this.deletePlato,
  });

  List<Plato> platos = [];
  bool loading = false;
  String? error;

  Future<void> load() async {
    loading = true;
    notifyListeners();

    final res = await getPlatos();
    if (res.isSuccess) {
      platos = res.data!;
      error = null;
    } else {
      error = res.error;
    }
    loading = false;
    notifyListeners();
  }

  Future<Result<void>> remove(String id) async {
    final res = await deletePlato(id);
    if (res.isSuccess) {
      platos.removeWhere((p) => p.id == id);
      notifyListeners();
    }
    return res;
  }
}
