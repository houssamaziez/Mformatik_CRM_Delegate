import 'dart:async';
import 'dart:convert';
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
import 'package:mformatic_crm_delegate/App/Service/ws_notification/const.dart';
import 'package:socket_io_client/socket_io_client.dart' as web_socket_io;
import '../../Controller/auth/auth_controller.dart';
import '../../Model/web_socket_notifcation_model.dart';
import '../../RouteEndPoint/EndPoint.dart';
import '../../Util/global_expcetion_handler.dart';

import 'package:http/http.dart' as http;

import '../../myapp.dart'; 
class CriNotificationService {  static final FlutterBackgroundService flutterBgInstance = FlutterBackgroundService();

  static final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin()
    ..initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings(
        ConstWsNotification.  notificationIcon,
        ),
      ),
      onDidReceiveNotificationResponse:ConstWsNotification. notificationResponse,
      onDidReceiveBackgroundNotificationResponse:ConstWsNotification. notificationResponse,
    );
 
  static   String? storedLanguage = storage.read<String>('selected_language'); 
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
          ?.createNotificationChannel(ConstWsNotification.serviceNotificationChannel);

      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(ConstWsNotification.oneNotificationChannel);

      await flutterBgInstance.configure(
        androidConfiguration:  AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,initialNotificationContent:"You are ready to receive the missions".tr,
      autoStartOnBoot: true, initialNotificationTitle:  "Connected".tr,
      foregroundServiceNotificationId:ConstWsNotification. notificationId2,
      foregroundServiceTypes: [AndroidForegroundType.dataSync], 
      ),
        iosConfiguration: iosConfig,
      );

      flutterBgInstance.startService();
    }
  }

 
  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
    
      }
      initWS(service);
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
 
  }

  @pragma('vm:entry-point')
  static stopService() async {
    flutterBgInstance.invoke('stopService');
  }
 

  @pragma('vm:entry-point')
  static void _showNotification(WebSocketNotificationModel notificationDetails) {
    flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000000),
      'New ${notificationDetails.entity}',
      'By : ${notificationDetails.creator!.username}',
      payload:
          '{"ids": ${notificationDetails.data!.ids}, "entity": "${notificationDetails.entity}", "companyId": ${notificationDetails.data!.companyId},"annexId": ${notificationDetails.data!.annexId}}',
      NotificationDetails(
        android: AndroidNotificationDetails(
        ConstWsNotification.  oneNotificationChannel.id,
         ConstWsNotification. oneNotificationChannel.name,
          channelDescription:ConstWsNotification. oneNotificationChannel.description,
          importance: Importance.high,
          priority: Priority.max,
          color: Colors.deepOrange,
          channelShowBadge: true,
          enableLights: true,

          //  sound: const RawResourceAndroidNotificationSound(notificationSound),
          // playSound: true,
          icon:ConstWsNotification. notificationIcon,
        ),
      ),
    );
  }

  @pragma('vm:entry-point')
  static void _showNotificationMultiEntities(WebSocketNotificationModel notificationDetails) {
    flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000000),
      'New ${notificationDetails.entity}s',
      'By : ${notificationDetails.creator!.username}',
      payload:
          '{"ids": ${notificationDetails.data!.ids}, "entity": "${notificationDetails.entity}", "companyId": ${notificationDetails.data!.companyId},"annexId": ${notificationDetails.data!.annexId}}',
      NotificationDetails(
        android: AndroidNotificationDetails(
        ConstWsNotification.  oneNotificationChannel.id,
        ConstWsNotification.  oneNotificationChannel.name,
          channelDescription:ConstWsNotification. oneNotificationChannel.description,
          importance: Importance.high,
          priority: Priority.max,
          color: Colors.deepOrange,
          channelShowBadge: true,
          enableLights: true,

          //  sound: const RawResourceAndroidNotificationSound(notificationSound),
          // playSound: true,
          icon:ConstWsNotification. notificationIcon,
        ),
      ),
    );
  }
 

  @pragma('vm:entry-point')
  static Future<void> initWS(AndroidServiceInstance service) async {
      await GetStorage.init();
      await dotenv.load(fileName: ".env");
    try {
      // debugPrint("i'm inside download fucntion");
     String WEBSOCKET_URL = dotenv.get('urlHost');
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
          
 editNotificationStatus(notificationId: data['data']['id'].first, status:2);  
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


  }
 