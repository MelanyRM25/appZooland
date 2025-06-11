import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/services/datos_fisologicos_service.dart';
import 'package:zooland/views/historial_clinico/registro_datos_fisologicos.dart';

class DatosFisiologicosTab extends StatefulWidget {
  final Mascota mascota;

  const DatosFisiologicosTab({Key? key, required this.mascota}) : super(key: key);

  @override
  State<DatosFisiologicosTab> createState() => _DatosFisiologicosTabState();
}

class _DatosFisiologicosTabState extends State<DatosFisiologicosTab> {
  final DatosFisiologicosService _service = DatosFisiologicosService();
  List<Map<String, dynamic>> registros = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    final resultado = await _service.obtenerHistorial(widget.mascota.id!);
    setState(() {
      registros = resultado;
      _loading = false;
    });
  }

  String _formatearFecha(String fecha) {
    try {
      final dt = DateTime.parse(fecha);
      return DateFormat('dd MMM yyyy - HH:mm').format(dt);
    } catch (e) {
      return fecha.substring(0, 16);
    }
  }

 Widget _buildDatoItem(Map<String, dynamic> r) {
  final colorTitulo = Colors.teal[800];
  final colorTexto = Colors.grey[800];
  final iconColor = Colors.teal;

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título

          const SizedBox(height: 12),
          // Datos vitales
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              _datoItem(Icons.favorite, 'FC', '${r['frecuencia_cardiaca']} lpm'),
              _datoItem(Icons.air, 'FR', '${r['frecuencia_respiratoria']} rpm'),
              _datoItem(Icons.monitor_weight, 'Peso', '${r['peso']} kg'),
              _datoItem(Icons.thermostat, 'Temp', '${r['temperatura']}°C'),
              _datoItem(Icons.timer, 'TRC', '${r['tiempo_relleno_capilar']} s'),
            ],
          ),
          const SizedBox(height: 16),
          // Fecha
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _formatearFecha(r['fecha_registro'] ?? ''),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _datoItem(IconData icon, String label, String value) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, color: Colors.teal[400], size: 20),
      const SizedBox(width: 4),
      Text(
        '$label: ',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      Text(value),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : registros.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "No hay datos fisiológicos registrados aún.\nUsa el botón para agregar uno nuevo.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarHistorial,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100, top: 8),
                    itemCount: registros.length,
                    itemBuilder: (context, index) => _buildDatoItem(registros[index]),
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegistroDatosFisiologicosPage(idMascota: widget.mascota.id!),
            ),
          );
          if (resultado == true) {
            _cargarHistorial(); // Recargar si se registró algo
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Nuevo dato", style: TextStyle(fontSize: 16,color: Colors.white)),
        backgroundColor: Colors.teal[600],
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
