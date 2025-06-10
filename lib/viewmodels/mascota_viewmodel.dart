import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/services/mascota_service.dart';

class MascotaViewModel extends ChangeNotifier {
  final MascotaService _mascotaService = MascotaService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _mascotaId;
  String? get mascotaId => _mascotaId;

  /// Registrar mascota con imagen
  Future<void> registrarMascotaConImagen({
    required Mascota mascota,
    required File imagen,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Subir la imagen
      final urlImagen = await _mascotaService.subirImagen(imagen, mascota.nombre);

      // Crear nuevo objeto con URL de imagen
      final mascotaConImagen = mascota.copyWith(imagen_url: urlImagen);

      // Insertar mascota
      final id = await _mascotaService.insertarMascota(mascotaConImagen);
      _mascotaId = id;
    } catch (e) {
      _error = 'Error al registrar mascota: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limpiarEstado() {
    _isLoading = false;
    _error = null;
    _mascotaId = null;
    notifyListeners();
  }

  List<Mascota> _listaMascotas = [];
List<Mascota> get listaMascotas => _listaMascotas;

Future<void> cargarMascotas() async {
  _isLoading = true;
  notifyListeners();
  try {
    _listaMascotas = await _mascotaService.obtenerMascotas();
  } catch (e) {
    _error = 'Error al cargar mascotas: $e';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
Future<Mascota?> obtenerMascotaPorId(String id) async {
  try {
    return await _mascotaService.obtenerMascotaPorId(id);
  } catch (e) {
    _error = 'Error al obtener la mascota: $e';
    notifyListeners();
    return null;
  }
}
// En MascotaViewModel
Future<void> guardarQrEnBase(String mascotaId, String qrData) async {
  _isLoading = true;
  notifyListeners();

  try {
    await _mascotaService.actualizarQrData(mascotaId, qrData);
  } catch (e) {
    _error = 'Error al guardar QR en DB: $e';
    rethrow; // para que la UI también lo vea si hace await
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}




}
