import 'package:flutter/material.dart';
import 'package:zooland/routes/app_rutas.dart';
import 'package:zooland/views/admin/ajustes_page.dart';
import 'package:zooland/views/admin/menu_page.dart';
import 'package:zooland/views/admin/usuarios_page.dart';
import 'package:zooland/widgets/botonQR.dart';
import 'package:zooland/widgets/navbar.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  final List<Widget> _pages = [
  MenuPage(),         // index 0
  Center(child: Text('Buscar')),         // index 1
  UsuariosPage(),                        // index 2 ← Aquí va la pantalla de usuario
  AjustesPage(),                         // index 3
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      
      floatingActionButton: selectedIndex == 0
    ?  BotonQR(
        imagePath: 'assets/images/qr.png',
        onPressed: () {
          Navigator.pushReplacementNamed(context, AppRutas.veterinario);
        },
      )
      :null,
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
