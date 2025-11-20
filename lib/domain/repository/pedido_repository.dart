import '../../core/common/result.dart';
import '../model/pedido.dart';

abstract class PedidoRepository {
  Future<Result<List<Pedido>>> getAll();
  Future<Result<Pedido>> getById(String id);
  Future<Result<Pedido>> create(Pedido pedido);
  Future<Result<Pedido>> update(Pedido pedido);
  Future<Result<void>> delete(String id);
}
