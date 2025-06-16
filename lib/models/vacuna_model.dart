class Vacuna {
  String? id;
  final String idMascota;
  final String nombreVacuna;
  final DateTime fechaAplicacion;
  final DateTime fechaProximaDosis;
  final double pesoMascota;

  Vacuna({
    this.id,
    required this.idMascota,
    required this.nombreVacuna,
    required this.fechaAplicacion,
    required this.fechaProximaDosis,
    required this.pesoMascota,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'id_mascota': idMascota,
      'nombre_vacuna': nombreVacuna,
      'fecha_aplicacion': fechaAplicacion.toIso8601String(),
      'fecha_proxima_dosis': fechaProximaDosis.toIso8601String(),
      'peso_mascota': pesoMascota,
    };
  }

  factory Vacuna.fromMap(Map<String, dynamic> map) {
    return Vacuna(
      id: map['id']?.toString(),
      idMascota: map['id_mascota'],
      nombreVacuna: map['nombre_vacuna'],
      fechaAplicacion: DateTime.parse(map['fecha_aplicacion']),
      fechaProximaDosis: DateTime.parse(map['fecha_proxima_dosis']),
      pesoMascota: (map['peso_mascota'] as num).toDouble(),
    );
  }
}
