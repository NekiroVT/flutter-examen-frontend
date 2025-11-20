import '../../core/common/result.dart';
import '../model/pedido.dart';
import '../repository/pedido_repository.dart';

class CreatePedidoUseCase {
  final PedidoRepository repository;

  CreatePedidoUseCase(this.repository);

  Future<Result<Pedido>> call(Pedido pedido) {
    return repository.create(pedido);
  }
}
