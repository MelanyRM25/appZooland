import 'package:flutter/material.dart';
class BotonWidget extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;
  final List<Color>? coloresDegradado;
  final Color? colorSolido;
  final double borderRadius;
  final double height;
  final double fontSize;
  final double? width;
  final TextStyle? textStyle; // ✅ Nuevo

  const BotonWidget({
    Key? key,
    required this.texto,
    required this.onPressed,
    this.coloresDegradado,
    this.colorSolido,
    this.borderRadius = 16,
    this.height = 55,
    this.fontSize = 18,
    this.width,
    this.textStyle, // ✅ Nuevo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colorSolido,
          gradient: coloresDegradado != null
              ? LinearGradient(
                  colors: coloresDegradado!,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6,
              offset: Offset(0, 4),
            )
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          texto,
          style: textStyle ??
              TextStyle(
                color: Colors.white,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }
}
