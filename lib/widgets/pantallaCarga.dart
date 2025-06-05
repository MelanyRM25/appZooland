import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zooland/widgets/fondo.dart'; // Tu widget personalizado de fondo

class PantallaCarga extends StatelessWidget {
  const PantallaCarga({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Fondo(
          coloresDegradado: [const Color.fromARGB(255, 182, 31, 209), Colors.blue.shade800],
        ),
        Center(
          child: Lottie.asset(
            'assets/animations/load1.json', // Ruta local del archivo .json
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }
}
