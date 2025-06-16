import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zooland/models/propietario_model.dart';

class PropietarioService {
  final SupabaseClient _client = Supabase.instance.client;

  // Buscar propietario por celular o DNI (lo que uses como campo único)
  Future<Propietario?> buscarPorCelular(String celular) async {
    final response = await _client
        .from('propietarios')
        .select()
        .eq('celular', celular)
        .maybeSingle();

    if (response == null) return null;
    return Propietario.fromMap(response);
  }
  

  // Registrar propietario
  Future<Propietario> registrar(Propietario propietario) async {
    final response = await _client
        .from('propietarios')
        .insert(propietario.toMap())
        .select()
        .single();

    return Propietario.fromMap(response);
  }
Future<Propietario?> obtenerPorId(String id) async {
  final response = await _client
      .from('propietarios')
      .select()
      .eq('id_propietario', id)
      .maybeSingle();

  if (response == null) return null;
  return Propietario.fromMap(response);
}
Future<void> eliminarPropietario(String idPropietario) async {
  await _client
      .from('propietarios')
      .delete()
      .eq('id_propietario', idPropietario);
}
Future<List<Propietario>> obtenerTodos() async {
  final response = await _client.from('propietarios').select();
  return (response as List).map((e) => Propietario.fromMap(e)).toList();
}

}
