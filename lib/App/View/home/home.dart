import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/home_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/mission/missions_controller.dart';

import '../../Controller/auth/auth_controller.dart';
import '../../Controller/home/annex_controller.dart';
import '../../Controller/home/notification/notification_controller.dart';

import '../../Util/Const/lists.dart';
import '../widgets/Bottombar/widgetbottombar.dart';
import '../widgets/Dialog/showDailog_exit_app.dart';
import '../widgets/bolck_screen.dart';
import 'Widgets/appbar_home.dart';
import 'notifications/notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final List<Map<String, String>> notifications = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get.put(NotificationController()).GetCount();
      // playNotificationSound();
    });
    super.initState();
    // const androidSettings =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');
    // const initializationSettings =
    //     InitializationSettings(android: androidSettings);

    // notificationsPlugin.initialize(
    //   initializationSettings,
    //   onDidReceiveNotificationResponse: (details) {
    //     if (details.payload != null) {}
    //   },
    // );
  }

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
              bool shouldExit = await showDialogExitApp(context);
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
                        Expanded(child: screenHome[controller.indexBottomBar]),
                      ],
                    )
                  : const screenBlock(),
            ),
          );
        });
  }
}
