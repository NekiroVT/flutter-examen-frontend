import '../../core/common/result.dart';
import '../model/pedido.dart';
import '../repository/pedido_repository.dart';

class GetPedidosUseCase {
  final PedidoRepository repository;

  GetPedidosUseCase(this.repository);

  Future<Result<List<Pedido>>> call() {
    return repository.getAll();
  }
}
