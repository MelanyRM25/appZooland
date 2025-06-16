import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/views/historial_clinico/registro_vacuna.dart';
import '../models/vacuna_model.dart';
import '../services/vacuna_service.dart';

class VacunasTab extends StatefulWidget {
  final Mascota mascota;

  const VacunasTab({Key? key, required this.mascota}) : super(key: key);

  @override
  State<VacunasTab> createState() => _VacunasTabState();
}

class _VacunasTabState extends State<VacunasTab> {
  final VacunaService _service = VacunaService();
  List<Vacuna> _vacunas = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _cargarVacunas();
  }

  Future<void> _cargarVacunas() async {
    setState(() {
      _loading = true;
    });
    try {
      final data = await _service.obtenerHistorial(widget.mascota.id!);
      setState(() {
        _vacunas = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al cargar vacunas')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String _formatearFecha(DateTime fecha) {
    return DateFormat('dd MMM yyyy').format(fecha);
  }

  Color? _colorEstadoProximaDosis(DateTime fechaProximaDosis) {
    final hoy = DateTime.now();
    final diferencia = fechaProximaDosis.difference(hoy).inDays;
    if (diferencia < 0) return Colors.red[700]; // Vencida
    if (diferencia <= 7) return Colors.orange[700]; // Próxima en menos de 7 días
    return null; // Normal
  }

  Widget _buildVacunaCard(Vacuna vacuna) {
    final colorEstado = _colorEstadoProximaDosis(vacuna.fechaProximaDosis);
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vacuna.nombreVacuna,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Text('Aplicación: ${_formatearFecha(vacuna.fechaAplicacion)}'),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_month, size: 16, color: Colors.grey[700]),
                const SizedBox(width: 6),
                Text(
                  'Próxima dosis: ${_formatearFecha(vacuna.fechaProximaDosis)}',
                  style: TextStyle(color: colorEstado),
                ),
                if (colorEstado != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Icon(
                      colorEstado == Colors.red[700] ? Icons.warning_amber_rounded : Icons.schedule,
                      color: colorEstado,
                      size: 18,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Peso mascota: ${vacuna.pesoMascota.toStringAsFixed(1)} kg',
              style: TextStyle(color: Colors.grey[800]),
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
          : _vacunas.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'No hay vacunas registradas aún.\nUsa el botón para agregar una nueva.',
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
                  onRefresh: _cargarVacunas,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 100, top: 8),
                    itemCount: _vacunas.length,
                    itemBuilder: (context, index) => _buildVacunaCard(_vacunas[index]),
                  ),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegistroVacunaPage(idMascota: widget.mascota.id!),
            ),
          );
          if (resultado == true) {
            _cargarVacunas(); // Recargar si se registró una vacuna
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Nueva vacuna',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: Colors.teal[600],
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
