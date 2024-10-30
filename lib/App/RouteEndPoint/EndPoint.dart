// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoint {
  static String url = dotenv.get('urlHost');
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
  static String apiFssionsShangeStatus = '$url/v1/missions/change-status-to';
}
