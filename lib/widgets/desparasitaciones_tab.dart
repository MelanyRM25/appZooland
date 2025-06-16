import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/services/desparasitacion_service.dart';
import 'package:zooland/views/historial_clinico/registro_desparasitacion.dart';

class DesparasitacionesTab extends StatefulWidget {
  final Mascota mascota;

  const DesparasitacionesTab({Key? key, required this.mascota}) : super(key: key);

  @override
  State<DesparasitacionesTab> createState() => _DesparasitacionesTabState();
}

class _DesparasitacionesTabState extends State<DesparasitacionesTab> {
  final DesparasitacionService _service = DesparasitacionService();
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

  Widget _buildItem(Map<String, dynamic> r) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              r['producto_desparasitante'] ?? 'Producto desconocido',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _datoItem(Icons.monitor_weight, 'Peso', '${r['peso_mascota']} kg'),
                _datoItem(Icons.calendar_today, 'Dosis', _formatearFecha(r['fecha_dosis'])),
                _datoItem(Icons.event, 'Próxima dosis', _formatearFecha(r['proxima_dosis'])),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _formatearFecha(r['fecha_registro'] ?? r['fecha_dosis']),
                style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.grey),
              ),
            )
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
          style: const TextStyle(fontWeight: FontWeight.w600),
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
                      "No hay registros de desparasitación aún.\nUsa el botón para agregar uno nuevo.",
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
                    itemBuilder: (context, index) => _buildItem(registros[index]),
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegistroDesparasitacionPage(idMascota: widget.mascota.id!),
            ),
          );
          if (resultado == true) {
            _cargarHistorial(); // Recargar si se registró algo
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Nueva desparasitación", style: TextStyle(fontSize: 16, color: Colors.white)),
        backgroundColor: Colors.teal[600],
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
