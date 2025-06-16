import 'package:flutter/material.dart';
import 'package:zooland/services/vacuna_Service.dart';
import '../models/vacuna_model.dart';

class VacunaViewModel extends ChangeNotifier {
  final VacunaService _service = VacunaService();

  // Campos del formulario
  String? nombreVacuna;
  DateTime? fechaAplicacion;
  DateTime? fechaProximaDosis;
  double? pesoMascota;

  // Estado de carga
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Lista completa de vacunas
  List<Vacuna> _vacunas = [];
  List<Vacuna> get vacunas => _vacunas;

  // Listas filtradas
  List<Vacuna> get vacunasAplicadas {
    final ahora = DateTime.now();
    return _vacunas.where((v) => v.fechaAplicacion.isBefore(ahora)).toList();
  }

  List<Vacuna> get vacunasProximas {
    final ahora = DateTime.now();
    return _vacunas.where((v) => v.fechaAplicacion.isAfter(ahora)).toList();
  }

  // Setters del formulario
  void setNombreVacuna(String value) {
    nombreVacuna = value;
    notifyListeners();
  }

  void setFechaAplicacion(DateTime date) {
    fechaAplicacion = date;
    notifyListeners();
  }

  void setFechaProximaDosis(DateTime date) {
    fechaProximaDosis = date;
    notifyListeners();
  }

  void setPesoMascota(String value) {
    pesoMascota = double.tryParse(value);
    notifyListeners();
  }

  /// ✅ Obtener todas las vacunas por mascota
  Future<void> cargarVacunas(String idMascota) async {
    _isLoading = true;
    notifyListeners();

    try {
      final lista = await _service.obtenerVacunasPorMascota(idMascota);
      _vacunas = lista;
    } catch (e) {
      print("❌ Error al obtener vacunas: $e");
      _vacunas = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Registrar nueva vacuna
  Future<bool> registrarVacuna(String idMascota) async {
    if (nombreVacuna == null ||
        fechaAplicacion == null ||
        fechaProximaDosis == null ||
        pesoMascota == null) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    final vacuna = Vacuna(
      idMascota: idMascota,
      nombreVacuna: nombreVacuna!,
      fechaAplicacion: fechaAplicacion!,
      fechaProximaDosis: fechaProximaDosis!,
      pesoMascota: pesoMascota!,
    );

    final success = await _service.registrarVacuna(vacuna);

    if (success) {
      await cargarVacunas(idMascota); // Recargar lista
    }

    _isLoading = false;
    notifyListeners();

    return success;
  }

  void limpiarFormulario() {
    nombreVacuna = null;
    fechaAplicacion = null;
    fechaProximaDosis = null;
    pesoMascota = null;
    notifyListeners();
  }
}
