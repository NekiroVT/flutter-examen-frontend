import '../../core/common/result.dart';
import '../model/cliente.dart';
import '../repository/cliente_repository.dart';

class GetClientesUseCase {
  final ClienteRepository repository;
  GetClientesUseCase(this.repository);
  Future<Result<List<Cliente>>> call() => repository.getAll();
}

class GetClienteByIdUseCase {
  final ClienteRepository repository;
  GetClienteByIdUseCase(this.repository);
  Future<Result<Cliente>> call(String id) => repository.getById(id);
}

class CreateClienteUseCase {
  final ClienteRepository repository;
  CreateClienteUseCase(this.repository);
  Future<Result<Cliente>> call(Cliente c) => repository.create(c);
}

class UpdateClienteUseCase {
  final ClienteRepository repository;
  UpdateClienteUseCase(this.repository);
  Future<Result<Cliente>> call(Cliente c) => repository.update(c);
}

class DeleteClienteUseCase {
  final ClienteRepository repository;
  DeleteClienteUseCase(this.repository);
  Future<Result<void>> call(String id) => repository.delete(id);
}
