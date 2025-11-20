import '../../domain/model/cliente.dart';

class ClienteMapper {
  static Cliente fromJson(Map<String, dynamic> json) {
    return Cliente(
      id: json['id']?.toString(),
      nombre: json['nombre'] ?? '',
      telefono: json['telefono'] ?? '',
    );
  }

  static Map<String, dynamic> toJson(Cliente c) {
    return {
      'id': c.id,
      'nombre': c.nombre,
      'telefono': c.telefono,
    };
  }
}
