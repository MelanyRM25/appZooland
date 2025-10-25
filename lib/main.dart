import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Localización
import 'package:flutter_localizations/flutter_localizations.dart';

// Timezone para notificaciones locales programadas
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// ViewModels con alias
import 'package:zooland/viewmodels/anamnesis_viewmodel.dart' as anamnesis_vm;
import 'package:zooland/viewmodels/auth_viewmodel.dart' as auth_vm;
import 'package:zooland/viewmodels/datos_fisiologicos_viewmodel.dart' as datos_vm;
import 'package:zooland/viewmodels/desparasitacion_viewmodel.dart' as desparasitacion_vm;
import 'package:zooland/viewmodels/mascota_viewmodel.dart' as mascota_vm;
import 'package:zooland/viewmodels/propietario_viewmodel.dart' as propietario_vm;
import 'package:zooland/viewmodels/usuario_viewmodel.dart' as usuario_vm;
import 'package:zooland/viewmodels/vacuna_viewmodel.dart' as vacuna_vm;

// Rutas
import 'package:zooland/routes/app_rutas.dart';

/// Instancia global de notificaciones locales
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Handler para mensajes en segundo plano (Firebase Push)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Mensaje en segundo plano: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔹 Inicializar Firebase
  await Firebase.initializeApp();

  // Registrar handler en segundo plano
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 🔹 Inicializar Supabase
  await Supabase.initialize(
    url: 'https://uxwwkzzjgxyzkjztsidb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV4d3drenpqZ3h5emtqenRzaWRiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDM2MDI4MzIsImV4cCI6MjA1OTE3ODgzMn0.pXTmasQ4h7VR73DWApjxe-pyKjOje8NMhQakHrL2EYY',
  );

  // 🔹 Inicializar zona horaria
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/La_Paz'));

  // 🔹 Inicializar plugin de notificaciones locales
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 🔹 Configurar Firebase Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Solicitar permisos en Android 13+
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print("🔔 Permisos de notificación: ${settings.authorizationStatus}");

  // Obtener token FCM del dispositivo
  String? token = await messaging.getToken();
  print("🔥 Token FCM: $token");

  // Listener para mensajes en foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 Notificación en foreground: ${message.notification?.title}");

    if (message.notification != null) {
      flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title,
        message.notification!.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'zooland_channel',
            'Zooland Notificaciones',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    }
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => auth_vm.AuthViewModel()),
        ChangeNotifierProvider(create: (_) => usuario_vm.UsuarioViewModel()),
        ChangeNotifierProvider(create: (_) => propietario_vm.PropietarioViewModel()),
        ChangeNotifierProvider(create: (_) => mascota_vm.MascotaViewModel()),
        ChangeNotifierProvider(create: (_) => datos_vm.DatosFisiologicosViewModel()),
        ChangeNotifierProvider(create: (_) => anamnesis_vm.AnamnesisViewModel()),
        ChangeNotifierProvider(create: (_) => vacuna_vm.VacunaViewModel()),
        ChangeNotifierProvider(create: (_) => desparasitacion_vm.DesparasitacionViewModel()),
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

      // Soporte para español
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'),
      ],
      locale: const Locale('es', 'ES'),

      initialRoute: AppRutas.splash,
      routes: AppRutas.routes,
    );
  }
}
