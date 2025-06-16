import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooland/viewmodels/usuario_viewmodel.dart';

class AjustesPage extends StatefulWidget {
  const AjustesPage({super.key});

  @override
  State<AjustesPage> createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  void _confirmarCerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Cierra el diálogo

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada correctamente'),
                  duration: Duration(seconds: 2),
                ),
              );

              await Future.delayed(const Duration(milliseconds: 800));

              // Aquí llamamos cerrarSesion pasando el contexto
              await Provider.of<UsuarioViewModel>(context, listen: false).cerrarSesion(context);
            },
            child: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Al presionar botón físico atrás, navegamos igual que el appbar:
        Navigator.pushReplacementNamed(context, '/menu');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Ajustes', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/menu');
            },
          ),
        ),
        body: ListView(
          children: [
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Cuenta",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.teal),
              title: const Text('Editar perfil'),
              onTap: () {
                // TODO: Navegar a edición de perfil
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock, color: Colors.teal),
              title: const Text('Cambiar contraseña'),
              onTap: () {
                // TODO: Navegar a cambio de contraseña
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.teal),
              title: const Text('Cerrar sesión'),
              onTap: () => _confirmarCerrarSesion(context),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
