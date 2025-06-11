import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/services/mascota_service.dart';
import 'package:pdf/widgets.dart' as pw; // ✅ Esta es la correcta


class MascotaViewModel extends ChangeNotifier {
  final MascotaService _mascotaService = MascotaService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String? _mascotaId;
  String? get mascotaId => _mascotaId;

  /// Registrar mascota con imagen
  Future<void> registrarMascotaConImagen({
    required Mascota mascota,
    required File imagen,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Subir la imagen
      final urlImagen = await _mascotaService.subirImagen(imagen, mascota.nombre);

      // Crear nuevo objeto con URL de imagen
      final mascotaConImagen = mascota.copyWith(imagen_url: urlImagen);

      // Insertar mascota
      final id = await _mascotaService.insertarMascota(mascotaConImagen);
      _mascotaId = id;
    } catch (e) {
      _error = 'Error al registrar mascota: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void limpiarEstado() {
    _isLoading = false;
    _error = null;
    _mascotaId = null;
    notifyListeners();
  }

  List<Mascota> _listaMascotas = [];
List<Mascota> get listaMascotas => _listaMascotas;

Future<void> cargarMascotas() async {
  _isLoading = true;
  notifyListeners();
  try {
    _listaMascotas = await _mascotaService.obtenerMascotas();
  } catch (e) {
    _error = 'Error al cargar mascotas: $e';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
Future<Mascota?> obtenerMascotaPorId(String id) async {
  try {
    return await _mascotaService.obtenerMascotaPorId(id);
  } catch (e) {
    _error = 'Error al obtener la mascota: $e';
    notifyListeners();
    return null;
  }
}
// En MascotaViewModel
Future<void> guardarQrEnBase(String mascotaId, String qrData) async {
  _isLoading = true;
  notifyListeners();

  try {
    await _mascotaService.actualizarQrData(mascotaId, qrData);
  } catch (e) {
    _error = 'Error al guardar QR en DB: $e';
    rethrow; // para que la UI también lo vea si hace await
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
bool _isSaving = false;
  bool _isPrinting = false;

  bool get isSaving => _isSaving;
  bool get isPrinting => _isPrinting;

  Future<void> guardarQRComoImagen(GlobalKey key, BuildContext context) async {
    _isSaving = true;
    notifyListeners();

    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 300));
        return guardarQRComoImagen(key, context);
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      var status = await Permission.storage.request();
      if (!status.isGranted) {
        _showSnackBar(context, "Permiso de almacenamiento denegado");
        return;
      }

      final directory = Directory('/storage/emulated/0/Pictures/Zooland');
      if (!(await directory.exists())) await directory.create(recursive: true);

      final filePath = '${directory.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      _showSnackBar(context, "Imagen guardada en: $filePath");
    } catch (e) {
      _showSnackBar(context, "Error al guardar la imagen");
      print("❌ Error al guardar: $e");
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> imprimirQRComoPDF(GlobalKey key, BuildContext context) async {
    _isPrinting = true;
    notifyListeners();

    try {
      RenderRepaintBoundary boundary =
          key.currentContext!.findRenderObject() as RenderRepaintBoundary;
      if (boundary.debugNeedsPaint) {
        await Future.delayed(const Duration(milliseconds: 300));
        return imprimirQRComoPDF(key, context);
      }

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final doc = pw.Document();
      final imageProvider = pw.MemoryImage(pngBytes);
      doc.addPage(pw.Page(build: (pw.Context context) => pw.Center(child: pw.Image(imageProvider))));

      await Printing.layoutPdf(onLayout: (format) async => doc.save());
    } catch (e) {
      _showSnackBar(context, "Error al imprimir PDF");
      print("❌ Error al imprimir: $e");
    } finally {
      _isPrinting = false;
      notifyListeners();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }
  }



}
