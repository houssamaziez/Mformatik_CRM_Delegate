import 'package:flutter/material.dart';
import 'package:mformatic_crm_delegate/App/View/home/home_screens/home_mission/homeview_mission.dart';

import '../../View/home/home_screens/home_feedback/homeview_feedback.dart';
import '../../View/home/home_screens/home_task/homeview_task.dart';
import '../../View/home/home_screens/profileUser/profile_user_screen.dart';
import '../../View/home/notifications/notifications_screen.dart';

final List<Widget> screenHome = [
    const HomeMission(),
    HomeFeedback(),
    const HomeViewTask(),
    NotificationScreenAll(), 
    const ProfileUserScreen(),
  ];