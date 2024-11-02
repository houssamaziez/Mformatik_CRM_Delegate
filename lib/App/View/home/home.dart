import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/home_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/missions_controller.dart';

import '../../Controller/auth/auth_controller.dart';
import '../../Controller/home/annex_controller.dart';
import '../widgets/Bottombar/widgetbottombar.dart';
import '../widgets/bolck_screen.dart';
import 'Widgets/appbar_home.dart';
import 'Home screen/homeview_feedback.dart';
import 'Home screen/homeview_mission.dart';
import 'Home screen/profileUser/profile_user_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _screen = [
    Home(),
    HomeFeedback(),
    ProfileUserScreen(),
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
          bool isactive = controllers.user!.isActive;
          return Scaffold(
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
          );
        });
  }
}
