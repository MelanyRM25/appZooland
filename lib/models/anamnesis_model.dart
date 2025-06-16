import 'package:flutter/foundation.dart';

class Anamnesis {
  final String idAnamnesis;
  final String idMascota;
  final String sintomas;
  final String? intervencionesPrevias;
  final String? enfermedadesPrevias;
  final String? preDiagnostico;
  final DateTime fechaRegistro;

  Anamnesis({
    required this.idAnamnesis,
    required this.idMascota,
    required this.sintomas,
    this.intervencionesPrevias,
    this.enfermedadesPrevias,
    this.preDiagnostico,
    required this.fechaRegistro,
  });

  factory Anamnesis.fromMap(Map<String, dynamic> map) {
    return Anamnesis(
      idAnamnesis: map['id_anamnesis'],
      idMascota: map['id_mascota'],
      sintomas: map['sintomas'],
      intervencionesPrevias: map['intervenciones_previas'],
      enfermedadesPrevias: map['enfermedades_previas'],
      preDiagnostico: map['pre_diagnostico'],
      fechaRegistro: DateTime.parse(map['fecha_registro']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_anamnesis': idAnamnesis,
      'id_mascota': idMascota,
      'sintomas': sintomas,
      'intervenciones_previas': intervencionesPrevias,
      'enfermedades_previas': enfermedadesPrevias,
      'pre_diagnostico': preDiagnostico,
      'fecha_registro': fechaRegistro.toIso8601String(),
    };
  }
}
