import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // Método para registrar un nuevo usuario
  Future<void> registrarUsuario(String email, String password) async {
    try {
      await _client.auth.signUp(email: email, password: password);
    } on AuthException catch (e) {
      // Supabase lanza AuthException en errores de auth
      throw Exception('Error al registrar: ${e.message}');
    } catch (e) {
      // Cualquier otro error inesperado
      throw Exception('Error inesperado al registrar: $e');
    }
  }

  // Método para iniciar sesión
  Future<void> iniciarSesion(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      // Supabase lanza AuthException en errores de auth
      throw Exception('Error al iniciar sesión: ${e.message}');
    } catch (e) {
      // Cualquier otro error inesperado
      print(e); // Esto te ayudará a obtener más información sobre el error
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }

  // Obtener el ID del usuario autenticado
  String? obtenerIdUsuario() {
    return _client.auth.currentUser?.id;
  }
Future<void> eliminarUsuarioActual() async {
  final user = _client.auth.currentUser;
  if (user != null) {
    await _client.auth.admin.deleteUser(user.id);
  }
}

  // Método para cerrar sesión
  Future<void> cerrarSesion() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }
}
