import 'package:flutter/material.dart';

class BotonIcono extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color iconColor;
  final double iconSize;
  final Color shadowColor;

  const BotonIcono({
    required this.onPressed,
    required this.icon,
    this.iconColor = Colors.white, // Color del ícono
    this.iconSize = 24.0, // Tamaño del ícono
    this.shadowColor = Colors.black, // Color de la sombra
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // No colorear el botón
      shadowColor: shadowColor.withOpacity(0.3), // Sombra del ícono
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50), // Bordes redondeados
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50), // Bordes redondeados
        child: Container(
          padding: EdgeInsets.all(8.0), // Espaciado dentro del botón
          child: Stack(
            children: [
              // Sombra del ícono
              Positioned(
                left: 2.0,
                top: 2.0,
                child: Icon(
                  icon,
                  size: iconSize,
                  color: shadowColor, // Sombra del ícono
                ),
              ),
              // Ícono principal
              Icon(
                icon,
                size: iconSize,
                color: iconColor, // Color principal del ícono
              ),
            ],
          ),
        ),
      ),
    );
  }
}
