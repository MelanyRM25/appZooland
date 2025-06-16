import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zooland/routes/app_rutas.dart';
import 'package:zooland/widgets/boton.dart';
import 'package:zooland/widgets/encabezado_circular.dart';
import 'package:zooland/widgets/fondo.dart';

class TipoUsuarioPage extends StatelessWidget {
  const TipoUsuarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Fondo con degradado o color sólido personalizado
            Fondo(color_solido: Colors.white),

            // Encabezado circular decorativo arriba a la izquierda
            Positioned(
              top: screenHeight * -0.35,
              left: screenWidth * 0.4,
              child: EncabezadoCircular(
                width: screenWidth * 1.0,
                height: screenWidth * 1.0,
                gradientColors: const [
                  Color.fromARGB(255, 18, 173, 162),
                  Color.fromARGB(255, 61, 233, 252),
                ],
              ),
            ),

            // Logo en la parte superior izquierda
            Positioned(
              top: screenHeight * -0.01,
              left: screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.26,
                height: screenWidth * 0.26,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo_zooland.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            // Texto título grande
            Positioned(
              top: screenHeight * 0.15,
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selecciona tu rol',
                    style: TextStyle(
                      fontSize: screenWidth * 0.09,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 18, 173, 162),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '¿Eres veterinario o propietario?',
                    style: TextStyle(
                      fontSize: screenWidth * 0.055,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Animación Lottie o imagen decorativa central
            Positioned(
              top: screenHeight * 0.16,
              left: screenWidth * 0.2,
              child: Lottie.asset(
                'assets/animations/doctor.json',
                width: screenWidth * 0.6,
                height: screenHeight * 0.6,
                fit: BoxFit.contain,
              ),
            ),

            // Botones de selección al pie
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.07),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BotonWidget(
                      texto: 'Soy personal veterinario',
                      coloresDegradado: const [
                        Color.fromARGB(246, 255, 168, 7),
                        Color.fromARGB(255, 223, 149, 60),
                      ],
                      width: screenWidth * 0.8,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRutas.welcome);
                      },
                    ),
                    const SizedBox(height: 20),
                    BotonWidget(
                      texto: 'Soy propietario',
                      coloresDegradado: const [
                        Color.fromARGB(255, 18, 173, 162),
                        Color.fromARGB(255, 14, 134, 232),
                      ],
                      width: screenWidth * 0.8,
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'RobotoMono',
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRutas.escaner_qr_propietario);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
