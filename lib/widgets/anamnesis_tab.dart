import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/services/anamnesis_service.dart';
import 'package:zooland/views/historial_clinico/registro_anamnesis.dart'; // importa la pantalla de registro

class AnamnesisTab extends StatefulWidget {
  final Mascota mascota;

  const AnamnesisTab({Key? key, required this.mascota}) : super(key: key);

  @override
  State<AnamnesisTab> createState() => _AnamnesisTabState();
}

class _AnamnesisTabState extends State<AnamnesisTab> {
  final AnamnesisService _service = AnamnesisService();
  List<Map<String, dynamic>> registros = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarHistorial();
  }

  Future<void> _cargarHistorial() async {
    setState(() => _loading = true);
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
      return fecha.length > 16 ? fecha.substring(0, 16) : fecha;
    }
  }

  Widget _buildAnamnesisItem(Map<String, dynamic> r) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Síntomas',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800])),
            const SizedBox(height: 4),
            Text(r['sintomas'] ?? ''),
            const SizedBox(height: 12),

            Text('Intervenciones Previas',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800])),
            const SizedBox(height: 4),
            Text(r['intervenciones_previas'] ?? ''),
            const SizedBox(height: 12),

            Text('Enfermedades Previas',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800])),
            const SizedBox(height: 4),
            Text(r['enfermedades_previas'] ?? ''),
            const SizedBox(height: 12),

            Text('Pre Diagnóstico',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800])),
            const SizedBox(height: 4),
            Text(r['pre_diagnostico'] ?? ''),
            const SizedBox(height: 12),

            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                _formatearFecha(r['fecha_registro'] ?? ''),
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : registros.isEmpty
              ? const Center(child: Text('No hay registros de anamnesis.'))
              : RefreshIndicator(
                  onRefresh: _cargarHistorial,
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: registros.length,
                    itemBuilder: (_, i) => _buildAnamnesisItem(registros[i]),
                  ),
                ),
       floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegistroAnamnesisPage(idMascota: widget.mascota.id!),
            ),
          );
          if (resultado == true) {
            _cargarHistorial(); // Recargar si se registró algo
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Nueva Anamnesis", style: TextStyle(fontSize: 16,color: Colors.white)),
        backgroundColor: Colors.teal[600],
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
