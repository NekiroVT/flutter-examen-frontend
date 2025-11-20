import 'package:flutter/foundation.dart';

import '../../core/common/result.dart';
import '../../domain/model/plato.dart';
import '../../domain/usecase/plato_usecases.dart';

class PlatoFormViewModel extends ChangeNotifier {
  final CreatePlatoUseCase createPlato;
  final UpdatePlatoUseCase updatePlato;

  bool saving = false;
  String? error;

  PlatoFormViewModel({
    required this.createPlato,
    required this.updatePlato,
  });

  Future<Result<Plato>> save(Plato plato) async {
    saving = true;
    error = null;
    notifyListeners();

    Result<Plato> res;
    if (plato.id == null) {
      res = await createPlato(plato);
    } else {
      res = await updatePlato(plato);
    }

    if (!res.isSuccess) {
      error = res.error;
    }

    saving = false;
    notifyListeners();
    return res;
  }
}
