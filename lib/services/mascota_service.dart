import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zooland/models/mascota_model.dart';

class MascotaService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Inserta una mascota y devuelve su ID generado.
  Future<String> insertarMascota(Mascota mascota) async {
    final result = await _client
        .from('mascotas')
        .insert(mascota.toMap())
        .select('id')
        .single();

    return result['id'].toString();
  }

  /// Sube una imagen al bucket 'mascotas' y devuelve la URL pública.
  Future<String> subirImagen(File archivo, String nombreArchivo) async {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final fileName = '$nombreArchivo-$timestamp.jpg';

  try {
    // Subimos la imagen al bucket 'mascotas' directamente
    await _client.storage
        .from('mascotas')
        .upload(fileName, archivo, fileOptions: const FileOptions(upsert: true));

    // Generamos URL pública correctamente (sin duplicar carpeta)
    final url = _client.storage.from('mascotas').getPublicUrl(fileName);

    if (url.isEmpty) {
      throw Exception('Error: no se pudo obtener la URL pública.');
    }

    return url;
  } catch (e) {
    throw Exception('Error al subir imagen: $e');
  }
}


  /// Obtiene todas las mascotas de la tabla 'mascotas'
  Future<List<Mascota>> obtenerMascotas() async {
    try {
      final response = await _client.from('mascotas').select();
      if (response is List) {
        return response.map((mapa) => Mascota.fromMap(mapa)).toList();
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error al obtener mascotas: $e');
    }
  }
  //Obtener mascota por ID 
  Future<Mascota?> obtenerMascotaPorId(String id) async {
  try {
    final data = await _client
        .from('mascotas')
        .select()
        .eq('id', id)
        .single();

    return Mascota.fromMap(data);
  } catch (e) {
    throw Exception('Error al obtener la mascota: $e');
  }
}

}
