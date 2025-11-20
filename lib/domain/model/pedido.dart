class Pedido {
  final String? id; // UUID
  final int numeroMesa;
  final String clienteId; // uuid cliente
  final String platoId;   // uuid plato

  Pedido({
    this.id,
    required this.numeroMesa,
    required this.clienteId,
    required this.platoId,
  });
}
