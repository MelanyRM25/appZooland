import 'package:flutter/material.dart';
import 'package:zooland/views/admin/admin_page.dart';
import 'package:zooland/views/admin/lista_pacientes.dart';
import 'package:zooland/views/admin/registro_paciente.dart';
import 'package:zooland/views/auth/login_page.dart';
import 'package:zooland/views/auth/registro_page.dart';
import 'package:zooland/views/splash/splash_page.dart';
import 'package:zooland/views/veterinario/veterinario_page.dart';
import 'package:zooland/views/recepcionista/recepcionista_page.dart';
import 'package:zooland/views/welcome/welcome_page.dart';

class AppRutas {
  static const splash = '/';
  static const welcome = '/bienvenida';
  static const login = '/login';
  static const registro = '/registro';
  static const veterinario = '/veterinario';
  static const recepcionista = '/recepcionista';
  static const admin = '/admin';
  static const registro_paciente = '/registro_paciente';
  static const lista_paciente = '/lista_paciente';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => SplashScreen(),
    welcome: (context) => WelcomePage(),
    login: (context) => LoginPage(),
    registro: (context) => RegistroPage(),
    veterinario: (context) => VeterinarioPage(),
    recepcionista: (context) => RecepcionistaPage(),
    admin: (context) => AdminPage(),
    registro_paciente: (context) => RegistroPaciente(), // 👈 agregar registro paciente
    lista_paciente: (context) => ListaMascotasScreen(),
  };
}
