class TramiteEntity {
  final String numero;
  final String concepto;
  final String fecha;
  final String estado;
  final double monto;

  const TramiteEntity({
    required this.numero,
    required this.concepto,
    required this.fecha,
    required this.estado,
    required this.monto,
  });

  factory TramiteEntity.fromJson(Map<String, dynamic> json) {
    return TramiteEntity(
      numero: json['numero'] ?? json['num_tramite'] ?? '',
      concepto: json['concepto'] ?? json['detalle'] ?? '',
      fecha: json['fecha'] ?? '',
      estado: json['estado'] ?? 'En Proceso',
      monto: (json['monto'] as num?)?.toDouble() ?? 0.0,
    );
  }
}