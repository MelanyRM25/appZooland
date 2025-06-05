import 'package:flutter/material.dart';
import 'package:zooland/routes/app_rutas.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    // Animación de opacidad
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Animación de escala
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Iniciar la animación
    _controller.forward();

    // Espera antes de redirigir
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _startSplashAnimation(); // Inicia la transición después de que la animación termine
      }
    });
  }

  // Simula la animación y transición
  void _startSplashAnimation() async {
    await Future.delayed(
      Duration(seconds: 3),
    ); // Espera 1 segundo después de completar la animación
Navigator.pushReplacementNamed(context, AppRutas.welcome);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco
      body: Stack(
        children: [
          // Animación con opacidad y escala del logo PNG
          Center(
            child: FadeTransition(
              opacity: _opacityAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/logo_zooland.png', // Ruta del archivo PNG del logo
                  width: screenWidth * 0.5, // Ancho de la imagen
                  height: screenHeight * 0.5, // Alto de la imagen
                  fit: BoxFit.contain, // Ajuste para que no se recorte
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Limpia el controlador de animaciones
    super.dispose();
  }
}
