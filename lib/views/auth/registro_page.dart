import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooland/routes/app_rutas.dart';
import 'package:zooland/viewmodels/auth_viewmodel.dart';
import 'package:zooland/widgets/boton.dart';
import 'package:zooland/widgets/boton_icono.dart';
import 'package:zooland/widgets/campo_text.dart';
import 'package:zooland/widgets/container_widget.dart';
import 'package:zooland/widgets/encabezado_circular.dart';
import 'package:zooland/widgets/fondo.dart';
import 'package:zooland/widgets/texto_link.dart';

class RegistroPage extends StatefulWidget {
  const RegistroPage({super.key});

  @override
  _RegistroPageState createState() => _RegistroPageState();
}

class _RegistroPageState extends State<RegistroPage> {
  final nombreController = TextEditingController();
  final apellidoPaternoController = TextEditingController();
  final apellidoMaternoController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nombreController.dispose();
    apellidoPaternoController.dispose();
    apellidoMaternoController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    //Estamos usando el provider para obtener el viewmodel de auth
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
                gradientColors: const [
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
      top: screenHeight * -0.08,
      right: screenWidth * 0.02,
      child: Container(
        width: screenWidth * 0.4,
        height: screenHeight * 0.5,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/reg1.png'), 
            fit: BoxFit.contain,
          ),
        ),
      ),
    ),
            Positioned(
              top: screenHeight * 0.01,
              left: screenWidth * 0.02,
              child: BotonIcono(
                onPressed: () => Navigator.pop(context),
                icon: Icons.arrow_back,
                iconColor: Colors.white,
                iconSize: 30.0,
               ),
            ),
            Positioned(
              top: screenHeight * 0.13,
              left: screenWidth * 0.05,
              child: Text(
                "Regístrate",
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
            ),
           
            Positioned(
              child: ContainerRedondeado(
                alturaPorcentaje: 0.70,
                color: Colors.white,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.all(screenHeight * 0.03),
                      child: Column(
                        children: [
                          CampoTextoRedondeado(
                            hintText: 'Nombre',
                            icono: Icons.person_outline,
                            keyboardType: TextInputType.text,
                            controller: nombreController,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          CampoTextoRedondeado(
                            hintText: 'Apellido Paterno',
                            icono: Icons.person_outline,
                            keyboardType: TextInputType.text,
                            controller: apellidoPaternoController,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          CampoTextoRedondeado(
                            hintText: 'Apellido Materno',
                            icono: Icons.person_outline,
                            keyboardType: TextInputType.text,
                            controller: apellidoMaternoController,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          CampoTextoRedondeado(
                            hintText: 'Correo Electrónico',
                            icono: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          CampoTextoRedondeado(
                            hintText: 'Contraseña',
                            icono: Icons.lock_outline,
                            obscureText: true,
                            controller: passwordController,
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextoLink(
                              textoPrincipal: "",
                              textoLink: "¿Olvidaste tu contraseña?",
                              onTap: () {
                                Navigator.pushNamed(context, '/recuperar');
                              },
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          authViewModel.cargando
                              ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.teal),
                              )
                              : BotonWidget(
                                texto: 'Regístrate',
                                coloresDegradado: const [
                                  Color.fromARGB(255, 18, 173, 162),
                                  Color.fromARGB(255, 14, 134, 232),
                                ],
                                width: 160,
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'RobotoMono',
                                ),
                                onPressed: () async {
                                  final nombre = nombreController.text.trim();
                                  final apellidoPaterno =
                                      apellidoPaternoController.text.trim();
                                  final apellidoMaterno =
                                      apellidoMaternoController.text.trim();
                                  final correo = emailController.text.trim();
                                  final password =
                                      passwordController.text.trim();

                                  if ([
                                    nombre,
                                    apellidoPaterno,
                                    apellidoMaterno,
                                    correo,
                                    password,
                                  ].any((s) => s.isEmpty)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Completa todos los campos obligatorios',
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  try {
                                    await authViewModel.registrarUsuario(
                                      nombre,
                                      apellidoPaterno,
                                      apellidoMaterno,
                                      correo,
                                      password,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Registro exitoso'),
                                      ),
                                    );
                                    // Esperar un pequeño intervalo antes de navegar
                                    Future.delayed(
                                      const Duration(seconds: 2),
                                      () {
                                        // Realizar la transición después del mensaje
                                        Navigator.pushReplacementNamed(
                                          context,
                                          AppRutas.recepcionista,
                                        );
                                      },
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                },
                              ),
                          SizedBox(height: screenHeight * 0.04),
                          Align(
                            alignment: Alignment.center,
                            child: TextoLink(
                              textoPrincipal: "¿Ya tienes cuenta? ",
                              textoLink: "Inicia sesión aquí",
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRutas.login,
                                );
                              },
                            ),
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
