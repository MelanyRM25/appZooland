import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zooland/routes/app_rutas.dart';
import 'package:zooland/widgets/boton.dart';
import 'package:zooland/widgets/encabezado_circular.dart';
import 'package:zooland/widgets/fondo.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar:
          false, // Evita que la app se superponga con la barra de notificación
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Fondo(color_solido: Colors.white),
            // Encabezado circular
            // Encabezado Circular en el centro
            Positioned(
              top:
                  screenHeight *
                  -0.30, // Ajusta para centrarlo un poco más arriba si es necesario
              left: screenWidth * 0.45, // Centrado horizontal
              child: EncabezadoCircular(
                width:
                    screenWidth *
                    0.9, // Tamaño relativo al ancho de la pantalla
                height:
                    screenWidth *
                    0.9, // Tamaño relativo al ancho de la pantalla

                gradientColors: [
                  Color.fromARGB(255, 18, 173, 162),
                  Color.fromARGB(255, 61, 233, 252),
                ],
              ),
            ),

            Positioned(
              top:
                  screenHeight *
                  -0.04, 
              left:
                  screenWidth *
                  0.1, 
              child: Container(
                width:
                    screenWidth *
                    0.3, 
                height:
                    screenWidth *
                    0.3, 
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo_zooland.png'),
                    fit:
                        BoxFit
                            .contain, // Ajusta la imagen dentro del contenedor
                  ),
                ),
              ),
            ),
            // Títulos
            Positioned(
              top: screenHeight * 0.12, // Ajustado para evitar el notch
              left: screenWidth * 0.07,
              right: screenWidth * 0.07,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bienvenido a",
                    style: TextStyle(
                      fontSize: screenWidth * 0.09,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 18, 173, 162),
                    ),
                  ),
                  Text(
                    "Veterinaria Zooland",
                    style: TextStyle(
                      fontSize: screenWidth * 0.09,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(246, 255, 168, 7),
                    ),
                  ),
                  SizedBox(height: 17),

                  Text(
                    "Gestión eficiente del historial clínico veterinario con QR dinámicos y alertas tempranas.",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.normal,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
            // Lottie Animación en el centro
            Positioned(
              top: screenHeight * 0.15,  // Ajusta la posición vertical
              left: screenWidth * 0.10,  // Ajusta la posición horizontal
              child: Lottie.asset(
                'assets/animations/pet1.json', // Reemplaza con tu archivo Lottie
                width: screenWidth * 0.8,  // Ajusta el tamaño
                height: screenHeight * 0.8, // Ajusta el tamaño
                fit: BoxFit.contain,
              ),
            ),
            // Botones de navegación
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón de registro
                    BotonWidget(
                      texto: 'Iniciar Sesión',
                      coloresDegradado: [
                        Color.fromARGB(246, 255, 168, 7),
                        Color.fromARGB(255, 223, 149, 60),
                      ],
                      width: 160,
                      textStyle: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'RobotoMono',
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRutas.login);
                      },
                    ),

                    SizedBox(width: screenWidth * 0.05),
                    // Botón de inicio de sesión
                    BotonWidget(
                      texto: 'Registrarse',
                      coloresDegradado: [
                        Color.fromARGB(255, 18, 173, 162),
                        Color.fromARGB(255, 14, 134, 232),
                      ],
                      width: 160,
                      textStyle: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'RobotoMono',
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, AppRutas.registro);
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
