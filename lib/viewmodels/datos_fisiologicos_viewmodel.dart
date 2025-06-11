import 'package:flutter/material.dart';
import 'package:zooland/services/datos_fisologicos_service.dart';

class DatosFisiologicosViewModel extends ChangeNotifier {
  final DatosFisiologicosService _service = DatosFisiologicosService();

  // Campos del formulario
  double? peso;
  double? temperatura;
  int? frecuenciaCardiaca;
  int? frecuenciaRespiratoria;
  double? tiempoRellenoCapilar;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Registra los datos fisiológicos en Supabase
  Future<bool> registrarDatos(String idMascota) async {
    // Validación básica
    if (peso == null ||
        temperatura == null ||
        frecuenciaCardiaca == null ||
        frecuenciaRespiratoria == null ||
        tiempoRellenoCapilar == null) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    final success = await _service.registrarDatosFisiologicos(
      idMascota: idMascota,
      peso: peso!,
      temperatura: temperatura!,
      frecuenciaCardiaca: frecuenciaCardiaca!,
      frecuenciaRespiratoria: frecuenciaRespiratoria!,
      tiempoRellenoCapilar: tiempoRellenoCapilar!,
    );

    _isLoading = false;
    notifyListeners();

    return success;
  }

  // Métodos setters para los campos (con parsing)
  void setPeso(String value) {
    peso = double.tryParse(value);
    notifyListeners();
  }

  void setTemperatura(String value) {
    temperatura = double.tryParse(value);
    notifyListeners();
  }

  void setFrecuenciaCardiaca(String value) {
    frecuenciaCardiaca = int.tryParse(value);
    notifyListeners();
  }

  void setFrecuenciaRespiratoria(String value) {
    frecuenciaRespiratoria = int.tryParse(value);
    notifyListeners();
  }

  void setTiempoRellenoCapilar(String value) {
    tiempoRellenoCapilar = double.tryParse(value);
    notifyListeners();
  }

  /// Limpia los campos del formulario (opcional)
  void limpiarFormulario() {
    peso = null;
    temperatura = null;
    frecuenciaCardiaca = null;
    frecuenciaRespiratoria = null;
    tiempoRellenoCapilar = null;
    notifyListeners();
  }
}
