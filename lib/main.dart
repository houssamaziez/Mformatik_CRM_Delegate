import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'App/Controller/auth/auth_controller.dart';
import 'App/Service/ConnectivityService.dart';
import 'App/myapp.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  Get.put(ConnectivityController());
  token.write("token", null);
  runApp(const MyApp());
}
