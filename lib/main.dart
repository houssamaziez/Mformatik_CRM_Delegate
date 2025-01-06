import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';

import 'App/Controller/auth/auth_controller.dart';
import 'App/myapp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  print(token.read("token"));

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
  var socket = IO.io(
    'http://192.168.2.88:5000',
    IO.OptionBuilder()
        .enableAutoConnect()
        .setTransports(['websocket']).setAuth({
      'token':
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6OSwidXNlcm5hbWUiOiJ0ZXN0RGVsZWdhdGUiLCJpc0FjdGl2ZSI6dHJ1ZSwicm9sZUlkIjo0LCJhbm5leElkIjpudWxsLCJjb21wYW55SWQiOm51bGwsInBlcnNvbiI6eyJpZCI6NCwiZmlyc3ROYW1lIjoiaG91c3NhbSAgZWRkaW5lICIsImxhc3ROYW1lIjoiYXppZXoiLCJlbWFpbCI6bnVsbCwicGhvbmUiOm51bGwsInBob25lMDIiOm51bGwsImFkZHJlc3MiOm51bGwsImdlbmRlciI6bnVsbCwiaW1nIjpudWxsLCJ1c2VySWQiOjksImNyZWF0ZWRBdCI6IjIwMjQtMTItMDJUMDg6MzU6NDAuMDAwWiIsInVwZGF0ZWRBdCI6IjIwMjQtMTItMTBUMTQ6NTY6MjQuMDAwWiJ9LCJpYXQiOjE3MzYwNzUzNzB9.pL9u71J5DXYlHy5WV5CoqSnMS1eJDsmfc-UvEqxbSbk",
    }).build(),
  );

  // Listen for connection
  socket.onConnect((_) {
    debugPrint("Socket.IO connected");

    // Example: Emit an event after connection
    // socket.emit('join_room', {'room': 'exampleRoom'});
  });

  // Listen for incoming notifications
  socket.on('notification', (data) async {
    // final decodedMessage =
    //     data is List<int> ? utf8.decode(data) : data.toString();
    print("Received notification: $data");

    // Show local notification
    const androidDetails = AndroidNotificationDetails(
      'socketio_notifications',
      'Socket.IO Notifications',
      channelDescription: 'Channel for Socket.IO notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);
    await notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'New Notification',
      data['title'],
      notificationDetails,
    );
  });

  // Listen for disconnection
  socket.onDisconnect((_) {
    debugPrint("Socket.IO disconnected");
    Fluttertoast.showToast(
      msg: "Disconnected from server",
      backgroundColor: Colors.orange,
      textColor: Colors.white,
    );
  });

  // Handle connection errors
  socket.onConnectError((error) {
    debugPrint("Socket.IO connection error: $error");
    Fluttertoast.showToast(
      msg: "Connection error: $error",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  });
}
