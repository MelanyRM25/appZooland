import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Importación necesaria para localización
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/viewmodels/anamnesis_viewmodel.dart';
import 'package:zooland/viewmodels/auth_viewmodel.dart';
import 'package:zooland/viewmodels/datos_fisiologicos_viewmodel.dart';
import 'package:zooland/viewmodels/desparasitacion_viewmodel.dart';
import 'package:zooland/viewmodels/mascota_viewmodel.dart';
import 'package:zooland/viewmodels/propietario_viewmodel.dart';
import 'package:zooland/viewmodels/usuario_viewmodel.dart';
import 'package:zooland/routes/app_rutas.dart';
import 'package:zooland/viewmodels/vacuna_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Asegura inicialización correcta
  
  // INICIALIZAMOS SUPABASE
  await Supabase.initialize(
    url: 'https://uxwwkzzjgxyzkjztsidb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV4d3drenpqZ3h5emtqenRzaWRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2MDI4MzIsImV4cCI6MjA1OTE3ODgzMn0.pXTmasQ4h7VR73DWApjxe-pyKjOje8NMhQakHrL2EYY',
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => UsuarioViewModel()),
        ChangeNotifierProvider(create: (_) => PropietarioViewModel()),
        ChangeNotifierProvider(create: (_) => MascotaViewModel()),
        ChangeNotifierProvider(create: (_) => DatosFisiologicosViewModel()),
        ChangeNotifierProvider(create: (_) => AnamnesisViewModel()),
        ChangeNotifierProvider(create: (_) => VacunaViewModel()),
        ChangeNotifierProvider(create: (_) => DesparasitacionViewModel()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zooland',
      theme: ThemeData(primarySwatch: Colors.teal),
      
      // Agregamos soporte para localización en español:
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
      ],
      locale: const Locale('es', 'ES'), // Forzar idioma español
      
      initialRoute: AppRutas.splash,
      routes: AppRutas.routes,
    );
  }
}
