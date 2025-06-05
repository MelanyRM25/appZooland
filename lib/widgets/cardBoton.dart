import 'package:flutter/material.dart';

class CardButton extends StatefulWidget {
  final String texto;
  final String rutaImagen;
  final Color colorFondo;
  final VoidCallback onPressed;

  const CardButton({
    super.key,
    required this.texto,
    required this.rutaImagen,
    required this.colorFondo,
    required this.onPressed,
  });

  @override
  State<CardButton> createState() => _CardButtonState();
}

class _CardButtonState extends State<CardButton> {
  double _elevacion = 8;
  bool _presionado = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _presionado = true;
      _elevacion = 2; // Menor elevación para dar el efecto de presión
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _presionado = false;
      _elevacion = 8; // Elevación original al soltar
    });
  }

  void _onTapCancel() {
    setState(() {
      _presionado = false;
      _elevacion = 8; // Elevación original si se cancela el tap
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150), // Duración de la animación
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: widget.colorFondo,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: _elevacion, // Cambio de elevación al presionar
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              widget.rutaImagen,
              width: 60,
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 10),
            Text(
              widget.texto,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
