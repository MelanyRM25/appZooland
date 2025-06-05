import 'package:flutter/material.dart';
import 'package:zooland/routes/app_rutas.dart';
import 'package:zooland/widgets/boton_icono.dart';
import 'package:zooland/widgets/cardBoton.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el tamaño de la pantalla
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Pacientes',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF04A5D5),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 5.0),
          child: BotonIcono(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icons.arrow_back,
            iconColor: Colors.white,
            iconSize: 26.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: size.height - kToolbarHeight - 32, // Altura disponible
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: 2, // La cantidad de botones que tengas
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CardButton(
                    texto: 'Registrar Paciente',
                    rutaImagen: 'assets/images/add_pet.png',
                    colorFondo: const Color.fromARGB(150, 115, 128, 246),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRutas.registro_paciente,
                      );
                    },
                  );
                } else {
                  return CardButton(
                    texto: 'Lista de Pacientes',
                    rutaImagen: 'assets/images/list_pet.png',
                    colorFondo: const Color.fromARGB(255, 49, 219, 202),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRutas.lista_paciente,
                      );                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
