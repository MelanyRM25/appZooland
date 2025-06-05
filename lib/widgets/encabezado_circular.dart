import 'package:flutter/material.dart';

class EncabezadoCircular extends StatelessWidget {
  final double width;
  final double height;
  final Color? color; // Color sólido opcional
  final List<Color>? gradientColors; // Lista de colores para el degradado
  final Alignment begin;
  final Alignment end;
  final double rotationAngle; // Ángulo de rotación en radianes

  // Constructor
  EncabezadoCircular({
    required this.width,
    required this.height,
    this.color,
    this.gradientColors,
    this.begin = Alignment.center,
    this.end = Alignment.bottomRight,
    this.rotationAngle = 0, // Valor por defecto sin rotación
  }) : assert(
          color != null || gradientColors != null,
          'Debes proporcionar un color sólido o una lista de colores para el degradado.',
        );

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotationAngle, // Aplica la rotación
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color, // Se usará si no hay degradado
          gradient: gradientColors != null
              ? LinearGradient(
                  colors: gradientColors!,
                  begin: begin,
                  end: end,
                )
              : null,
        ),
      ),
    );
  }
}
