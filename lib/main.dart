import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

import 'App/myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  await FlutterBackgroundService().configure(
    androidConfiguration: AndroidConfiguration(
        foregroundServiceNotificationId: 1,
        initialNotificationContent: 'Running in the background',
        initialNotificationTitle: 'CRI Reporting',
        onStart: onServiceStarted,
        autoStartOnBoot: true,
        autoStart: true,
        isForegroundMode: true,
        foregroundServiceTypes: [
          AndroidForegroundType.dataSync,
        ]),
    iosConfiguration: IosConfiguration(
      onForeground: onServiceStarted,
    ),
  );

  runApp(const MyApp());
}

@pragma('vm:entry-point')
void onServiceStarted(ServiceInstance service) async {
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }
  // Initialize notifications
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettings =
      InitializationSettings(android: androidSettings);
  await notificationsPlugin.initialize(initializationSettings);

  // Start Socket.IO connection in the background
  connectSocketIO(notificationsPlugin);
}

void connectSocketIO(FlutterLocalNotificationsPlugin notificationsPlugin) {
  // Connect to the Socket.IO server
  final socket = IO.io(
    'http://192.168.2.207:8080', // Replace with your server URL
    IO.OptionBuilder()
        .setTransports(['websocket']) // Use WebSocket transport
        .enableAutoConnect()
        .setQuery({'token': '123456789'}) // Send token as query parameter
        .build(),
  );

  // Listen for connection
  socket.onConnect((_) {
    debugPrint("Socket.IO connected");
  });

  // Listen for incoming messages
  socket.on('message', (data) async {
    final decodedMessage =
        data is List<int> ? utf8.decode(data) : data.toString();
    debugPrint("Received Socket.IO message: $decodedMessage");

    // Show local notification
    const androidDetails = AndroidNotificationDetails(
      'background_socketio_channel',
      'Socket.IO Notifications',
      channelDescription: 'Notifications for Socket.IO messages',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'New Socket.IO Message',
      decodedMessage,
      notificationDetails,
    );
  });

  // Listen for connection errors
  socket.onConnectError((error) {
    debugPrint("Socket.IO connection error: $error");
  });

  // Listen for disconnection
  socket.onDisconnect((_) {
    debugPrint("Socket.IO disconnected");
  });
}
