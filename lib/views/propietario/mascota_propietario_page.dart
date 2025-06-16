import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/models/propietario_model.dart';
import 'package:zooland/models/vacuna_model.dart';
import 'package:zooland/viewmodels/propietario_viewmodel.dart';
import 'package:zooland/viewmodels/vacuna_viewmodel.dart';
import 'package:zooland/widgets/descripcion_general_tab.dart';

class MascotaPropietarioPage extends StatefulWidget {
  const MascotaPropietarioPage({Key? key}) : super(key: key);

  @override
  State<MascotaPropietarioPage> createState() => _MascotaPropietarioPageState();
}

class _MascotaPropietarioPageState extends State<MascotaPropietarioPage> {
  late Mascota mascota;
  Propietario? propietario;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Mascota) {
      mascota = args;
      _cargarDatos();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _cargarDatos() async {
    final propVM = Provider.of<PropietarioViewModel>(context, listen: false);
    final vacVM = Provider.of<VacunaViewModel>(context, listen: false);

    final prop = await propVM.obtenerPropietarioPorId(mascota.idPropietario);
    await vacVM.cargarVacunas(mascota.id!);

    setState(() {
      propietario = prop;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vacunaVM = Provider.of<VacunaViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          mascota.nombre,
          style: const TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: _isLoading || propietario == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildInfoGeneral(),
                  const SizedBox(height: 24),
                  _buildVacunas(vacunaVM.vacunas),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[300],
        image: mascota.imagen_url != null && mascota.imagen_url!.isNotEmpty
            ? DecorationImage(
                image: NetworkImage(mascota.imagen_url!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mascota.nombre,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${mascota.raza} • ${mascota.sexo}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoGeneral() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información general',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          DescripcionGeneralTab(
            mascota: mascota,
            propietario: propietario!,
          ),
        ],
      ),
    );
  }

Widget _buildVacunas(List<Vacuna> vacunas) {
  final ahora = DateTime.now();
  final aplicadas = vacunas.where((v) => v.fechaAplicacion.isBefore(ahora)).toList()
    ..sort((a, b) => b.fechaAplicacion.compareTo(a.fechaAplicacion));
  final proximas = vacunas.where((v) => v.fechaProximaDosis.isAfter(ahora)).toList()
    ..sort((a, b) => a.fechaProximaDosis.compareTo(b.fechaProximaDosis));

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Registro de Vacunas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),

        if (aplicadas.isNotEmpty) ...[
          const Text(' Vacunas Aplicadas',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.green)),
          const SizedBox(height: 8),
          ...aplicadas.map((v) => _vacunaTile(
                v,
                color: Colors.green,
                icon: Icons.check_circle,
                label: 'Aplicada el',
                fecha: v.fechaAplicacion,
              )),
          const SizedBox(height: 16),
        ],

        if (proximas.isNotEmpty) ...[
          const Text('📅 Próximas dosis',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.orange)),
          const SizedBox(height: 8),
          ...proximas.map((v) => _vacunaTile(
                v,
                color: Colors.orange,
                icon: Icons.schedule,
                label: 'Programada para',
                fecha: v.fechaProximaDosis,
              )),
        ],

        if (vacunas.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text('No hay vacunas registradas.',
                style: TextStyle(color: Colors.grey)),
          ),
      ],
    ),
  );
}

Widget _vacunaTile(
  Vacuna vacuna, {
  required Color color,
  required IconData icon,
  required String label,
  required DateTime fecha,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: Colors.white,
    child: ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        vacuna.nombreVacuna,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '$label: ${_formatFecha(fecha)}\nPeso: ${vacuna.pesoMascota.toStringAsFixed(1)} kg',
        style: const TextStyle(fontSize: 13),
      ),
    ),
  );
}

  String _formatFecha(DateTime fecha) {
    return '${fecha.day.toString().padLeft(2, '0')}/'
        '${fecha.month.toString().padLeft(2, '0')}/'
        '${fecha.year}';
  }
}
