import 'package:zooland/models/usuario_model.dart';

class MascotaMedico {
  final String id;
  final String idMascota;
  final UserModel medico;
  final DateTime fechaAsignacion;

  MascotaMedico({
    required this.id,
    required this.idMascota,
    required this.medico,
    required this.fechaAsignacion,
  });

  factory MascotaMedico.fromMap(Map<String, dynamic> map) {
    return MascotaMedico(
      id: map['id'].toString(),
      idMascota: map['id_mascota'],
      medico: UserModel.fromMap(map['usuarios']),
      fechaAsignacion: DateTime.parse(map['fecha_asignacion']),
    );
  }
}
