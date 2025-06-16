import 'package:flutter/material.dart';
import 'package:zooland/routes/app_rutas.dart';
import 'package:zooland/widgets/boton_icono.dart';
import 'package:zooland/widgets/cardBoton.dart';
import 'package:zooland/widgets/navbar.dart';
import 'package:zooland/widgets/botonQR.dart'; // Asegúrate de importar esto

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacementNamed(context, AppRutas.lista_paciente);
        break;
      case 2:
        Navigator.pushReplacementNamed(context, AppRutas.usuarios);
        break;
      case 3:
        Navigator.pushReplacementNamed(context, AppRutas.ajustes);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Pacientes',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF04A5D5),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: size.height - kToolbarHeight - 32,
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemCount: 3,
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
                } else if (index == 1) {
                  return CardButton(
                    texto: 'Lista de Pacientes',
                    rutaImagen: 'assets/images/list_pet.png',
                    colorFondo: const Color.fromARGB(255, 49, 219, 202),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRutas.lista_paciente,
                      );
                    },
                  );
                } else {
                  return CardButton(
                    texto: 'Propietarios',
                    rutaImagen: 'assets/images/propietario.png',
                    colorFondo: const Color.fromARGB(255, 241, 196, 15),
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                        context,
                        AppRutas.lista_propietarios,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),

      // ✅ Botón flotante QR
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: BotonQR(
        imagePath: 'assets/images/qr.png',
        onPressed: () {
          Navigator.pushNamed(context, AppRutas.escaner_qr);
        },
      ),

      bottomNavigationBar: Navbar(
        selectedIndex: selectedIndex,
        onItemTap: _onItemTapped,
        items: [
          NavItem(icon: Icons.home, label: 'Inicio'),
          NavItem(icon: Icons.search, label: 'Buscar'),
          NavItem(icon: Icons.group, label: 'Usuarios'),
          NavItem(icon: Icons.settings, label: 'Ajustes'),
        ],
      ),
    );
  }
}
