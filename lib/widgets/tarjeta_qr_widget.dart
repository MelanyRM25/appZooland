import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/viewmodels/mascota_viewmodel.dart';

class TarjetaQRWidget extends StatelessWidget {
  final GlobalKey qrCardKey;
  final Mascota mascota;

  const TarjetaQRWidget({
    super.key,
    required this.qrCardKey,
    required this.mascota,
  });

  @override
  Widget build(BuildContext context) {
    final qrViewModel = context.watch<MascotaViewModel>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          RepaintBoundary(
            key: qrCardKey,
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F6FD),
                border: Border.all(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/logo_zooland.png', height: 50),
                  const SizedBox(height: 12),
                  Text(
                    mascota.nombre,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal),
                  ),
                  const SizedBox(height: 12),
                  QrImageView(
                    data: mascota.id ?? 'ID inválido',
                    size: 180,
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: qrViewModel.isSaving
                    ? null
                    : () => qrViewModel.guardarQRComoImagen(qrCardKey, context),
                icon: qrViewModel.isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.download),
                label: Text(qrViewModel.isSaving ? "Guardando..." : "Guardar"),
              ),
              ElevatedButton.icon(
                onPressed: qrViewModel.isPrinting
                    ? null
                    : () => qrViewModel.imprimirQRComoPDF(qrCardKey, context),
                icon: qrViewModel.isPrinting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf),
                label: Text(qrViewModel.isPrinting ? "Imprimiendo..." : "Imprimir"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
