import '../../core/common/result.dart';
import '../model/pedido.dart';
import '../repository/pedido_repository.dart';

class UpdatePedidoUseCase {
  final PedidoRepository repository;

  UpdatePedidoUseCase(this.repository);

  Future<Result<Pedido>> call(Pedido pedido) {
    return repository.update(pedido);
  }
}
