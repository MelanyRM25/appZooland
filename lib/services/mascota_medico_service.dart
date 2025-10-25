import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zooland/models/mascota_medico_model.dart';

class MascotaMedicoService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<MascotaMedico>> obtenerMedicosDeMascota(String idMascota) async {
    final response = await _client
        .from('mascota_medicos')
        .select('id, id_mascota, fecha_asignacion, usuarios(*)')
        .eq('id_mascota', idMascota);

    return (response as List)
        .map((e) => MascotaMedico.fromMap(e))
        .toList();
  }

  Future<void> asignarMedico(String idMascota, String idMedico) async {
    await _client.from('mascota_medicos').insert({
      'id_mascota': idMascota,
      'id_medico': idMedico,
    });
  }
}
