import '../../core/common/result.dart';
import '../../domain/model/plato.dart';
import '../../domain/repository/plato_repository.dart';
import '../remote/plato_remote_datasource.dart';

class PlatoRepositoryImpl implements PlatoRepository {
  final PlatoRemoteDataSource remote;
  PlatoRepositoryImpl(this.remote);

  @override
  Future<Result<List<Plato>>> getAll() => remote.getAll();

  @override
  Future<Result<Plato>> getById(String id) => remote.getById(id);

  @override
  Future<Result<Plato>> create(Plato plato) => remote.create(plato);

  @override
  Future<Result<Plato>> update(Plato plato) => remote.update(plato);

  @override
  Future<Result<void>> delete(String id) => remote.delete(id);
}
