import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/common/result.dart';
import '../../domain/model/pedido.dart';
import '../mapper/pedido_mapper.dart';

abstract class PedidoRemoteDataSource {
  Future<Result<List<Pedido>>> getAll();
  Future<Result<Pedido>> getById(String id);
  Future<Result<Pedido>> create(Pedido pedido);
  Future<Result<Pedido>> update(Pedido pedido);
  Future<Result<void>> delete(String id);
}

class PedidoRemoteDataSourceImpl implements PedidoRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'http://localhost:8082/api/pedidos';

  PedidoRemoteDataSourceImpl(this.client);

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
  Future<Result<List<Pedido>>> getAll() async {
    try {
      final res = await client.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        final pedidos = data.map((e) => PedidoMapper.fromJson(e)).toList();
        return Result.success(pedidos);
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al obtener pedidos');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }

  @override
  Future<Result<Pedido>> getById(String id) async {
    try {
      final res = await client.get(Uri.parse('$baseUrl/$id'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return Result.success(PedidoMapper.fromJson(data));
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al obtener pedido');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }

  @override
  Future<Result<Pedido>> create(Pedido p) async {
    try {
      final res = await client.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(PedidoMapper.toJson(p)),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = json.decode(res.body);
        return Result.success(PedidoMapper.fromJson(data));
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al crear pedido');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }

  @override
  Future<Result<Pedido>> update(Pedido p) async {
    try {
      final res = await client.put(
        Uri.parse('$baseUrl/${p.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(PedidoMapper.toJson(p)),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return Result.success(PedidoMapper.fromJson(data));
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al actualizar pedido');
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
          _extractMessage(res, 'Error ${res.statusCode} al eliminar pedido');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }
}
