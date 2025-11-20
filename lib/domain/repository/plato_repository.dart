import '../../core/common/result.dart';
import '../model/plato.dart';

abstract class PlatoRepository {
  Future<Result<List<Plato>>> getAll();
  Future<Result<Plato>> getById(String id);
  Future<Result<Plato>> create(Plato plato);
  Future<Result<Plato>> update(Plato plato);
  Future<Result<void>> delete(String id);
}
