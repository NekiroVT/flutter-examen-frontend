class Cliente {
  final String? id; // UUID
  final String nombre;
  final String telefono;

  Cliente({
    this.id,
    required this.nombre,
    required this.telefono,
  });
}
