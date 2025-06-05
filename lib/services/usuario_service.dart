import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zooland/models/usuario_model.dart';

class UsuarioService {
  final SupabaseClient _client = Supabase.instance.client;


  Future<void> registrarPerfilUsuario(UserModel nuevoUsuario) async {
    try {
      // Al usar .select().single() devolvemos el registro insertado directamente.
      await _client
          .from('usuarios_perfil')
          .insert(nuevoUsuario.toMap());
     
    } on PostgrestException catch (e) {
      // Este es el error que lanza la librería si algo sale mal
      throw Exception('Error al registrar perfil de usuario: ${e.message}');
    } catch (e) {
      // Cualquier otro error inesperado
      throw Exception('Error inesperado al registrar perfil de usuario: $e');
    }
  }

  // Verificar si un correo ya está registrado
  Future<bool> verificarCorreoExistente(String email) async {
    try {
      // .maybeSingle() no lanza excepciones si no encuentra filas
      final Map<String, dynamic>? fila =
          await _client
              .from('usuarios_perfil') // Tabla
              .select('correo_electronico') // Campo a seleccionar
              .eq('correo_electronico', email) // Filtro
              .maybeSingle(); // Devuelve Map o null

      // Depuración opcional
      print('Resultado verificarCorreoExistente: $fila');

      // Si fila es distinto de null, el correo existe
      return fila != null;
    } catch (e) {
      // Captura cualquier otro error (red, sintaxis, etc.)
      print('Error al verificar el correo: $e');
      throw Exception('No se pudo verificar el correo: $e');
    }
  }

  // Obtener el perfil del usuario por UUID
  Future<UserModel?> obtenerPerfilUsuario(String id) async {
    try {
      final datos =
          await _client.from('usuarios_perfil').select().eq('id', id).single();

      return UserModel.fromMap(datos);
    } on PostgrestException catch (e) {
      throw Exception('Error al obtener perfil de usuario: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al obtener perfil de usuario: $e');
    }
  }
    Future<void> cerrarSesion() async {
    await _client.auth.signOut();
  }
//CRUD 

  // Crear un usuario
  Future<void> createUsuario(UserModel usuario) async {
    try {
      await _client
        .from('usuarios')
        .insert([usuario.toMap()]);
      // Si hay un error, supabase-librería lanzará PostgrestException
    } on PostgrestException catch (e) {
      throw Exception('Error al crear usuario: ${e.message}');
    } catch (e) {
      throw Exception('Error al crear usuario: $e');
    }
  }

  // Obtener todos los usuarios
  Future<List<UserModel>> readUsuarios() async {
    try {
      final data = await _client
        .from('usuarios_perfil')
        .select('id, nombre_usuario,apellido_paterno,apellido_materno,correo_electronico,id_rol, roles(nombre_rol)');    
                 // devuelve List<Map<String, dynamic>>
      return (data as List)
        .map((m) => UserModel.fromMap(m))
        .toList();
    } on PostgrestException catch (e) {
      throw Exception('Error al obtener usuarios: ${e.message}');
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  // Obtener un usuario por su ID
  Future<UserModel> obtenerUsuarioPorId(String id) async {
    try {
      final m = await _client
        .from('usuarios_perfil')
        .select()
        .eq('id', id)
        .single();            // devuelve Map<String, dynamic>
      return UserModel.fromMap(m);
    } on PostgrestException catch (e) {
      throw Exception('Error al obtener usuario por ID: ${e.message}');
    } catch (e) {
      throw Exception('Error al obtener usuario por ID: $e');
    }
  }

  // Actualizar usuario
  Future<void> updateUsuario(UserModel usuario) async {
    try {
      await _client
        .from('usuarios_perfil')
        .update(usuario.toMap())
        .eq('id', usuario.id);
    } on PostgrestException catch (e) {
      throw Exception('Error al actualizar usuario: ${e.message}');
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  // Eliminar usuario
  Future<void> deleteUsuario(String id) async {
    try {
      await _client
        .from('usuarios_perfil')
        .delete()
        .eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Error al eliminar usuario: ${e.message}');
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }
//roles
Future<List<Map<String, dynamic>>> readRoles() async {
  try {
    final data = await _client
        .from('roles')
        .select('id_rol, nombre_rol');
    return List<Map<String, dynamic>>.from(data);
  } on PostgrestException catch (e) {
    throw Exception('Error al obtener roles: ${e.message}');
  } catch (e) {
    throw Exception('Error inesperado al obtener roles: $e');
  }
}


}



