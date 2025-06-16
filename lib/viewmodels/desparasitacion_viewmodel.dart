import 'package:flutter/material.dart';
import 'package:zooland/models/desparasitacion_model.dart';
import 'package:zooland/services/desparasitacion_service.dart';

class DesparasitacionViewModel extends ChangeNotifier {
  final DesparasitacionService _service = DesparasitacionService();

  String? productoDesparasitante;
  DateTime? fechaDosis;
  DateTime? proximaDosis;
  double? pesoMascota;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setProducto(String value) {
    productoDesparasitante = value;
    notifyListeners();
  }

  void setFechaDosis(DateTime value) {
    fechaDosis = value;
    notifyListeners();
  }

  void setProximaDosis(DateTime value) {
    proximaDosis = value;
    notifyListeners();
  }

  void setPeso(String value) {
    pesoMascota = double.tryParse(value);
    notifyListeners();
  }

  Future<bool> registrar(String idMascota) async {
    if (productoDesparasitante == null ||
        fechaDosis == null ||
        proximaDosis == null ||
        pesoMascota == null) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    final des = Desparasitacion(
      idMascota: idMascota,
      productoDesparasitante: productoDesparasitante!,
      fechaDosis: fechaDosis!,
      proximaDosis: proximaDosis!,
      pesoMascota: pesoMascota!,
    );

    final resultado = await _service.registrarDesparasitacion(des);

    _isLoading = false;
    notifyListeners();

    return resultado;
  }

  void limpiar() {
    productoDesparasitante = null;
    fechaDosis = null;
    proximaDosis = null;
    pesoMascota = null;
    notifyListeners();
  }
}
