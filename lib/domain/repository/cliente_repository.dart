import '../../core/common/result.dart';
import '../model/cliente.dart';

abstract class ClienteRepository {
  Future<Result<List<Cliente>>> getAll();
  Future<Result<Cliente>> getById(String id);
  Future<Result<Cliente>> create(Cliente cliente);
  Future<Result<Cliente>> update(Cliente cliente);
  Future<Result<void>> delete(String id);
}
