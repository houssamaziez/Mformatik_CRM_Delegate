// // import 'package:flutter_background_service/flutter_background_service.dart';
// // import 'package:web_socket_channel/io.dart';
// // import 'dart:convert';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// // @pragma('vm:entry-point')
// // void onServiceStarted(ServiceInstance service) async {
// //   // Initialize notifications
// //   FlutterLocalNotificationsPlugin notificationsPlugin =
// //       FlutterLocalNotificationsPlugin();
// //   const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
// //   const initializationSettings =
// //       InitializationSettings(android: androidSettings);
// //   await notificationsPlugin.initialize(initializationSettings);

// //   // Start WebSocket in the background
// //   connectWebSocket(notificationsPlugin);
// // }

// // void onBackground() {
// //   // Handle background operation here
// //   print("Service is running in the background");
// // }

// // void connectWebSocket(FlutterLocalNotificationsPlugin notificationsPlugin) {
// //   final channel = IOWebSocketChannel.connect(
// //       'ws://192.168.2.207:8080/?token=123456789'); // Replace with your WebSocket URL

// //   channel.stream.listen((message) async {
// //     print(message);
// //     final decodedMessage =
// //         message is List<int> ? utf8.decode(message) : message.toString();
// //     print("Received WebSocket message: $decodedMessage");

// //     // Show local notification
// //     const androidDetails = AndroidNotificationDetails(
// //       'background_websocket_channel',
// //       'WebSocket Notifications',
// //       channelDescription: 'Notifications for WebSocket messages',
// //       importance: Importance.high,
// //       priority: Priority.high,
// //       ticker: 'New WebSocket Message',
// //     );

// //     const notificationDetails = NotificationDetails(
// //       android: androidDetails,
// //     );
// //     await notificationsPlugin.show(
// //       DateTime.now().millisecondsSinceEpoch ~/ 1000,
// //       'New WebSocket Message',
// //       decodedMessage,
// //       notificationDetails,
// //     );
// //   });
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:web_socket_channel/io.dart';
// import 'dart:convert';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// @pragma('vm:entry-point')
// void onServiceStarted(ServiceInstance service) async {
//   // Initialize notifications
//   FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//   const initializationSettings =
//       InitializationSettings(android: androidSettings);

//   await notificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (details) {
//       // Handle notification click in the background
//       print("Notification clicked with payload: ${details.payload}");
//     },
//   );

//   // Start WebSocket in the background
//   connectWebSocket(notificationsPlugin);
// }

// void onBackground() {
//   // Handle background operation here
//   print("Service is running in the background");
// }

// void connectWebSocket(FlutterLocalNotificationsPlugin notificationsPlugin) {
//   final channel = IOWebSocketChannel.connect(
//       'ws://192.168.2.207:8080/?token=123456789'); // Replace with your WebSocket URL

//   channel.stream.listen((message) async {
//     print(message);
//     final decodedMessage =
//         message is List<int> ? utf8.decode(message) : message.toString();
//     print("Received WebSocket message: $decodedMessage");

//     // Show local notification
//     const androidDetails = AndroidNotificationDetails(
//       'background_websocket_channel',
//       'WebSocket Notifications',
//       channelDescription: 'Notifications for WebSocket messages',
//       importance: Importance.high,
//       priority: Priority.high,
//       ticker: 'New WebSocket Message',
//     );

//     const notificationDetails = NotificationDetails(
//       android: androidDetails,
//     );
//     await notificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       'New WebSocket Message',
//       decodedMessage,
//       notificationDetails,
//       payload: decodedMessage, // Attach the current date as the payload
//     );
//   });
// }

// class HomeScreennot extends StatefulWidget {
//   const HomeScreennot({Key? key}) : super(key: key);

//   @override
//   State<HomeScreennot> createState() => _HomeScreennotState();
// }

// class _HomeScreennotState extends State<HomeScreennot> {
//   final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   final List<Map<String, String>> notifications =
//       []; // List to store notifications with title and body

//   @override
//   void initState() {
//     super.initState();
//   }

//   // Function to show a notification (for testing purposes)
//   void showNotification(String title, String body) async {
//     const androidDetails = AndroidNotificationDetails(
//       'test_channel_id',
//       'Test Channel',
//       channelDescription: 'Channel for testing notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//     );

//     const notificationDetails = NotificationDetails(android: androidDetails);

//     await notificationsPlugin.show(
//       DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       title,
//       body,
//       notificationDetails,
//       payload: body,
//     );

//     setState(() {
//       notifications
//           .add({'title': title, 'body': body}); // Add to notifications list
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications History'),
//         actions: [],
//       ),
//       body: notifications.isEmpty
//           ? const Center(
//               child: Text('No notifications received yet.'),
//             )
//           : ListView.builder(
//               itemCount: notifications.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(notifications[index]['title']!),
//                   subtitle: Text(notifications[index]['body']!),
//                   onTap: () {
//                     // Navigate to details screen when tapping a notification
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => NotificationDetailsScreen(
//                           payload: notifications[index]['title'],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }

// class NotificationDetailsScreen extends StatelessWidget {
//   final String? payload;

//   const NotificationDetailsScreen({Key? key, this.payload}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notification Details'),
//       ),
//       body: Center(
//         child: Text(
//           payload != null
//               ? 'Notification Body: $payload'
//               : 'No details available.',
//           style: const TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
