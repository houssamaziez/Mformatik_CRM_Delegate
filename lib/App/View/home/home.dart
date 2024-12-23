import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/home_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/mission/missions_controller.dart';

import '../../Controller/auth/auth_controller.dart';
import '../../Controller/home/annex_controller.dart';
import '../../Service/websocket/websocket_service.dart';
import '../widgets/Bottombar/widgetbottombar.dart';
import '../widgets/bolck_screen.dart';
import 'Widgets/appbar_home.dart';
import 'home_screens/home_feedback/homeview_feedback.dart';
import 'home_screens/home_mission/homeview_mission.dart';
import 'home_screens/home_task/homeview_task.dart';
import 'home_screens/profileUser/profile_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final List<Map<String, String>> notifications =
      []; // List to store notifications with title and body

  @override
  void initState() {
    super.initState();
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidSettings);

    notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle when a notification is clicked
        if (details.payload != null) {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         NotificationDetailsScreen(payload: details.payload),
          //   ),
          // );
        }
      },
    );
  }

  final List<Widget> _screen = [
    const HomeMission(),
    HomeFeedback(),
    const HomeViewTask(),
    const ProfileUserScreen(),
  ];
  final MissionsController controller = Get.put(MissionsController());

  AuthController controllers = Get.put(AuthController());
  HomeController homeController = Get.put(HomeController(), permanent: true);

  final AnnexController annexController =
      Get.put(AnnexController(), permanent: true);
  final CompanyController companyController =
      Get.put(CompanyController(), permanent: true);
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          bool isactive = controllers.user!.isActive!;
          return WillPopScope(
            onWillPop: () async {
              bool shouldExit = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Exit App'.tr),
                    content: Text('Are you sure you want to exit the app?'.tr),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Do not exit
                        },
                        child: Text('No'.tr),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Exit the app
                        },
                        child: Text('Yes'.tr),
                      ),
                    ],
                  );
                },
              );

              return shouldExit;
            },
            child: Scaffold(
              appBar: appbarHome(
                context,
              ),
              bottomNavigationBar: buttonnavigationbar(context),
              body: isactive == true
                  ? Column(
                      children: [
                        Expanded(child: _screen[controller.indexBottomBar]),
                      ],
                    )
                  : const screenBlock(),
            ),
          );
        });
  }
}
