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

  // Buscar propietario por celular
  Future<void> buscarPorCelular(String celular) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final resultado = await _service.buscarPorCelular(celular);
      _propietario = resultado;
    } catch (e) {
      _error = 'Error al buscar propietario: $e';
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
}
