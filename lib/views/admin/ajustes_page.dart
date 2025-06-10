import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooland/viewmodels/usuario_viewmodel.dart';
import 'package:zooland/widgets/boton_icono.dart';

class AjustesPage extends StatelessWidget {
  const AjustesPage({super.key});

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

              // Mostrar mensaje de cierre antes de redirigir
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Sesión cerrada correctamente'),
                  duration: Duration(seconds: 2),
                ),
              );

              // Espera un momento para mostrar el mensaje antes de cerrar sesión
              await Future.delayed(const Duration(milliseconds: 800));

              // Ejecutar cierre de sesión
              await Provider.of<UsuarioViewModel>(context, listen: false)
                  .cerrarSesion(context);
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF04A5D5),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 5.0),
          child: BotonIcono(
            onPressed: () => Navigator.pop(context),
            icon: Icons.arrow_back,
            iconColor: Colors.white,
            iconSize: 26.0,
          ),
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
                color: Color(0xFF04A5D5),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xFF04A5D5)),
            title: const Text('Editar perfil'),
            onTap: () {
              // TODO: Navegar a edición de perfil
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: Color(0xFF04A5D5)),
            title: const Text('Cambiar contraseña'),
            onTap: () {
              // TODO: Navegar a cambio de contraseña
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFF21A0C7)),
            title: const Text('Cerrar sesión'),
            onTap: () => _confirmarCerrarSesion(context),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
