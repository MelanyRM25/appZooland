import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/viewmodels/mascota_viewmodel.dart';
import 'package:zooland/routes/app_rutas.dart';

class EscanerQRPage extends StatefulWidget {
  const EscanerQRPage({super.key});

  @override
  State<EscanerQRPage> createState() => _EscanerQRPageState();
}

class _EscanerQRPageState extends State<EscanerQRPage> {
  bool _isScanning = true;

  void _onDetect(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final String? codigo = capture.barcodes.first.rawValue;
    if (codigo == null) return;

    setState(() {
      _isScanning = false; // Para evitar múltiples lecturas
    });

    final mascotaVM = Provider.of<MascotaViewModel>(context, listen: false);

    try {
      final mascota = await mascotaVM.obtenerMascotaPorId(codigo);
      if (mascota != null) {
        Navigator.pushReplacementNamed(
          context,
          AppRutas.mascota_page,
          arguments: mascota,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mascota no encontrada')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar mascota: $e')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
      ),
      body: Stack(
        children: [
          MobileScanner(            
            onDetect: _onDetect,
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Alinea el QR dentro del recuadro',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
