import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/come_controller.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/missions_controller.dart';

import '../widgets/Bottombar/widgetbottombar.dart';
import 'supscreen/createmission/create_mission_screen.dart';
import 'supscreen/screenMissions/mission_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Get.put(MissionsController()).getAllMission(context);
    super.initState();
  }

  List<Widget> _screen = [
    MissionListScreen(),
    AnnexScreen(),
    MissionListScreen(),
    AnnexScreen(),
  ];

  Widget build(BuildContext context) {
    //TODO: add bottom bar in this scaffold
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return Scaffold(
            bottomNavigationBar: buttonnavigationbar(context),
            body: _screen[controller.indexBottomBar],
          );
        });
  }
}
