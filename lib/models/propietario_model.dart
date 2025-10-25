class Propietario {
  String? idPropietario;
  final String nombre;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String direccion;
  final String celular;
  final String referencia;

  // 🔹 Nuevo campo para token FCM
  final String? fcmToken;

  Propietario({
    this.idPropietario,
    required this.nombre,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
    required this.direccion,
    required this.celular,
    required this.referencia,
    this.fcmToken, // 🔹 opcional
  });

  // Convertir a Map para Supabase
  Map<String, dynamic> toMap() => {
        'nombre': nombre,
        'apellido_paterno': apellidoPaterno,
        'apellido_materno': apellidoMaterno,
        'direccion': direccion,
        'celular': celular,
        'num_referencia': referencia,
        'fcm_token': fcmToken, // 🔹 agregar aquí
      };

  // Crear desde Map de Supabase
  factory Propietario.fromMap(Map<String, dynamic> map) => Propietario(
        idPropietario: map['id_propietario']?.toString(),
        nombre: map['nombre'],
        apellidoPaterno: map['apellido_paterno'],
        apellidoMaterno: map['apellido_materno'],
        direccion: map['direccion'],
        celular: map['celular'],
        referencia: map['num_referencia'],
        fcmToken: map['fcm_token'], // 🔹 asignar token
      );
}
