import 'package:flutter/material.dart';
import 'package:zooland/services/auth_service.dart';
import 'package:zooland/services/usuario_service.dart';
import 'package:zooland/models/usuario_model.dart';

class AuthViewModel extends ChangeNotifier {
  // Instanciamos los servicios
  final AuthService _authService = AuthService();
  final UsuarioService _usuarioService = UsuarioService();
  

  bool _cargando = false;
  bool get cargando => _cargando;

  UserModel? _usuario;
  UserModel? get usuario => _usuario; // Getter para acceder al usuario actual

  // Método para registrar al usuario
  
Future<void> registrarUsuario(
  String nombre,
  String apellidoPaterno,
  String apellidoMaterno,
  String correo,
  String password,
) async {
  _cargando = true;
  notifyListeners();

  try {
    // Verificar si el correo ya está registrado
    final correoExistente = await _usuarioService.verificarCorreoExistente(correo);
    if (correoExistente) {
      throw Exception("El correo electrónico ya está registrado.");
    }

    // Registrar el usuario en Auth y obtener el ID
    await _authService.registrarUsuario(correo, password);
    String? idUsuario = _authService.obtenerIdUsuario();

    if (idUsuario == null) {
      throw Exception("No se pudo obtener el ID del usuario luego del registro.");
    }

    // Crear el objeto UserModel con el ID del usuario obtenido
    final nuevoUsuario = UserModel(
      id: idUsuario,
      nombreUsuario: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      correoElectronico: correo,
      idRol: 3, // Rol por defecto
    );

    // Registrar el perfil del usuario en la base de datos
    await _usuarioService.registrarPerfilUsuario(nuevoUsuario);

    // Guardar en memoria el usuario registrado
    _usuario = nuevoUsuario;

  } catch (e) {
    debugPrint("Error en el registro: $e");
    rethrow; // Propagamos la excepción para que la UI pueda capturarla
  } finally {
    _cargando = false;
    notifyListeners();
  }
}



  // Método para iniciar sesión y obtener los datos del perfil del usuario
  Future<void> iniciarSesion(String email, String password) async {
    _cargando = true;
    notifyListeners();

    try {
      // Iniciar sesión
      await _authService.iniciarSesion(email, password);

      // Después de iniciar sesión, obtener el perfil del usuario
      final idUsuario = _authService.obtenerIdUsuario();
      if (idUsuario == null) {
        throw Exception("No se encontró el ID del usuario tras el login.");
      }

      // Cargar perfil desde la base de datos
      _usuario = await _usuarioService.obtenerPerfilUsuario(idUsuario);
    } catch (e) {
      debugPrint("Error en iniciarSesion: $e");
      rethrow;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  // // Método para cargar los datos del usuario actual
  // Future<void> cargarUsuarioActual() async {
  //   try {
  //     final idUsuario = _authService.obtenerIdUsuario();
  //     if (idUsuario != null) {
  //       _usuario = await _usuarioService.obtenerPerfilUsuario(idUsuario);
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     debugPrint("Error al cargar usuario actual: $e");
  //   }
  // }

  // // Método para cerrar sesión
  // Future<void> cerrarSesion() async {
  //   try {
  //     await _authService.cerrarSesion();
  //     _usuario = null; // Limpiar el usuario de memoria al cerrar sesión
  //     notifyListeners();
  //   } catch (e) {
  //     debugPrint("Error al cerrar sesión: $e");
  //   }
  // }
}
