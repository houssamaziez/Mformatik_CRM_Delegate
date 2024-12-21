import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mformatic_crm_delegate/App/myapp.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the background service with the correct onStart function signature
  FlutterBackgroundService().configure(
    androidConfiguration: AndroidConfiguration(
      onStart:
          onServiceStarted, // onStart expects a function that takes ServiceInstance as argument
      autoStart: true, isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground:
          onServiceStarted, // onForeground also expects the same function signature
    ),
  );
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  runApp(const MyApp());
}

@pragma('vm:entry-point')
void onServiceStarted(ServiceInstance service) async {
  // Initialize notifications
  FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initializationSettings =
      InitializationSettings(android: androidSettings);
  await notificationsPlugin.initialize(initializationSettings);

  // Start WebSocket in the background
  connectWebSocket(notificationsPlugin);
}

void onBackground() {
  // Handle background operation here
  print("Service is running in the background");
}

void connectWebSocket(FlutterLocalNotificationsPlugin notificationsPlugin) {
  final channel = IOWebSocketChannel.connect(
      'ws://192.168.2.207:8080/?token=123456789'); // Replace with your WebSocket URL

  channel.stream.listen((message) async {
    final decodedMessage =
        message is List<int> ? utf8.decode(message) : message.toString();
    print("Received WebSocket message: $decodedMessage");

    // Show local notification
    const androidDetails = AndroidNotificationDetails(
      'background_websocket_channel',
      'WebSocket Notifications',
      channelDescription: 'Notifications for WebSocket messages',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'New WebSocket Message',
      decodedMessage,
      notificationDetails,
    );
  });
}
