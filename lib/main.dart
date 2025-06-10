import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/viewmodels/auth_viewmodel.dart';
import 'package:zooland/viewmodels/mascota_viewmodel.dart';
import 'package:zooland/viewmodels/propietario_viewmodel.dart';
import 'package:zooland/viewmodels/usuario_viewmodel.dart';
import 'package:zooland/routes/app_rutas.dart';

void main() async {
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
      initialRoute: AppRutas.splash, // Cambiar a la ruta de Splash
      routes: AppRutas.routes,
    );
  }
}
