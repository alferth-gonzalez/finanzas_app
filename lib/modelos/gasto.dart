class Gasto {
  final int id;
  final String categoria;
  final int monto;
  final DateTime fecha;

  Gasto({
    required this.id,
    required this.categoria,
    required this.monto,
    required this.fecha,
  });

  factory Gasto.desdeMapa(Map<String, dynamic> mapa) {
    return Gasto(
      id: mapa['id'] as int,
      categoria: mapa['categoria'] as String,
      monto: mapa['monto'] as int,
      fecha: DateTime.parse(mapa['fecha'] as String),
    );
  }
}
