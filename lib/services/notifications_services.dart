import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // Plugin para exibir notificações locais
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    // 1. Configurar Notificações Locais (o código que você mandou)
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    
    await _localNotificationsPlugin.initialize(settings);

    // 2. Configurar Firebase (Pedir permissão e pegar Token)
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings permissionSettings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (permissionSettings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Permissão de notificação concedida!');
    }

    // Pegar o token para você testar no site do Firebase
    String? token = await messaging.getToken();
    print("📢 Token do Dispositivo: $token");

    // 3. OUVINTE: Quando o app estiver ABERTO
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Recebi mensagem com app aberto: ${message.notification?.title}');

      // Se a mensagem tiver uma notificação, mostramos ela manualmente
      if (message.notification != null) {
        showNotification(
          id: message.hashCode,
          title: message.notification!.title ?? 'Sem título',
          body: message.notification!.body ?? 'Sem corpo',
        );
      }
    });
  }

  // Função auxiliar para exibir a notificação visualmente
  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'pokedex_channel', // ID do canal (deve ser único)
      'Pokedex Notificações', // Nome do canal que aparece nas config do Android
      channelDescription: 'Canal para alertas do app Pokémon',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(id, title, body, notificationDetails);
  }
}