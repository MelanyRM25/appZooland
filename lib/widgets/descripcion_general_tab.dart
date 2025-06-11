import 'package:flutter/material.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/models/propietario_model.dart';

class DescripcionGeneralTab extends StatelessWidget {
  final Mascota mascota;
  final Propietario propietario;

  const DescripcionGeneralTab({
    Key? key,
    required this.mascota,
    required this.propietario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Datos de la Mascota",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text("Nombre: ${mascota.nombre}"),
          Text("Especie: ${mascota.especie}"),
          Text("Raza: ${mascota.raza}"),
          Text("Color: ${mascota.color}"),
          Text("Sexo: ${mascota.sexo}"),
          Text("Fecha Nacimiento: ${mascota.fechaNacimiento}"),
          const Divider(height: 32),
          Text(
            "Datos del Propietario",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text("Nombre: ${propietario.nombre} ${propietario.apellidoPaterno} ${propietario.apellidoMaterno}"),
          Text("Dirección: ${propietario.direccion}"),
          Text("Celular: ${propietario.celular}"),
          Text("Referencia: ${propietario.referencia}"),
        ],
      ),
    );
  }
}
