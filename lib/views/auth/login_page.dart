import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:zooland/routes/app_rutas.dart';
import 'package:zooland/viewmodels/auth_viewmodel.dart';
import 'package:zooland/widgets/boton.dart';
import 'package:zooland/widgets/boton_icono.dart';
import 'package:zooland/widgets/campo_text.dart';
import 'package:zooland/widgets/container_widget.dart';
import 'package:zooland/widgets/encabezado_circular.dart';
import 'package:zooland/widgets/fondo.dart';
import 'package:zooland/widgets/texto_link%20copy.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final authViewModel = Provider.of<AuthViewModel>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            Fondo(
              coloresDegradado: const [
                Color.fromARGB(255, 18, 173, 162),
                Color.fromARGB(255, 61, 233, 252),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            Positioned(
              top: screenHeight * -0.30,
              left: screenWidth * 0.10,
              child: EncabezadoCircular(
                width: screenWidth * 0.8,
                height: screenWidth * 0.8,
                gradientColors: [
                  Color.fromARGB(255, 255, 255, 255),
                  Color.fromARGB(255, 255, 255, 255),
                ],
              ),
            ),
            Positioned(
              top: screenHeight * -0.04,
              left: screenWidth * 0.35,
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
              top: screenHeight * 0.01,
              left: screenWidth * 0.02,
              child: BotonIcono(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icons.arrow_back,
                iconColor: Colors.white,
                iconSize: 30.0,
              ),
            ),
            Positioned(
              top: screenHeight * 0.1,
              left: screenWidth * 0.05,
              child: Padding(
                padding: EdgeInsets.only(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Accede a tu cuenta",
                      style: TextStyle(
                        fontSize: screenWidth * 0.10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
             Positioned(
              top: screenHeight * 0.02,  // Ajusta la posición vertical
              left: screenWidth * 0.20,  // Ajusta la posición horizontal
              child: Lottie.asset(
                'assets/animations/pet2.json', // Reemplaza con tu archivo Lottie
                width: screenWidth * 0.6,  // Ajusta el tamaño
                height: screenHeight * 0.6, // Ajusta el tamaño
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ContainerRedondeado(
                alturaPorcentaje: 0.50,
                color: Colors.white,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
                    return SingleChildScrollView(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.07,
                        right: screenWidth * 0.07,
                        top: screenHeight * 0.06,
                        bottom: viewInsets + 20,
                      ),
                      child: Column(
                        children: [
                          CampoTextoRedondeado(
                            controller: emailController,
                            hintText: 'Correo electrónico',
                            icono: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          CampoTextoRedondeado(
                            controller: passwordController,
                            hintText: 'Contraseña',
                            icono: Icons.lock_outline,
                            obscureText: true,
                          ),
                          SizedBox(height: screenHeight * 0.05),
                          authViewModel.cargando
                              ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.teal),
                              )
                              : BotonWidget(
                                texto: 'Iniciar Sesion',
                                coloresDegradado: [
                                  Color.fromARGB(255, 18, 173, 162),
                                  Color.fromARGB(255, 14, 134, 232),
                                ],
                                width: 160,
                                textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'RobotoMono',
                                ),
                                onPressed: () async {
                                  final email = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();

                                  if ([email, password].any((s) => s.isEmpty)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Completa todos los campos obligatorios',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  //manejando el viewmodel
                                  try {
                                    await authViewModel.iniciarSesion(
                                      email,
                                      password,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Inicio de sesión exitoso',
                                        ),
                                      ),
                                    );
                                    // Obtener el rol del usuario
                                    final rol = authViewModel.usuario?.idRol;

                                    if (rol == 1) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        AppRutas.admin,
                                      );
                                    } else if (rol == 2) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        AppRutas.veterinario,
                                      );
                                    } else if (rol == 3) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        AppRutas.recepcionista,
                                      );
                                    } else {
                                      // En caso de rol desconocido
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Rol no reconocido. Contacta al administrador.',
                                          ),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                },
                              ),
                          SizedBox(height: screenHeight * 0.05),
                          TextoLink(
                            textoPrincipal: "¿No tienes cuenta? ",
                            textoLink: "Regístrate aquí",
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRutas.registro,
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
