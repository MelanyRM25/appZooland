class Desparasitacion {
  String? id;
  final String idMascota;
  final String productoDesparasitante;
  final DateTime fechaDosis;
  final DateTime proximaDosis;
  final double pesoMascota;
  final DateTime fechaRegistro;

  Desparasitacion({
    this.id,
    required this.idMascota,
    required this.productoDesparasitante,
    required this.fechaDosis,
    required this.proximaDosis,
    required this.pesoMascota,
    DateTime? fechaRegistro,
  }) : fechaRegistro = fechaRegistro ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'id_mascota': idMascota,
      'producto_desparasitante': productoDesparasitante,
      'fecha_dosis': fechaDosis.toIso8601String(),
      'proxima_dosis': proximaDosis.toIso8601String(),
      'peso_mascota': pesoMascota,
      'fecha_registro': fechaRegistro.toIso8601String(),
    };
  }

  factory Desparasitacion.fromMap(Map<String, dynamic> map) {
    return Desparasitacion(
      id: map['id']?.toString(),
      idMascota: map['id_mascota'],
      productoDesparasitante: map['producto_desparasitante'],
      fechaDosis: DateTime.parse(map['fecha_dosis']),
      proximaDosis: DateTime.parse(map['proxima_dosis']),
      pesoMascota: (map['peso_mascota'] as num).toDouble(),
      fechaRegistro: DateTime.parse(map['fecha_registro']),
    );
  }
}
