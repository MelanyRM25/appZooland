import 'package:flutter/material.dart';

class BotonQR extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;

  const BotonQR({
    super.key,
    required this.onPressed,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Detecta el toque sin efectos adicionales
      child: Container(
        width: 60, // Tamaño del botón
        height: 60, // Tamaño del botón
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 40, // Tamaño de la imagen
            height: 40, // Tamaño de la imagen
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
