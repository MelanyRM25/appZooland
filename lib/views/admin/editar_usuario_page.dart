import 'package:flutter/material.dart';
import 'package:zooland/models/usuario_model.dart';
import 'package:provider/provider.dart';
import 'package:zooland/viewmodels/usuario_viewmodel.dart';
import 'package:zooland/widgets/boton.dart';
import 'package:zooland/widgets/boton_icono.dart';

class EditarUsuarioPage extends StatefulWidget {
  final UserModel usuario;

  const EditarUsuarioPage({Key? key, required this.usuario}) : super(key: key);

  @override
  _EditarUsuarioPageState createState() => _EditarUsuarioPageState();
}

class _EditarUsuarioPageState extends State<EditarUsuarioPage> {
  final _nombreUsuarioController = TextEditingController();
  final _apellidoPaternoController = TextEditingController();
  final _apellidoMaternoController = TextEditingController();
  final _correoElectronicoController = TextEditingController();

  int? _rolSeleccionado;

  @override
  void initState() {
    super.initState();
    _nombreUsuarioController.text = widget.usuario.nombreUsuario;
    _apellidoPaternoController.text = widget.usuario.apellidoPaterno;
    _apellidoMaternoController.text = widget.usuario.apellidoMaterno;
    _correoElectronicoController.text = widget.usuario.correoElectronico;
    _rolSeleccionado = widget.usuario.idRol;

    // Cargar roles al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UsuarioViewModel>(context, listen: false).readRoles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioViewModel = Provider.of<UsuarioViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar Usuario',
          style: TextStyle(color: Colors.white),
        ),

        centerTitle: true,
        backgroundColor: const Color(0xFF14C9DE),
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
          usuarioViewModel.cargando && usuarioViewModel.roles.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nombreUsuarioController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre de Usuario',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _apellidoPaternoController,
                      decoration: const InputDecoration(
                        labelText: 'Apellido Paterno',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _apellidoMaternoController,
                      decoration: const InputDecoration(
                        labelText: 'Apellido Materno',
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _correoElectronicoController,
                      decoration: const InputDecoration(
                        labelText: 'Correo Electrónico',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Rol del Usuario'),
                    DropdownButton<int>(
                      value: _rolSeleccionado,
                      isExpanded: true,
                      items:
                          usuarioViewModel.roles.map((rol) {
                            return DropdownMenuItem<int>(
                              value: rol['id_rol'],
                              child: Text(rol['nombre_rol']),
                            );
                          }).toList(),
                      onChanged: (nuevoRol) {
                        setState(() {
                          _rolSeleccionado = nuevoRol;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: BotonWidget(
                        texto: 'Guardar Cambios',
                        coloresDegradado: const [
                          Color(0xFF14C9DE),
                          Color.fromARGB(255, 9, 135, 238),
                        ],
                        width: 180,
                        height: 40,
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        onPressed: () async {
                          final updatedUser = UserModel(
                            id: widget.usuario.id,
                            nombreUsuario: _nombreUsuarioController.text,
                            apellidoPaterno: _apellidoPaternoController.text,
                            apellidoMaterno: _apellidoMaternoController.text,
                            correoElectronico:
                                _correoElectronicoController.text,
                            idRol: _rolSeleccionado ?? widget.usuario.idRol,
                            nombreRol:
                                usuarioViewModel.roles.firstWhere(
                                  (rol) => rol['id_rol'] == _rolSeleccionado,
                                  orElse:
                                      () => {
                                        'nombre_rol': widget.usuario.nombreRol,
                                      },
                                )['nombre_rol'],
                          );

                          usuarioViewModel.updateUsuario(updatedUser);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
