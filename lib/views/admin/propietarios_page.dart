import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooland/viewmodels/propietario_viewmodel.dart';
import 'package:zooland/views/admin/registro_mascota.dart';

class ListaPropietariosPage extends StatefulWidget {
  const ListaPropietariosPage({Key? key}) : super(key: key);

  @override
  State<ListaPropietariosPage> createState() => _ListaPropietariosPageState();
}

class _ListaPropietariosPageState extends State<ListaPropietariosPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PropietarioViewModel>(context, listen: false).cargarPropietarios());
  }

  @override
  Widget build(BuildContext context) {
    final propVM = context.watch<PropietarioViewModel>();
    final propietarios = propVM.propietarios;

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/menu');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Propietarios', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.teal,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/menu');
            },
          ),
        ),
        body: propVM.isLoading
            ? const Center(child: CircularProgressIndicator())
            : propietarios.isEmpty
                ? const Center(child: Text('No hay propietarios registrados.'))
                : ListView.builder(
                    itemCount: propietarios.length,
                    itemBuilder: (context, index) {
                      final prop = propietarios[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text('${prop.nombre} ${prop.apellidoPaterno}'),
                          subtitle: Text(prop.celular),
                          trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Registrar Mascota'),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => RegistroMascota(idPropietario: prop.idPropietario!),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
