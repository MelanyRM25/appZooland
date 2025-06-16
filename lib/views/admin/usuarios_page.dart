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
  TextEditingController _searchController = TextEditingController();
  String _filtro = '';

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<UsuarioViewModel>(context, listen: false);
    viewModel.readUsuarios();

    _searchController.addListener(() {
      setState(() {
        _filtro = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // 🧩 Diálogo de confirmación para eliminar usuario
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

    // Filtrar usuarios por nombre o rol
    final usuariosFiltrados = usuarioViewModel.usuarios.where((usuario) {
      final nombreCompleto = '${usuario.nombreUsuario} ${usuario.apellidoPaterno} ${usuario.apellidoMaterno}'.toLowerCase();
      final rol = (usuario.nombreRol ?? '').toLowerCase();
      return nombreCompleto.contains(_filtro) || rol.contains(_filtro);
    }).toList();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/menu');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Gestión de Usuarios', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/menu');
            },
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre o rol...',
                  hintStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.teal,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
        ),
        body: usuarioViewModel.cargando
            ? const Center(child: CircularProgressIndicator())
            : usuarioViewModel.error != null
                ? Center(child: Text('Error: ${usuarioViewModel.error}'))
                : usuariosFiltrados.isEmpty
                    ? const Center(
                        child: Text(
                          'No se encontraron usuarios.',
                          style: TextStyle(color: Colors.teal),
                        ),
                      )
                    : ListView.builder(
                        itemCount: usuariosFiltrados.length,
                        itemBuilder: (context, index) {
                          final usuario = usuariosFiltrados[index];

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
                                          builder: (context) => EditarUsuarioPage(usuario: usuario),
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
      ),
    );
  }
}
