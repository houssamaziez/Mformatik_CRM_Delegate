import 'dart:async';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import 'package:http/http.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';

import 'exceptions.dart';

class GlobalExceptionHandler {
  static void handle(dynamic e) {
    switch (e.runtimeType) {
      case SocketException || TimeoutException || ClientException:
        Fluttertoast.showToast(msg: 'Connection problem try to refresh page.');
        break;
      case UnAuthorizedException:
        Fluttertoast.showToast(msg: e.toString());
        break;

      case Exception:
      default:
        showMessage(Get.context, title: e.toString());
    }
  }
}
