import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/vacuna_model.dart';

class VacunaService {
  final supabase = Supabase.instance.client;
Future<void> crearRecordatorios({
  required String idMascota,
  required String tipo, // 'vacuna' o 'desparasitacion'
  required DateTime fechaEvento,
}) async {
  final fechasRecordatorio = [
    fechaEvento.subtract(Duration(days: 7)), // 1 semana antes
    fechaEvento.subtract(Duration(days: 1)), // 1 día antes
  ];

  for (final fecha in fechasRecordatorio) {
    await Supabase.instance.client.from('recordatorios').insert({
      'id_mascota': idMascota,
      'tipo': tipo,
      'fecha_evento': fecha.toIso8601String().split('T')[0], // solo fecha
    });
  }
}

  Future<bool> registrarVacuna(Vacuna vacuna) async {
    try {
      final response = await supabase.from('vacunas').insert(vacuna.toMap());
      return true;
    } catch (e) {
      print('Error al registrar vacuna: $e');
      return false;
    }
  }

  Future<List<Vacuna>> obtenerHistorial(String idMascota) async {
    try {
      final response = await supabase
          .from('vacunas')
          .select()
          .eq('id_mascota', idMascota)
          .order('fecha_aplicacion', ascending: false);
      return (response as List).map((map) => Vacuna.fromMap(map)).toList();
    } catch (e) {
      print('Error obteniendo historial vacunas: $e');
      return [];
    }
  }
    Future<List<Vacuna>> obtenerVacunasPorMascota(String idMascota) async {
    final response = await supabase
        .from('vacunas')
        .select()
        .eq('id_mascota', idMascota)
        .order('fecha_aplicacion', ascending: false);

    return (response as List)
        .map((item) => Vacuna.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
