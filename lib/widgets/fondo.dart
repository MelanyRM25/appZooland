import 'package:flutter/material.dart';

class Fondo extends StatelessWidget {
  final List<Color>? coloresDegradado; // Lista de colores para el degradado, puede ser nula
  final Color? color_solido; // Color sólido opcional
  final Alignment begin;
  final Alignment end;

  // Constructor que acepta los colores del degradado y los puntos de inicio y fin del mismo
  Fondo({
    this.coloresDegradado,
    this.color_solido,
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
  }) : assert(coloresDegradado != null || color_solido != null, 
             'Debes proporcionar un color sólido o un degradado');

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color_solido, // Usamos el color sólido si se proporciona
        gradient: coloresDegradado != null
            ? LinearGradient(
                colors: coloresDegradado!,
                begin: begin,
                end: end,
              )
            : null, // Usamos el degradado si se proporciona
      ),
    );
  }
}
