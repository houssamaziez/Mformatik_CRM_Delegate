// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoint {
  static String url = dotenv.get('urlHost');
  static String WEBSOCKET_URL = dotenv.get('WEBSOCKET_URL');
  static String apiLogin = '$url/api/v1/auth';
  static String apIme = '$url/api/v1/persons/me';
  static String apiMissions = '$url/api/v1/missions';
  static String apiAnnexes = '$url/api/v1/annexes';
  static String apiCompanies = '$url/api/v1/companies';
  static String apiCients = '$url/api/v1/clients';
  static String apiMissionsReasons = '$url/api/v1/missions/reasons';
  static String apiFeedbacksReasons = '$url/api/v1/feedbacks/feedback-models';
  static String apiFeedbacks = '$url/api/v1/feedbacks';
  static String apiChangeStatus = '$url/api/v1/missions/change-status-to';
  static String apiFeedbacksCounts = '$url/api/v1/statistics/feedbacks-counts';
  static String apiMissionCounts = '$url/api/v1/statistics/status-rate';
  static String apiFssionsShangeStatus =
      '$url/api/v1/missions/change-status-to';
  static String apipersonsUpdate = '$url/api/v1/persons/me';
  static String apiPersons = '$url/api/v1/persons';
  static String apiTask = '$url/api/v1/tasks';
  static String apiNotifications = '$url/api/v1/notifications';

}
