import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/View/home/Home%20screen/supscreen/createmission/clientview/client_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/home/Home%20screen/supscreen/screenMissions/mission_list_screen_by_me.dart';

import '../../../Util/Route/Go.dart';
import '../Home screen/feedback/feedback_screen.dart';

class HomeMenuSelect {
  final String title, icon;
  final Function(BuildContext context) function;

  HomeMenuSelect({
    required this.title,
    required this.icon,
    required this.function,
  });
}

List<HomeMenuSelect> listiconhomemeneu = [
  HomeMenuSelect(
      title: "My Mission",
      icon: "tiblee.png",
      function: (context) {
        // Go.to(context, CourseGridScreen(role: 'تنبيهات الحضور'));
        Go.to(context, const MissionListScreenByMe());
      }),
  HomeMenuSelect(
    title: "",
    icon: 'log.png',
    function: (context) {
      // Go.to(context, CourseGridScreen(role: 'الملاحظات'));
      // Go.to(context, const RequestForPermission());
    },
  ),
  HomeMenuSelect(
    title: "All Clients",
    icon: 'item3.png',
    function: (context) {
      Go.to(
          context,
          GetBuilder<CompanyController>(
              init: CompanyController(),
              builder: (companyController) {
                return ClientListScreen(
                  isback: true,
                  companyid: companyController.selectCompany!.id.toString(),
                );
              }));
    },
  ),
  HomeMenuSelect(
    title: "My FeedBack",
    icon: 'Messages, Chat.png',
    function: (context) {
      Go.to(context, FeedbackScreen());
      // Go.to(context, const ScreeenFollowUpTeachers());
    },
  ),
];
