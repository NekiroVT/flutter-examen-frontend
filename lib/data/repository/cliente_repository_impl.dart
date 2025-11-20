import '../../core/common/result.dart';
import '../../domain/model/cliente.dart';
import '../../domain/repository/cliente_repository.dart';
import '../remote/cliente_remote_datasource.dart';

class ClienteRepositoryImpl implements ClienteRepository {
  final ClienteRemoteDataSource remote;
  ClienteRepositoryImpl(this.remote);

  @override
  Future<Result<List<Cliente>>> getAll() => remote.getAll();

  @override
  Future<Result<Cliente>> getById(String id) => remote.getById(id);

  @override
  Future<Result<Cliente>> create(Cliente c) => remote.create(c);

  @override
  Future<Result<Cliente>> update(Cliente c) => remote.update(c);

  @override
  Future<Result<void>> delete(String id) => remote.delete(id);
}
