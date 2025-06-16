import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:zooland/viewmodels/mascota_viewmodel.dart';
import 'package:zooland/views/propietario/lista_mascotas_propietario.dart';

class EscanerQRPropietarioPage extends StatefulWidget {
  const EscanerQRPropietarioPage({super.key});

  @override
  State<EscanerQRPropietarioPage> createState() => _EscanerQRPropietarioPageState();
}

class _EscanerQRPropietarioPageState extends State<EscanerQRPropietarioPage> {
  bool _isScanning = true;

  void _onDetect(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final String? idPropietario = capture.barcodes.first.rawValue;
    debugPrint('QR detectado (ID propietario): $idPropietario');

    if (idPropietario == null) return;

    setState(() {
      _isScanning = false;
    });

    final mascotaVM = Provider.of<MascotaViewModel>(context, listen: false);

    try {
      final mascotas = await mascotaVM.obtenerMascotasDelPropietario(idPropietario);

      if (mascotas != null && mascotas.isNotEmpty) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => ListaMascotasPropietarioPage(mascotas: mascotas),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se encontraron mascotas del propietario')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al buscar: $e')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanea el QR de tu propietario'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: MobileScannerController(),
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
