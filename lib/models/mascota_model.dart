class Mascota {
  final String? id;
  final String nombre;
  final String especie;
  final String raza;
  final String color;
  final String sexo;
  final DateTime fechaNacimiento;
  final String? imagen_url;
  final String idPropietario;
  final String? qrData;

  Mascota({
    this.id,
    required this.nombre,
    required this.especie,
    required this.raza,
    required this.color,
    required this.sexo,
    required this.fechaNacimiento,
    this.imagen_url,
    required this.idPropietario,
        this.qrData,

  });

  Mascota copyWith({
    String? imagen_url,
  }) {
    return Mascota(
      id: id,
      nombre: nombre,
      especie: especie,
      raza: raza,
      color: color,
      sexo: sexo,
      fechaNacimiento: fechaNacimiento,
      imagen_url: imagen_url ?? this.imagen_url,
      idPropietario: idPropietario,
      qrData: qrData ?? this.qrData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'especie': especie,
      'raza': raza,
      'color': color,
      'sexo': sexo,
      'fecha_nacimiento': fechaNacimiento.toIso8601String(),
      'imagen_url': imagen_url,
      'id_propietario': idPropietario,
      'qr_data': qrData,
    };
  }

  factory Mascota.fromMap(Map<String, dynamic> map) {
    return Mascota(
      id: map['id']?.toString(),
      nombre: map['nombre'] ?? '',
      especie: map['especie'] ?? '',
      raza: map['raza'] ?? '',
      color: map['color'] ?? '',
      sexo: map['sexo'] ?? '',
      fechaNacimiento: DateTime.parse(map['fecha_nacimiento']),
      imagen_url: map['imagen_url'],
      idPropietario: map['id_propietario'] ?? '',
      qrData: map['qr_data'],
    );
  }
}
