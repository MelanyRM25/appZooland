import 'package:supabase_flutter/supabase_flutter.dart';

class AnamnesisService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> registrarAnamnesis({
    required String idMascota,
    required String sintomas,
    String? intervencionesPrevias,
    String? enfermedadesPrevias,
    String? preDiagnostico,
  }) async {
    try {
      await _supabase.from('anamnesis').insert({
        'id_mascota': idMascota,
        'sintomas': sintomas,
        'intervenciones_previas': intervencionesPrevias,
        'enfermedades_previas': enfermedadesPrevias,
        'pre_diagnostico': preDiagnostico,
        'fecha_registro': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error al registrar anamnesis: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> obtenerHistorial(String idMascota) async {
    try {
      final response = await _supabase
          .from('anamnesis')
          .select()
          .eq('id_mascota', idMascota)
          .order('fecha_registro', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error obteniendo historial anamnesis: $e');
      return [];
    }
  }
}
