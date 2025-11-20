import '../../core/common/result.dart';
import '../model/pedido.dart';
import '../repository/pedido_repository.dart';

class GetPedidosUseCase {
  final PedidoRepository repository;
  GetPedidosUseCase(this.repository);
  Future<Result<List<Pedido>>> call() => repository.getAll();
}

class GetPedidoByIdUseCase {
  final PedidoRepository repository;
  GetPedidoByIdUseCase(this.repository);
  Future<Result<Pedido>> call(String id) => repository.getById(id);
}

class CreatePedidoUseCase {
  final PedidoRepository repository;
  CreatePedidoUseCase(this.repository);
  Future<Result<Pedido>> call(Pedido p) => repository.create(p);
}

class UpdatePedidoUseCase {
  final PedidoRepository repository;
  UpdatePedidoUseCase(this.repository);
  Future<Result<Pedido>> call(Pedido p) => repository.update(p);
}

class DeletePedidoUseCase {
  final PedidoRepository repository;
  DeletePedidoUseCase(this.repository);
  Future<Result<void>> call(String id) => repository.delete(id);
}
