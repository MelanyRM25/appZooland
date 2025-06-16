import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooland/routes/app_rutas.dart';
import 'package:zooland/viewmodels/mascota_viewmodel.dart';
import 'package:zooland/models/mascota_model.dart';

class ListaMascotasScreen extends StatefulWidget {
  @override
  _ListaMascotasScreenState createState() => _ListaMascotasScreenState();
}

class _ListaMascotasScreenState extends State<ListaMascotasScreen> {
  TextEditingController _searchController = TextEditingController();
  String _filtro = '';

  final List<Color> vividColors = [
    Color(0xFFE53935), Color(0xFFD81B60), Color(0xFF8E24AA),
    Color(0xFF5E35B1), Color(0xFF3949AB), Color(0xFF1E88E5),
    Color(0xFF039BE5), Color(0xFF00ACC1), Color(0xFF00897B),
    Color(0xFF43A047), Color(0xFF7CB342), Color(0xFFC0CA33),
    Color(0xFFFDD835), Color(0xFFFFB300), Color(0xFFFB8C00),
  ];

  Color getVividColor(int index) {
    return vividColors[index % vividColors.length];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MascotaViewModel>(context, listen: false).cargarMascotas();
    });
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

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<MascotaViewModel>(context);
    final List<Mascota> mascotasFiltradas = viewModel.listaMascotas.where((m) {
      final nombreMascota = m.nombre.toLowerCase();
      final nombreProp = m.nombrePropietario?.toLowerCase() ?? '';
      final apellidoProp = m.apellidoPropietario?.toLowerCase() ?? '';
      return nombreMascota.contains(_filtro) ||
          nombreProp.contains(_filtro) ||
          apellidoProp.contains(_filtro);
    }).toList();

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/menu');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Mascotas', style: TextStyle(color: Colors.white)),
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
                  hintText: 'Buscar por nombre de mascota o propietario...',
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
        body: viewModel.isLoading
            ? const Center(child: CircularProgressIndicator())
            : mascotasFiltradas.isEmpty
                ? const Center(
                    child: Text(
                      'No se encontraron mascotas.',
                      style: TextStyle(color: Colors.deepPurple),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      itemCount: mascotasFiltradas.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (context, index) {
                        final mascota = mascotasFiltradas[index];
                        final cardColor = getVividColor(index);

                        return Card(
                          color: cardColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRutas.mascota_page,
                                arguments: mascota,
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: mascota.imagen_url != null &&
                                            mascota.imagen_url!.isNotEmpty
                                        ? Image.network(
                                            mascota.imagen_url!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                              Icons.image_not_supported,
                                              size: 60,
                                              color: Colors.white70,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.pets,
                                            size: 60,
                                            color: Colors.white70,
                                          ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        mascota.nombre,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        mascota.especie,
                                        style: const TextStyle(color: Colors.white70),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${mascota.nombrePropietario ?? ''} ${mascota.apellidoPropietario ?? ''}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
