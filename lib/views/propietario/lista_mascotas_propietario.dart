import 'package:flutter/material.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/routes/app_rutas.dart';

class ListaMascotasPropietarioPage extends StatelessWidget {
  final List<Mascota> mascotas;

  const ListaMascotasPropietarioPage({super.key, required this.mascotas});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tus Mascotas')),
      body: ListView.builder(
        itemCount: mascotas.length,
        itemBuilder: (context, index) {
          final mascota = mascotas[index];
          return Card(
            child: ListTile(
              leading: mascota.imagen_url != null
                  ? CircleAvatar(backgroundImage: NetworkImage(mascota.imagen_url !))
                  : const CircleAvatar(child: Icon(Icons.pets)),
              title: Text(mascota.nombre),
              subtitle: Text('Especie: ${mascota.especie}'),
onTap: () {
                  Navigator.pushNamed(context, AppRutas.mascota_propietario, arguments: mascota);

}
            ),
          );
        },
      ),
    );
  }
}
