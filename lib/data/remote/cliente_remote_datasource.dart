import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/common/result.dart';
import '../../domain/model/cliente.dart';
import '../mapper/cliente_mapper.dart';

abstract class ClienteRemoteDataSource {
  Future<Result<List<Cliente>>> getAll();
  Future<Result<Cliente>> getById(String id);
  Future<Result<Cliente>> create(Cliente cliente);
  Future<Result<Cliente>> update(Cliente cliente);
  Future<Result<void>> delete(String id);
}

class ClienteRemoteDataSourceImpl implements ClienteRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'http://localhost:8082/api/clientes';

  ClienteRemoteDataSourceImpl(this.client);

  String _extractMessage(http.Response res, String defaultMessage) {
    String message = defaultMessage;
    try {
      final body = json.decode(res.body);
      if (body is Map && body['message'] is String) {
        message = body['message'] as String;
      }
    } catch (_) {}
    return message;
  }

  @override
  Future<Result<List<Cliente>>> getAll() async {
    try {
      final res = await client.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        final clientes = data.map((e) => ClienteMapper.fromJson(e)).toList();
        return Result.success(clientes);
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al obtener clientes');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }

  @override
  Future<Result<Cliente>> getById(String id) async {
    try {
      final res = await client.get(Uri.parse('$baseUrl/$id'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return Result.success(ClienteMapper.fromJson(data));
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al obtener cliente');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }

  @override
  Future<Result<Cliente>> create(Cliente cliente) async {
    try {
      final res = await client.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(ClienteMapper.toJson(cliente)),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = json.decode(res.body);
        return Result.success(ClienteMapper.fromJson(data));
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al crear cliente');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }

  @override
  Future<Result<Cliente>> update(Cliente cliente) async {
    try {
      final res = await client.put(
        Uri.parse('$baseUrl/${cliente.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(ClienteMapper.toJson(cliente)),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return Result.success(ClienteMapper.fromJson(data));
      }
      final msg = _extractMessage(
          res, 'Error ${res.statusCode} al actualizar cliente');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }

  @override
  Future<Result<void>> delete(String id) async {
    try {
      final res = await client.delete(Uri.parse('$baseUrl/$id'));
      if (res.statusCode == 200 || res.statusCode == 204) {
        return Result.success(null);
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al eliminar cliente');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }
}
