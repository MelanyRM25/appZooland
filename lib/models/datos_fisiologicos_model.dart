class DatosFisiologicos {
  final String id; // uuid generado en BD, puede ser null al crear
  final String idMascota;
  final double peso;
  final double temperatura;
  final int frecuenciaCardiaca;
  final int frecuenciaRespiratoria;
  final double tiempoRellenoCapilar;
  final DateTime fechaRegistro;

  DatosFisiologicos({
    this.id = '',
    required this.idMascota,
    required this.peso,
    required this.temperatura,
    required this.frecuenciaCardiaca,
    required this.frecuenciaRespiratoria,
    required this.tiempoRellenoCapilar,
    required this.fechaRegistro,
  });

  Map<String, dynamic> toMap() {
    return {
      'id_mascota': idMascota,
      'peso': peso,
      'temperatura': temperatura,
      'frecuencia_cardiaca': frecuenciaCardiaca,
      'frecuencia_respiratoria': frecuenciaRespiratoria,
      'tiempo_relleno_capilar': tiempoRellenoCapilar,
      'fecha_registro': fechaRegistro.toIso8601String(),
    };
  }
}
