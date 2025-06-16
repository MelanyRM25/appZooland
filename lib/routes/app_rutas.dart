import 'package:flutter/material.dart';
import 'package:zooland/views/admin/ajustes_page.dart';
import 'package:zooland/views/admin/lista_pacientes.dart';
import 'package:zooland/views/admin/mascota_page.dart';
import 'package:zooland/views/admin/menu_page.dart';
import 'package:zooland/views/admin/propietarios_page.dart';
import 'package:zooland/views/admin/registro_paciente.dart';
import 'package:zooland/views/admin/scaneo_qr.dart';
import 'package:zooland/views/admin/usuarios_page.dart';
import 'package:zooland/views/auth/login_page.dart';
import 'package:zooland/views/auth/registro_page.dart';
import 'package:zooland/views/propietario/lista_mascotas_propietario.dart';
import 'package:zooland/views/propietario/mascota_propietario_page.dart';
import 'package:zooland/views/propietario/scannerQR_propietario.dart';
import 'package:zooland/views/splash/splash_page.dart';
import 'package:zooland/views/splash/tipo_usuario_page.dart';
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
  static const usuarios = '/usuarios'; // 👈 agregar ajustes
  static const ajustes = '/ajustes';
  static const registro_paciente = '/registro_paciente';
  static const lista_paciente = '/lista_paciente';
  static const menu = '/menu';
  static const mascota_page = '/mascota_page';
  static const escaner_qr = '/escaner_qr';
  static const lista_propietarios = '/lista_propietarios';
  static const tipo_usuario = '/tipo_usuario';
  static const escaner_qr_propietario = '/escaner_qr_propietario';
  static const lista_mascotas_propietario = '/lista_mascotas_propietario';
  static const mascota_propietario = '/mascota_propietario';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => SplashScreen(),
    welcome: (context) => WelcomePage(),
    login: (context) => LoginPage(),
    registro: (context) => RegistroPage(),
    veterinario: (context) => VeterinarioPage(),
    recepcionista: (context) => RecepcionistaPage(),
    registro_paciente: (context) => RegistroPaciente(), // 👈 agregar registro paciente
    lista_paciente: (context) => ListaMascotasScreen(),
    menu: (context) => MenuPage(),
    usuarios: (context) => UsuariosPage(),
    ajustes: (context) => AjustesPage(),
    mascota_page: (context) => MascotaPage(),
    escaner_qr: (context) => EscanerQRPage(),
    lista_propietarios: (context) => ListaPropietariosPage(),
     tipo_usuario: (context) =>  TipoUsuarioPage(),
    escaner_qr_propietario: (context) =>  EscanerQRPropietarioPage(),
    lista_mascotas_propietario: (context) =>  ListaMascotasPropietarioPage(mascotas: [],), // si deseas usar navegación por nombre
    mascota_propietario: (context) =>  MascotaPropietarioPage(),
  };
}
