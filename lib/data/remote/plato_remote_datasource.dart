import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../core/common/result.dart';
import '../../domain/model/plato.dart';
import '../mapper/plato_mapper.dart';

abstract class PlatoRemoteDataSource {
  Future<Result<List<Plato>>> getAll();
  Future<Result<Plato>> getById(String id);
  Future<Result<Plato>> create(Plato plato);
  Future<Result<Plato>> update(Plato plato);
  Future<Result<void>> delete(String id);
}

class PlatoRemoteDataSourceImpl implements PlatoRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'http://localhost:8082/api/platos';

  PlatoRemoteDataSourceImpl(this.client);

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
  Future<Result<List<Plato>>> getAll() async {
    try {
      final res = await client.get(Uri.parse(baseUrl));
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        final platos = data.map((e) => PlatoMapper.fromJson(e)).toList();
        return Result.success(platos);
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al obtener platos');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }

  @override
  Future<Result<Plato>> getById(String id) async {
    try {
      final res = await client.get(Uri.parse('$baseUrl/$id'));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return Result.success(PlatoMapper.fromJson(data));
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al obtener plato');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }

  @override
  Future<Result<Plato>> create(Plato plato) async {
    try {
      final res = await client.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(PlatoMapper.toJson(plato)),
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        final data = json.decode(res.body);
        return Result.success(PlatoMapper.fromJson(data));
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al crear plato');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }

  @override
  Future<Result<Plato>> update(Plato plato) async {
    try {
      final res = await client.put(
        Uri.parse('$baseUrl/${plato.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(PlatoMapper.toJson(plato)),
      );
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        return Result.success(PlatoMapper.fromJson(data));
      }
      final msg =
          _extractMessage(res, 'Error ${res.statusCode} al actualizar plato');
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
          _extractMessage(res, 'Error ${res.statusCode} al eliminar plato');
      return Result.failure(msg);
    } catch (e) {
      return Result.failure('Error de red: $e');
    }
  }
}
