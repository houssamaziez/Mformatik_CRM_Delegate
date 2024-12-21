// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoint {
  static String url = dotenv.get('urlHost');
  static String WEBSOCKET_URL = dotenv.get('WEBSOCKET_URL');
  static String apiLogin = '$url/v1/auth';
  static String apIme = '$url/v1/persons/me';
  static String apiMissions = '$url/v1/missions';
  static String apiAnnexes = '$url/v1/annexes';
  static String apiCompanies = '$url/v1/companies';
  static String apiCients = '$url/v1/clients';
  static String apiMissionsReasons = '$url/v1/missions/reasons';
  static String apiFeedbacksReasons = '$url/v1/feedbacks/feedback-models';
  static String apiFeedbacks = '$url/v1/feedbacks';
  static String apiChangeStatus = '$url/v1/missions/change-status-to';
  static String apiFeedbacksCounts = '$url/v1/statistics/feedbacks-counts';
  static String apiMissionCounts = '$url/v1/statistics/status-rate';
  static String apiFssionsShangeStatus = '$url/v1/missions/change-status-to';
  static String apipersonsUpdate = '$url/v1/persons/me';
  static String apiPersons = '$url/v1/persons';
  static String apiTask = '$url/v1/tasks';
}
