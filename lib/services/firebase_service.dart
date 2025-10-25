import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Pedir permisos (Android >= 13)
  static Future<void> requestPermission() async {
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  // Obtener token FCM
  static Future<String?> getToken() async {
    return await _messaging.getToken();
  }
}
