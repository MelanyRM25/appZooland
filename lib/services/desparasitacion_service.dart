import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zooland/models/desparasitacion_model.dart';

class DesparasitacionService {
  final supabase = Supabase.instance.client;

  Future<bool> registrarDesparasitacion(Desparasitacion des) async {
    try {
      await supabase.from('desparasitaciones').insert(des.toMap());
      return true;
    } catch (e) {
      print('Error al registrar desparasitación: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> obtenerHistorial(String idMascota) async {
    try {
      final response = await supabase
          .from('desparasitaciones')
          .select()
          .eq('id_mascota', idMascota)
          .order('fecha_dosis', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error al obtener historial: $e');
      return [];
    }
  }
}
