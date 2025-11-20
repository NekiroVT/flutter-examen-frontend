import '../../core/common/result.dart';
import '../../domain/model/pedido.dart';
import '../../domain/repository/pedido_repository.dart';
import '../remote/pedido_remote_datasource.dart';

class PedidoRepositoryImpl implements PedidoRepository {
  final PedidoRemoteDataSource remote;
  PedidoRepositoryImpl(this.remote);

  @override
  Future<Result<List<Pedido>>> getAll() => remote.getAll();

  @override
  Future<Result<Pedido>> getById(String id) => remote.getById(id);

  @override
  Future<Result<Pedido>> create(Pedido p) => remote.create(p);

  @override
  Future<Result<Pedido>> update(Pedido p) => remote.update(p);

  @override
  Future<Result<void>> delete(String id) => remote.delete(id);
}
