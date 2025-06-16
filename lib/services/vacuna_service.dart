import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/vacuna_model.dart';

class VacunaService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<bool> registrarVacuna(Vacuna vacuna) async {
    try {
      final response = await _supabase.from('vacunas').insert(vacuna.toMap());
      return true;
    } catch (e) {
      print('Error al registrar vacuna: $e');
      return false;
    }
  }

  Future<List<Vacuna>> obtenerHistorial(String idMascota) async {
    try {
      final response = await _supabase
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
    final response = await _supabase
        .from('vacunas')
        .select()
        .eq('id_mascota', idMascota)
        .order('fecha_aplicacion', ascending: false);

    return (response as List)
        .map((item) => Vacuna.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
