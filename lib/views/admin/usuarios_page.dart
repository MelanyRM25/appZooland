import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooland/viewmodels/usuario_viewmodel.dart';
import 'package:zooland/views/admin/editar_usuario_page.dart';
import 'package:zooland/widgets/boton_icono.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<UsuarioViewModel>(context, listen: false);
    viewModel.readUsuarios();
  }

  // 🧩 Diálogo de confirmación
  void mostrarDialogoEliminarUsuario(BuildContext context, String usuarioId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("¿Eliminar usuario?"),
          content: const Text(
            "¿Estás seguro de que deseas eliminar este usuario? Esta acción no se puede deshacer.",
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Eliminar",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Provider.of<UsuarioViewModel>(
                  context,
                  listen: false,
                ).deleteUsuario(usuarioId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuarioViewModel = Provider.of<UsuarioViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión de Usuarios',
          style: TextStyle(color: Colors.white),
        ),
                centerTitle: true,

        backgroundColor: const Color(
          0xFF04A5D5
        ),
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
      body:
      
          usuarioViewModel.cargando
              ? const Center(child: CircularProgressIndicator())
              : usuarioViewModel.error != null
              ? Center(child: Text('Error: ${usuarioViewModel.error}'))
              : ListView.builder(
                itemCount: usuarioViewModel.usuarios.length,
                itemBuilder: (context, index) {
                  final usuario = usuarioViewModel.usuarios[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        '${usuario.nombreUsuario} ${usuario.apellidoPaterno} ${usuario.apellidoMaterno}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(
                        usuario.nombreRol ?? 'Sin rol',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: Wrap(
                        spacing: 8,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.lightBlue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          EditarUsuarioPage(usuario: usuario),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () {
                              mostrarDialogoEliminarUsuario(
                                context,
                                usuario.id,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
