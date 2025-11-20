import '../../core/common/result.dart';
import '../model/plato.dart';
import '../repository/plato_repository.dart';

class GetPlatosUseCase {
  final PlatoRepository repository;
  GetPlatosUseCase(this.repository);
  Future<Result<List<Plato>>> call() => repository.getAll();
}

class GetPlatoByIdUseCase {
  final PlatoRepository repository;
  GetPlatoByIdUseCase(this.repository);
  Future<Result<Plato>> call(String id) => repository.getById(id);
}

class CreatePlatoUseCase {
  final PlatoRepository repository;
  CreatePlatoUseCase(this.repository);
  Future<Result<Plato>> call(Plato plato) => repository.create(plato);
}

class UpdatePlatoUseCase {
  final PlatoRepository repository;
  UpdatePlatoUseCase(this.repository);
  Future<Result<Plato>> call(Plato plato) => repository.update(plato);
}

class DeletePlatoUseCase {
  final PlatoRepository repository;
  DeletePlatoUseCase(this.repository);
  Future<Result<void>> call(String id) => repository.delete(id);
}
