import '../../domain/model/plato.dart';

class PlatoMapper {
  static Plato fromJson(Map<String, dynamic> json) {
    return Plato(
      id: json['id']?.toString(),
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      precio: (json['precio'] as num).toDouble(),
    );
  }

  static Map<String, dynamic> toJson(Plato plato) {
    return {
      'id': plato.id,
      'nombre': plato.nombre,
      'descripcion': plato.descripcion,
      'precio': plato.precio,
    };
  }
}
