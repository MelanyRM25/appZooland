class Tratamiento {
  final String id;
  final String idMascota;
  final String nombreTratamiento;
  final DateTime fechaInicio;
  final DateTime? fechaFin;
  final String descripcion;

  Tratamiento({
    required this.id,
    required this.idMascota,
    required this.nombreTratamiento,
    required this.fechaInicio,
    this.fechaFin,
    required this.descripcion,
  });

  factory Tratamiento.fromMap(Map<String, dynamic> map) {
    return Tratamiento(
      id: map['id'],
      idMascota: map['id_mascota'],
      nombreTratamiento: map['nombre_tratamiento'],
      fechaInicio: DateTime.parse(map['fecha_inicio']),
      fechaFin: map['fecha_fin'] != null ? DateTime.parse(map['fecha_fin']) : null,
      descripcion: map['descripcion'],
    );
  }
}
