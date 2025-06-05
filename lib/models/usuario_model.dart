//clase usuario
class UserModel {
  final String id;
  final String nombreUsuario;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String correoElectronico;
  final int idRol;
  final String? nombreRol; // 👈 nuevo campo opcional

  //constructor
  UserModel({
    required this.id,
    required this.nombreUsuario,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.correoElectronico,
    required this.idRol,
    this.nombreRol,
  });
  //metodo toMap conviert un objeto dart a un Map<String, dynamic>
  // convertir un objeto de Dart a una especie de tabla o diccionario clave-valor.
  //CLAVE ES LA COLUMNA DE B SUPABASE Y EL VALOR ES el objeto local dart
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre_usuario': nombreUsuario,
      'apellido_paterno': apellidoPaterno,
      'apellido_materno': apellidoMaterno,
      'correo_electronico': correoElectronico,
      'id_rol': idRol,
    };
  }

  //Metodo constructor de fabrica ,se usa para convertir un Map<String, dynamic> a un objeto dart en una
  //instancia de la clase UsuarioModel
factory UserModel.fromMap(Map<String, dynamic> map) {
  return UserModel(
    id: map['id']?.toString() ?? '',
    nombreUsuario: map['nombre_usuario'] ?? '',
    apellidoPaterno: map['apellido_paterno'] ?? '',
    apellidoMaterno: map['apellido_materno'] ?? '',
    correoElectronico: map['correo_electronico'] ?? '',
    idRol: map['id_rol'] ?? 0,
    nombreRol: map['roles']?['nombre_rol'] as String?,
  );
}
UserModel copyWith({
  String? id,
  String? nombreUsuario,
  String? apellidoPaterno,
  String? apellidoMaterno,
  String? correoElectronico,
  int? idRol,
  String? nombreRol,
}) {
  return UserModel(
    id: id ?? this.id,
    nombreUsuario: nombreUsuario ?? this.nombreUsuario,
    apellidoPaterno: apellidoPaterno ?? this.apellidoPaterno,
    apellidoMaterno: apellidoMaterno ?? this.apellidoMaterno,
    correoElectronico: correoElectronico ?? this.correoElectronico,
    idRol: idRol ?? this.idRol,
    nombreRol: nombreRol ?? this.nombreRol,
  );
}

}
