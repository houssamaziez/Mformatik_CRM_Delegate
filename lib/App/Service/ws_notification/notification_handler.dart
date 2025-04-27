import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
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

class CriNotificationService {
  static final FlutterBackgroundService flutterBgInstance =
      FlutterBackgroundService();
  static final player = AudioPlayer();

  static final flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin()
        ..initialize(
          const InitializationSettings(
            android: AndroidInitializationSettings(
              ConstWsNotification.notificationIcon,
            ),
          ),
          onDidReceiveNotificationResponse:
              ConstWsNotification.notificationResponse,
          onDidReceiveBackgroundNotificationResponse:
              ConstWsNotification.notificationResponse,
        );

  static String? storedLanguage = storage.read<String>('selected_language');
  static IosConfiguration iosConfig = IosConfiguration();

  @pragma('vm:entry-point')
  static Future<void> initializeService({bool isBackground = true}) async {
    // SharedPreferences prefs = await Prefs.init();
    await GetStorage.init();
    if (token.read("token") != null && token.read("token")!.isNotEmpty) {
      WidgetsFlutterBinding.ensureInitialized();
      DartPluginRegistrant.ensureInitialized();

      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
              ConstWsNotification.serviceNotificationChannel);

      await flutterBgInstance.configure(
        androidConfiguration: AndroidConfiguration(
          onStart: onStart,
          autoStart: true,
          isForegroundMode: true,
          initialNotificationContent:
              "You are ready to receive the missions".tr,
          autoStartOnBoot: true,
          initialNotificationTitle: "Connected".tr,
          foregroundServiceNotificationId: ConstWsNotification.notificationId2,
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
      // Create a notification for the foreground service
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'foreground_channel_id', // Unique channel ID
          'Foreground Service', // Channel name
          channelDescription: 'This is the foreground service notification',
          importance: Importance.high,
          priority: Priority.high,
          icon: ConstWsNotification.notificationIcon,
        ),
      );

      // Start the service in foreground mode immediately
      flutterLocalNotificationsPlugin.show(
        ConstWsNotification.notificationId2, // Notification ID
        "Service Running", // Notification title
        "The service is running in the background.", // Notification body
        notificationDetails,
      );

      service.setAsForegroundService();

      // Additional service logic
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
  static playsounNotification() async {
    try {
      // Assuming the file is located in the assets folder
      await player.play(AssetSource('notification_track.wav'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  @pragma('vm:entry-point')
  static void _showNotification(
      WebSocketNotificationModel notificationDetails) async {
    final translatedBody = (storage.read<String>('selected_language') == 'en'
            ? 'By : '.tr
            : (storage.read<String>('selected_language') == 'fr'
                ? 'Par : '.tr
                : 'بواسطة : ')) +
        '${notificationDetails.creator!.username}';

    flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000000),
      returnTitle(notificationDetails.entity!),
      translatedBody,
      payload:
          '{"ids": ${notificationDetails.data!.ids}, "entity": "${notificationDetails.entity}", "companyId": ${notificationDetails.data!.companyId},"annexId": ${notificationDetails.data!.annexId}}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          ConstWsNotification.oneNotificationChannel.id,
          ConstWsNotification.oneNotificationChannel.name,
          channelDescription:
              ConstWsNotification.oneNotificationChannel.description,
          importance: Importance.high,
          priority: Priority.max,
          color: Colors.deepOrange,
          channelShowBadge: true,
          enableLights: true,
          playSound: false,
          icon: ConstWsNotification.notificationIcon,
        ),
      ),
    );
  }

  @pragma('vm:entry-point')
  static void _showNotificationMultiEntities(
      WebSocketNotificationModel notificationDetails) {
    final translatedTitle = "New mission notification".tr;
    final translatedBody = (storage.read<String>('selected_language') == 'en'
            ? 'By : '.tr
            : (storage.read<String>('selected_language') == 'fr'
                ? 'Par : '.tr
                : 'بواسطة : ')) +
        '${notificationDetails.creator!.username}';
    flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000000),
      returnTitle(notificationDetails.entity!),
      translatedBody + '${notificationDetails.creator!.username}',
      payload:
          '{"ids": ${notificationDetails.data!.ids}, "entity": "${notificationDetails.entity}", "companyId": ${notificationDetails.data!.companyId},"annexId": ${notificationDetails.data!.annexId}}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          ConstWsNotification.oneNotificationChannel.id,
          ConstWsNotification.oneNotificationChannel.name,
          channelDescription:
              ConstWsNotification.oneNotificationChannel.description,
          importance: Importance.high,
          priority: Priority.max,
          color: Colors.deepOrange,
          channelShowBadge: true, playSound: false,
          enableLights: true,

          //  sound: const RawResourceAndroidNotificationSound(notificationSound),
          // playSound: true,
          icon: ConstWsNotification.notificationIcon,
        ),
      ),
    );
  }

  @pragma('vm:entry-point')
  static Future<void> initWS(AndroidServiceInstance service) async {
    await GetStorage.init();
    await dotenv.load(fileName: ".env");
    try {
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

        Logger().i('Connected to server');
      });
      socket.onDisconnect((data) {
        print('Disconnected to server');

        Logger().i(data);
      });

      // ____________________________ Notification Receiving ____________________________
      socket.on('notification', (data) {
        Logger().i(data);
        var countNotificationData = data['count'];
        var data2 = data;
        if (data2 is Map) {
          Logger().i("data is map");
        } else {
          data.forEach((value) {
            _showNotification2(
                returnTitle(value['entity']),
                (storage.read<String>('selected_language') == 'en'
                    ? 'tap to check'.tr
                    : (storage.read<String>('selected_language') == 'fr'
                        ? 'Appuyez pour vérifier'.tr
                        : 'اضغط للتحقق')),
                Random().nextInt(10000000));
            editNotificationStatus();
          });
          Logger().i("data is list");
        }
        if (countNotificationData != null) {
          editNotificationStatus();

          if (countNotificationData > 3) {
            String title;
            String body = (storage.read<String>('selected_language') == 'en'
                ? 'Tap to check'.tr
                : (storage.read<String>('selected_language') == 'fr'
                    ? 'Appuyez pour vérifier'.tr
                    : 'اضغط للتحقق'));

            if (storage.read<String>('selected_language') == 'en') {
              title = "You have $countNotificationData new notifications";
            } else if (storage.read<String>('selected_language') == 'fr') {
              title =
                  "Vous avez $countNotificationData nouvelles notifications";
            } else {
              title = "يوجد $countNotificationData إشعارات جديدة";
            }

            _showNotification2(
              title.tr,
              body,
              Random().nextInt(10000000),
            );
          } else {
            data["rows"].forEach((value) {
              if (value['data']['id'] is List) {
                List<int> ids = (value['data']['id'] as List)
                    .map<int>((e) => e as int)
                    .toList();

                service
                    .invoke('refreshNotificationsCount', {"count": ids.length});
                _showNotificationMultiEntities(
                    WebSocketNotificationModel.fromJson(value));
              } else {
                _showNotification(WebSocketNotificationModel.fromJson(value));
                service.invoke('refreshNotificationsCount', {"count": 1});
              }
            });
          }
        }
        // _______________________ listen to the notification real time _______________________
        if (data['data']['id'] is List) {
          List<int> ids =
              (data['data']['id'] as List).map<int>((e) => e as int).toList();

          editNotificationStatus();
          service.invoke('refreshNotificationsCount', {"count": ids.length});
          _showNotificationMultiEntities(
              WebSocketNotificationModel.fromJson(data));
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
      GlobalExceptionHandler.handle(
          exception: e, exceptionStackTrace: stackTrace);
    }
  }

  @pragma('vm:entry-point')
  static Future<void> editNotificationStatus() async {
    // playsounNotification();

    final response =
        await http.put(Uri.parse('${Endpoint.apiNotifications}/2'), headers: {
      'x-auth-token': token.read("token").toString(),
    }, body: {
      "id": "all" // also work
    });
    Logger().e(response.body);
    Logger().e(response.statusCode);

    // await ResponseHandler.processResponse(response);
  }

  @pragma('vm:entry-point')
  static void _showNotification2(String title, String subtitle, int id) {
    Logger().i("Displaying notification: $title - $subtitle");

    // Example using flutter_local_notifications:
    // Replace this with your actual notification logic
    flutterLocalNotificationsPlugin.show(
      id,
      title,
      subtitle,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id', // Channel ID
          'channel_name', // Channel Name
          importance: Importance.high,
          priority: Priority.high, playSound: false,
        ),
        // iOS: IOSNotificationDetails(),
      ),
    );
  }

  @pragma('vm:entry-point')
  static String returnTitle(String title) {
    // Retrieve the selected language from storage
    String? selectedLanguage = storage.read<String>('selected_language');

    switch (title) {
      case "newMission":
        return "New mission notification".tr;

      case "missionStatusChange":
        if (selectedLanguage == 'en') {
          return "Mission status updated".tr;
        } else if (selectedLanguage == 'fr') {
          return "Statut de la mission mis à jour".tr;
        } else {
          return "تحديث حالة البعثة".tr;
        }

      case "newTask":
        if (selectedLanguage == 'en') {
          return "New task created".tr;
        } else if (selectedLanguage == 'fr') {
          return "Nouvelle tâche créée".tr;
        } else {
          return "تم إنشاء مهمة جديدة".tr;
        }

      case "taskObserver":
      case "assignAsObserver":
        if (selectedLanguage == 'en') {
          return "Assigned as task observer".tr;
        } else if (selectedLanguage == 'fr') {
          return "Assigné comme observateur de tâche".tr;
        } else {
          return "تم تعيينك كمراقب مهمة".tr;
        }

      case "taskResponsible":
      case "assignAsResponsible":
        if (selectedLanguage == 'en') {
          return "Assigned as task responsible".tr;
        } else if (selectedLanguage == 'fr') {
          return "Assigné comme responsable de tâche".tr;
        } else {
          return "تم تعيينك كمسؤول عن المهمة".tr;
        }

      case "taskStatusChange":
        if (selectedLanguage == 'en') {
          return "Task status updated".tr;
        } else if (selectedLanguage == 'fr') {
          return "Statut de la tâche mis à jour".tr;
        } else {
          return "تم تحديث حالة المهمة".tr;
        }

      default:
        if (selectedLanguage == 'en') {
          return "New mission notification".tr;
        } else if (selectedLanguage == 'fr') {
          return "Nouvelle notification de mission".tr;
        } else {
          return "إشعار مهمة جديدة".tr;
        }
    }
  }
}
