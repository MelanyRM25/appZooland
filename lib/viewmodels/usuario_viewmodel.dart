import 'package:flutter/material.dart';
import 'package:zooland/models/usuario_model.dart';
import 'package:zooland/routes/app_rutas.dart';
import 'package:zooland/services/usuario_service.dart';

class UsuarioViewModel extends ChangeNotifier {
  final UsuarioService _service = UsuarioService();

  List<UserModel> _usuarios = [];
  List<Map<String, dynamic>> _roles = [];
  bool _cargando = false;
  String? _error;

  List<UserModel> get usuarios => _usuarios;
  List<Map<String, dynamic>> get roles => _roles;

  bool get cargando => _cargando;
  String? get error => _error;

  /// Carga los usuarios
  Future<void> readUsuarios() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _usuarios = await _service.readUsuarios();
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }
 Future<void> cerrarSesion(BuildContext context) async {
  await _service.cerrarSesion();

  // Navega a la página tipo_usuario eliminando historial para que no pueda regresar atrás
  Navigator.pushNamedAndRemoveUntil(
    context,
    '/tipo_usuario',
    (Route<dynamic> route) => false,
  );
}

  /// Crea un nuevo usuario
  Future<void> createUsuario(UserModel usuario) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _service.createUsuario(usuario);
      await readUsuarios();
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Actualiza un usuario existente
  Future<void> updateUsuario(UserModel usuario) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _service.updateUsuario(usuario);
      await readUsuarios();
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Elimina un usuario por ID
  Future<void> deleteUsuario(String id) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _service.deleteUsuario(id);
      await readUsuarios();
    } catch (e) {
      _error = e.toString();
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  /// Carga los roles desde el backend
  Future<void> readRoles() async {
    try {
      _roles = await _service.readRoles(); // Asegúrate de tener este método en tu service
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
  
}
