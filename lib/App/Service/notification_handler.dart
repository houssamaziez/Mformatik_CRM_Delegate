import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'dart:ui';
 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
 
import 'package:socket_io_client/socket_io_client.dart' as web_socket_io;

import '../Controller/auth/auth_controller.dart';
import '../Controller/home/notification/notification_controller.dart';
import '../Model/web_socket_notifcation_model.dart';
import '../RouteEndPoint/EndPoint.dart';
import '../Util/Route/Go.dart';
import '../Util/global_expcetion_handler.dart';
import '../View/home/notifications/notifications_screen.dart';

import 'package:http/http.dart' as http;


 

class CriNotificationService {
  static const notificationId = 4423424234;
  static const String channelDescription = 'This channel is used for important notifications';
  static const String channelId = 'high_importance_channel';
  static const String channelName = 'High Importance Notifications';

  static final FlutterBackgroundService flutterBgInstance = FlutterBackgroundService();
  static const String notificationIcon = '@mipmap/ic_launcher';

  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin()
    ..initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
          notificationIcon,
        ),
      ),
      onDidReceiveNotificationResponse: notificationResponse,
      onDidReceiveBackgroundNotificationResponse: notificationResponse,
    );

  static const oneNotificationChannel = AndroidNotificationChannel(
    channelId,
    channelName,
    description: '$channelDescription.',
    importance: Importance.max,
    playSound: true,
    showBadge: true,
  );
  static const serviceNotificationChannel = AndroidNotificationChannel(
    '${channelId}1',
    '${channelName}1',
    description: '${channelDescription}1.',
    importance: Importance.max,
  );

  static AndroidConfiguration androidBackgroundConfig = AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: false,
      autoStartOnBoot: true,
      foregroundServiceNotificationId: notificationId,
      foregroundServiceTypes: [AndroidForegroundType.dataSync]);

  static AndroidConfiguration androidForgroundConfig = AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      autoStartOnBoot: true,
      foregroundServiceNotificationId: notificationId,
      foregroundServiceTypes: [AndroidForegroundType.dataSync]);

  static IosConfiguration iosConfig = IosConfiguration();

  @pragma('vm:entry-point')
  static Future<void> initializeService({bool isBackground = true}) async {
    // SharedPreferences prefs = await Prefs.init();
  await GetStorage.init();
    if (token.read("token") != null &&token.read("token")!.isNotEmpty) {
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();

      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(serviceNotificationChannel);

      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(oneNotificationChannel);

      await flutterBgInstance.configure(
        androidConfiguration: isBackground ? androidBackgroundConfig : androidForgroundConfig,
        iosConfiguration: iosConfig,
      );

      flutterBgInstance.startService();
    }
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground() async {
    WidgetsFlutterBinding.ensureInitialized();
    return true;
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          notificationId,
          'Nofitication service',
          'running...',
          NotificationDetails(
            android: AndroidNotificationDetails(
              serviceNotificationChannel.id,
              'MY FOREGROUND SERVICE',
              icon: notificationIcon,
              ongoing: true,
              priority: Priority.low,
              actions: [
                const AndroidNotificationAction(
                  'cancele',
                  'cancele',
                ),
              ],
            ),
          ),
        );
      }

      getNotifications(service);

      service.on('setAsBackground').listen((event) {
        service.setAsBackgroundService();
      });

      service.on('stopService').listen((event) {
        service.stopSelf();
      });

      service.on('setAsForeground').listen((event) async {
        const MethodChannel channel = MethodChannel(
          'id.flutter/background_service_android_bg',
          JSONMethodCodec(),
        );
        await channel.invokeMethod("setForegroundMode", {
          'value': true,
        });
      });
    }

    // service.on('makeItBackground').listen((
    //   event,
    // ) async {
    //   service.setAsBackgroundService();
    // });
  }

  @pragma('vm:entry-point')
  static stopService() async {
    flutterBgInstance.invoke('stopService');
  }

  @pragma('vm:entry-point')
  static p1() async {
    flutterBgInstance.invoke('setAsBackground');
  }

  @pragma('vm:entry-point')
  static p2() async {
    flutterBgInstance.invoke('setAsForeground');
  }

  @pragma('vm:entry-point')
  static void _showNotification(WebSocketNotificationModel notificationDetails) {
    flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000000),
      'New ${notificationDetails.entity}',
      'By : ${notificationDetails.creator.username}',
      payload:
          '{"ids": ${notificationDetails.data.ids}, "entity": "${notificationDetails.entity}", "companyId": ${notificationDetails.data.companyId},"annexId": ${notificationDetails.data.annexId}}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          oneNotificationChannel.id,
          oneNotificationChannel.name,
          channelDescription: oneNotificationChannel.description,
          importance: Importance.high,
          priority: Priority.max,
          color: Colors.deepOrange,
          channelShowBadge: true,
          enableLights: true,

          //  sound: const RawResourceAndroidNotificationSound(notificationSound),
          // playSound: true,
          icon: notificationIcon,
        ),
      ),
    );
  }

  @pragma('vm:entry-point')
  static void _showNotificationMultiEntities(WebSocketNotificationModel notificationDetails) {
    flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000000),
      'New ${notificationDetails.entity}s',
      'By : ${notificationDetails.creator.username}',
      payload:
          '{"ids": ${notificationDetails.data.ids}, "entity": "${notificationDetails.entity}", "companyId": ${notificationDetails.data.companyId},"annexId": ${notificationDetails.data.annexId}}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          oneNotificationChannel.id,
          oneNotificationChannel.name,
          channelDescription: oneNotificationChannel.description,
          importance: Importance.high,
          priority: Priority.max,
          color: Colors.deepOrange,
          channelShowBadge: true,
          enableLights: true,

          //  sound: const RawResourceAndroidNotificationSound(notificationSound),
          // playSound: true,
          icon: notificationIcon,
        ),
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> setServiceToBackground(AndroidServiceInstance service) async {
    await service.setAsBackgroundService();
  }

  @pragma('vm:entry-point')
  static Future<void> getNotifications(AndroidServiceInstance service) async {
      await GetStorage.init();
      await dotenv.load(fileName: ".env");
    try {
      // debugPrint("i'm inside download fucntion");
     String WEBSOCKET_URL = dotenv.get('urlHost');
      // await EnvHelper.loadAppEnvFile();
      String webSocketUrl = WEBSOCKET_URL;
      var socket = web_socket_io.io(
        WEBSOCKET_URL,
        web_socket_io.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .setAuth({"token": token.read("token")})
            .build(),
      );
      socket.connect();
      socket.onConnect((data) {

        Logger().i(data);
        print('Connected to server');

        Logger().i( 'Connected to server');

      });
      socket.onDisconnect((data) {
        print('Disconnected to server');


        Logger().i(data);
      });
      socket.on('notification', (data) {
        Logger  ().i(data);
// Go.to(Get.context,NotificationScreenAll());
 var data2 = data  ;
     if(data2 is Map) {

        Logger().i( "data is map");

     
     }
     else {
   data.forEach((  value) {
          _showNotification2("New Mission", "Details" , Random().nextInt(10000000));
Logger().i( value['id']);
 editNotificationStatus(notificationId: value['id'], status:2);  
        });
        Logger().i( "data is list");
     }
        if (data['data']['id'] is List) {
          List<int> ids = (data['data']['id'] as List).map<int>((e) => e as int).toList();
          
 editNotificationStatus(notificationId: data['data']['id'], status:2);  
          service.invoke('refreshNotificationsCount', {"count": ids.length});
          _showNotificationMultiEntities(WebSocketNotificationModel.fromJson(data));
        } else {
          _showNotification(WebSocketNotificationModel.fromJson(data));
          service.invoke('refreshNotificationsCount', {"count": 1});
        }
      });
      socket.onError((data) {
        print("ws data ==>$data");
        Logger().e(data);
      });
    } catch (e, stackTrace) {
      GlobalExceptionHandler.handle(exception: e, exceptionStackTrace: stackTrace);
    }
  }

  @pragma('vm:entry-point')

static Future<void> editNotificationStatus({required int notificationId, required int status}) async {
    final response = await http.put(Uri.parse('${Endpoint.apiNotifications}/$notificationId/to/$status'), headers:  {
      'x-auth-token': token.read("token").toString(),
    });
    Logger().e(response.body);
    Logger().e(response.statusCode);

if (response.statusCode == 204) {
  
 
}
    // await ResponseHandler.processResponse(response);
  }

  @pragma('vm:entry-point')

static void _showNotification2(String title, String subtitle , int id) {
  Logger().i("Displaying notification: $title - $subtitle");
  
  // Example using flutter_local_notifications:
  // Replace this with your actual notification logic
  flutterLocalNotificationsPlugin.show(
    id,
    title, 
    subtitle, 
    NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id', // Channel ID
        'channel_name', // Channel Name
        importance: Importance.high,
        priority: Priority.high,
      ),
      // iOS: IOSNotificationDetails(),
    ),
  );
}

  @pragma('vm:entry-point')
  static void notificationResponse(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      Logger( ).i(notificationResponse.payload);
      var payload = notificationResponse.payload;
      if (payload != null) {
        Map<String, dynamic> parsedData = jsonDecode(payload);
  Go.to(Get.context,NotificationScreenAll());
Logger().i( parsedData);
        // RoutingManager.router.pushNamed(RoutingManager.missionDetailsScreen, extra: int.parse(parsedData['id']));
      }
    }
    switch (notificationResponse.actionId) {
      case 'cancele':
        stopService();
    }
  }
}

void makeServiceForeground() async {
  try {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke(
        "makeItForeground",
      );
    }
  } catch (error) {
    rethrow;
  }
}

void makeServiceBackground() async {
  try {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();
    if (isRunning) {
      service.invoke(
        "makeItBackground",
      );
    }
  } catch (error) {
    rethrow;
  }
}
