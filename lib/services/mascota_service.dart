import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:zooland/models/mascota_model.dart';

class MascotaService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Inserta una mascota y devuelve su ID generado.
 /// Inserta una mascota con ID y qrData generado automáticamente
Future<String> insertarMascota(Mascota mascota) async {
  final uuid = const Uuid().v4();

  final mascotaFinal = mascota.copyWith(
    id: uuid,
    qrData: 'mascota/$uuid', // Puedes cambiar esto por una URL completa si deseas
  );

  final result = await _client
      .from('mascotas')
      .insert(mascotaFinal.toMap())
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
  Future<List<Mascota>> obtenerMascotasConPropietario() async {
  final response = await _client
      .from('mascotas')
      .select('*, propietarios(nombre,apellido_paterno)');

  final mascotas = (response as List).map((mapa) {
    final mascotaMap = Map<String, dynamic>.from(mapa);
    final propietario = mapa['propietarios'];

     mascotaMap['nombre_propietario'] = propietario?['nombre'] ?? '';
    mascotaMap['apellido_propietario'] = propietario?['apellido_paterno'] ?? '';

    return Mascota.fromMap(mascotaMap);
  }).toList();

  return mascotas;
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

/// Actualiza únicamente el contenido del QR para la mascota dada
// En MascotaService
Future<void> actualizarQrData(String idMascota, String qrData) async {
  final response = await _client
    .from('mascotas')
    .update({'qr_data': qrData})
    .eq('id', idMascota)
    .select()
    .single();  // Trae de vuelta el registro actualizado

  if (response == null || response['qr_data'] != qrData) {
    throw Exception('No se actualizó qr_data correctamente');
  }
}
Future<List<Mascota>> obtenerMascotasPorPropietario(String idPropietario) async {
  final response = await _client
      .from('mascotas')
      .select()
      .eq('id_propietario', idPropietario);

  return (response as List).map((e) => Mascota.fromMap(e)).toList();
}


}


