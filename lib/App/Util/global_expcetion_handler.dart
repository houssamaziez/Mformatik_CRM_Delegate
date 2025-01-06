import 'dart:async';
import 'dart:io';

import '../../main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'app_exceptions/exceptions.dart';


class GlobalExceptionHandler {
  static void handle({dynamic exception, StackTrace? exceptionStackTrace}) async {
    if (exception is SocketException || exception is TimeoutException || exception is http.ClientException) {
      // Fluttertoast.showToast(
      //     msg: langCubit.appLang == "en"
      //         ? "Connection problem, please check your internet connection and try again."
      //         : "Problème de connexion, veuillez vérifier votre connexion Internet et réessayer.");
    } else if (exception is UnAuthorizedException) {
      Fluttertoast.showToast(msg: exception.toString());
    } else if (exception is UnAuthenticatedException) {
      Fluttertoast.showToast(msg: exception.toString());
    } else if (exception is AccountNotActiveException) {
      Fluttertoast.showToast(msg: exception.toString());
    } else {
      Fluttertoast.showToast(msg: exception.toString());
    }

    // await Sentry.captureException(
    //   exception,
    //   stackTrace: exceptionStackTrace,
    // );
  }
}
