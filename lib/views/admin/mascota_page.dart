import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/viewmodels/mascota_viewmodel.dart';

class MascotaPage extends StatefulWidget {
  @override
  _MascotaPageState createState() => _MascotaPageState();
}

class _MascotaPageState extends State<MascotaPage> {
  late Mascota mascota;
  final GlobalKey _qrCardKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Mascota) {
      mascota = args;
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 5,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    mascota.imagen_url != null && mascota.imagen_url!.isNotEmpty
                        ? Image.network(mascota.imagen_url!, fit: BoxFit.cover)
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.pets, size: 100, color: Colors.grey),
                          ),
                    Container(color: Colors.black.withOpacity(0.3)),
                    Positioned(
                      bottom: 20,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mascota.nombre,
                            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${mascota.raza} • ${mascota.sexo}',
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: Column(
            children: [
              const TabBar(
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Overview"),
                  Tab(text: "Tarjetas"),
                  Tab(text: "Health"),
                  Tab(text: "Records"),
                  Tab(text: "Tarjeta QR"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildOverviewTab(),
                    const Center(child: Text("Tarjetas")),
                    const Center(child: Text("Health")),
                    const Center(child: Text("Records")),
                    _buildTarjetaQRTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text("Código QR único", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          QrImageView(
            data: mascota.id ?? 'ID inválido',
            version: QrVersions.auto,
            size: 200.0,
            backgroundColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildTarjetaQRTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          RepaintBoundary(
            key: _qrCardKey,
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F6FD),
                border: Border.all(color: Colors.teal, width: 2),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.2),
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
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.teal),
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
                onPressed: () => _guardarQRComoImagen(_qrCardKey),
                icon: const Icon(Icons.download),
                label: const Text("Guardar"),
              ),
              ElevatedButton.icon(
                onPressed: () => _imprimirQRComoPDF(_qrCardKey),
                icon: const Icon(Icons.print),
                label: const Text("Imprimir"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Guarda la tarjeta QR como PNG y luego persiste el contenido del QR en la DB
  Future<void> _guardarQRComoImagen(GlobalKey key) async {
    try {
      // Captura y convierte a bytes
      RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 300));
        return _guardarQRComoImagen(key);
      }
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Permisos Android
      if (Platform.isAndroid) {
        await Permission.photos.request();
        await Permission.storage.request();
      }

      // Guarda en carpeta Pictures/Zooland
      final directory = Directory('/storage/emulated/0/Pictures/Zooland');
      if (!(await directory.exists())) await directory.create(recursive: true);
      final filePath = '${directory.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
      await File(filePath).writeAsBytes(pngBytes);

      // ——— Aquí persistes el contenido del QR en la DB ———
      final qrContent = mascota.id!; // o el string que quieras
      await Provider.of<MascotaViewModel>(context, listen: false)
          .guardarQrEnBase(mascota.id!, qrContent);

      // Notifica éxito
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('✅ Imagen guardada y QR registrado en DB')),
      );
    } catch (e) {
      print("❌ Error al guardar imagen o QR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Falló guardar imagen o QR')),
        );
      }
    }
  }

  Future<void> _imprimirQRComoPDF(GlobalKey key) async {
    try {
      RenderRepaintBoundary boundary = key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 300));
        return _imprimirQRComoPDF(key);
      }
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final doc = pw.Document();
      final imageProvider = pw.MemoryImage(pngBytes);
      doc.addPage(pw.Page(build: (context) => pw.Center(child: pw.Image(imageProvider))));
      await Printing.layoutPdf(onLayout: (format) async => doc.save());
    } catch (e) {
      print("❌ Error al imprimir: $e");
    }
  }
}
