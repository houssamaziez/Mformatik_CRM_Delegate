import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mformatic_crm_delegate/App/Controller/home/company_controller.dart';
import 'package:mformatic_crm_delegate/App/View/home/Home%20screen/clientview/client_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/home/Home%20screen/screenMissions/mission_list_screen.dart';
import 'package:mformatic_crm_delegate/App/View/home/Home%20screen/screenMissions/mission_list_screen_by_me.dart';

import '../../../Util/Route/Go.dart';
import '../Home screen/feedback/feedback_list_screen.dart';

class HomeMenuSelect {
  final String title, icon;
  final Function(BuildContext context) function;

  HomeMenuSelect({
    required this.title,
    required this.icon,
    required this.function,
  });
}
