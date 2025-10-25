import 'package:flutter/foundation.dart';
import 'package:zooland/models/mascota_medico_model.dart';
import '../services/mascota_medico_service.dart';

class MascotaMedicoViewModel extends ChangeNotifier {
  final MascotaMedicoService _service = MascotaMedicoService();

  List<MascotaMedico> _medicos = [];
  List<MascotaMedico> get medicos => _medicos;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  Future<void> cargarMedicos(String idMascota) async {
    try {
      _loading = true;
      notifyListeners();

      _medicos = await _service.obtenerMedicosDeMascota(idMascota);
      _error = null;
    } catch (e) {
      _error = "Error al cargar médicos: $e";
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> asignarMedico(String idMascota, String idMedico) async {
    try {
      await _service.asignarMedico(idMascota, idMedico);
      await cargarMedicos(idMascota); // refrescar lista
    } catch (e) {
      _error = "Error al asignar médico: $e";
      notifyListeners();
    }
  }
}
