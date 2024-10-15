// ignore_for_file: non_constant_identifier_names

import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoint {
  static String url = dotenv.get('urlHost');
  static String apiLogin = '$url/v1/auth';
  static String apIme = '$url/v1/persons/me';
  static String apiMissions = '$url/v1/missions';
  static String apiAnnexes = '$url/v1/annexes';
}
