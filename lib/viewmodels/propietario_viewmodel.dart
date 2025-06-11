import 'package:flutter/material.dart';
import 'package:zooland/models/propietario_model.dart';
import 'package:zooland/services/propietario_service.dart';

class PropietarioViewModel extends ChangeNotifier {
  final PropietarioService _service = PropietarioService();

  Propietario? _propietario;
  Propietario? get propietario => _propietario;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

Future<void> obtenerPorId(String id) async {
  _isLoading = true;
  _error = null;
  notifyListeners();

  try {
    final data = await _service.obtenerPorId(id);
    print("🧾 Propietario obtenido: $data");
    _propietario = data;
  } catch (e) {
      print("❌ Error al cargar propietario: $e");

    _error = 'Error al cargar propietario: $e';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}



  // Registrar propietario y devolver ID (o null si falla)
  Future<String?> registrarPropietario({
    required String nombre,
    required String apellidoPaterno,
    required String apellidoMaterno,
    required String direccion,
    required String celular,
    required String numReferencia,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final propietario = Propietario(
        nombre: nombre,
        apellidoPaterno: apellidoPaterno,
        apellidoMaterno: apellidoMaterno,
        direccion: direccion,
        celular: celular,
        referencia: numReferencia,
      );

      final registrado = await _service.registrar(propietario);
      _propietario = registrado;
      return registrado.idPropietario;
    } catch (e) {
      _error = 'Error al registrar propietario: $e';
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Propietario?> obtenerPropietarioPorId(String id) async {
  try {
    final data = await _service.obtenerPorId(id);
    _propietario = data;
    notifyListeners();
    return data;
  } catch (e) {
    _error = 'Error al cargar propietario: $e';
    notifyListeners();
    return null;
  }
}

}
