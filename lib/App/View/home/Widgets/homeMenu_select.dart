import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/clientview/client_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/screenMissions/mission_all/mission_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/screenMissions/mission_by_me/mission_list_screen_by_me.dart';

import '../../../Util/Route/Go.dart';
import '../home_screens/feedback/feedback_list_screen.dart';

class HomeMenuSelect {
  final String title, icon;
  final Function(BuildContext context) function;

  HomeMenuSelect({
    required this.title,
    required this.icon,
    required this.function,
  });
}
