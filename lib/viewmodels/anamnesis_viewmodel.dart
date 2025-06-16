import 'package:flutter/material.dart';
import 'package:zooland/services/anamnesis_service.dart';

class AnamnesisViewModel extends ChangeNotifier {
  final AnamnesisService _service = AnamnesisService();

  String? sintomas;
  String? intervencionesPrevias;
  String? enfermedadesPrevias;
  String? preDiagnostico;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> registrarAnamnesis(String idMascota) async {
    if (sintomas == null || sintomas!.isEmpty) return false;

    _isLoading = true;
    notifyListeners();

    final success = await _service.registrarAnamnesis(
      idMascota: idMascota,
      sintomas: sintomas!,
      intervencionesPrevias: intervencionesPrevias,
      enfermedadesPrevias: enfermedadesPrevias,
      preDiagnostico: preDiagnostico,
    );

    _isLoading = false;
    notifyListeners();

    return success;
  }

  void setSintomas(String value) {
    sintomas = value;
    notifyListeners();
  }

  void setIntervencionesPrevias(String value) {
    intervencionesPrevias = value;
    notifyListeners();
  }

  void setEnfermedadesPrevias(String value) {
    enfermedadesPrevias = value;
    notifyListeners();
  }

  void setPreDiagnostico(String value) {
    preDiagnostico = value;
    notifyListeners();
  }

  void limpiarFormulario() {
    sintomas = null;
    intervencionesPrevias = null;
    enfermedadesPrevias = null;
    preDiagnostico = null;
    notifyListeners();
  }
}
