import 'package:supabase_flutter/supabase_flutter.dart';

class DatosFisiologicosService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> registrarDatosFisiologicos({
    required String idMascota,
    required double peso,
    required double temperatura,
    required int frecuenciaCardiaca,
    required int frecuenciaRespiratoria,
    required double tiempoRellenoCapilar,
  }) async {
    try {
      final response = await _supabase.from('datos_fisiologicos').insert({
        'id_mascota': idMascota,
        'peso': peso,
        'temperatura': temperatura,
        'frecuencia_cardiaca': frecuenciaCardiaca,
        'frecuencia_respiratoria': frecuenciaRespiratoria,
        'tiempo_relleno_capilar': tiempoRellenoCapilar,
        'fecha_registro': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('Error al registrar datos fisiológicos: $e');
      return false;
    }
  }
  Future<List<Map<String, dynamic>>> obtenerHistorial(String idMascota) async {
  try {
    final response = await _supabase
        .from('datos_fisiologicos')
        .select()
        .eq('id_mascota', idMascota)
        .order('fecha_registro', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  } catch (e) {
    print('Error obteniendo historial: $e');
    return [];
  }
}

}
