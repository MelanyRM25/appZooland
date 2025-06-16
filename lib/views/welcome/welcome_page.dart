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

    return WillPopScope(
      onWillPop: () async {
        // Al presionar botón atrás, navegamos a tipo_usuario_page y evitamos que vuelva atrás
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/tipo_usuario',  // Cambia a AppRutas.tipoUsuario si tienes esa constante
          (route) => false,
        );
        return false; // Indica que no debe cerrar la app automáticamente
      },
      child: Scaffold(
        extendBodyBehindAppBar: false,
        body: SafeArea(
          child: Stack(
            children: [
              Fondo(color_solido: Colors.white),
              Positioned(
                top: screenHeight * -0.30,
                left: screenWidth * 0.45,
                child: EncabezadoCircular(
                  width: screenWidth * 0.9,
                  height: screenWidth * 0.9,
                  gradientColors: [
                    Color.fromARGB(255, 18, 173, 162),
                    Color.fromARGB(255, 61, 233, 252),
                  ],
                ),
              ),
              Positioned(
                top: screenHeight * -0.04,
                left: screenWidth * 0.1,
                child: Container(
                  width: screenWidth * 0.3,
                  height: screenWidth * 0.3,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/logo_zooland.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: screenHeight * 0.12,
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
              Positioned(
                top: screenHeight * 0.15,
                left: screenWidth * 0.10,
                child: Lottie.asset(
                  'assets/animations/pet1.json',
                  width: screenWidth * 0.8,
                  height: screenHeight * 0.8,
                  fit: BoxFit.contain,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
      ),
    );
  }
}
