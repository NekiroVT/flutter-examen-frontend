import '../../domain/model/pedido.dart';

class PedidoMapper {
  static Pedido fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id']?.toString(),
      numeroMesa: json['numeroMesa'],
      clienteId: json['clienteId']?.toString() ?? '',
      platoId: json['platoId']?.toString() ?? '',
    );
  }

  static Map<String, dynamic> toJson(Pedido p) {
    return {
      'id': p.id,
      'numeroMesa': p.numeroMesa,
      'clienteId': p.clienteId,
      'platoId': p.platoId,
    };
  }
}
