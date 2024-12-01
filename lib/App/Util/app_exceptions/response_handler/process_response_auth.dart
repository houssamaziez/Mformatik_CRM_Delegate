import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/Util/Route/Go.dart';
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';

import '../../../View/auth/screen_auth.dart';

class ResponseHandlerAuth {
  static dynamic processResponseAuth(http.Response response) {
    final context = Get.context;
    final defaultErrorMessage =
        "Something went wrong. Please try again or contact support if the issue persists."
            .tr;

    // Decode response body if necessary
    dynamic decodedResponse;
    try {
      decodedResponse = decodeResponseBody(response);
    } catch (e) {
      print("Error decoding response body: $e");
      showMessage(context, title: defaultErrorMessage);
      return null;
    }

    switch (response.statusCode) {
      // Successful responses
      case 200:
      case 201:
      case 202:
        return decodedResponse;

      // Client errors
      case 400: // Bad request
        if (decodedResponse?[0]["code"] == "badPassword") {
          showMessage(
            context,
            title: "The password field is incorrect".tr,
          );
          break;
        }
        if (decodedResponse?[0]["code"] == "string.pattern.base") {
          showMessage(
            context,
            title: "The username field is invalid.".tr,
          );
          break;
        }
        if (decodedResponse?[0]["code"] == "blockedUser") {
          showMessage(
            context,
            title: "This user is blocked".tr,
          );
          break;
        }
        showMessage(
          context,
          title: decodedResponse?[0]["message"] ?? "Invalid request.".tr,
        );
        break;

      case 401: // Unauthorized
        showMessage(
          context,
          title:
              "Access Denied! You don't have permission to view this content."
                  .tr,
        );
        break;

      case 403: // Forbidden
        showMessage(
          context,
          title:
              "Access Denied! You don't have permission to view this content."
                  .tr,
        );
        break;

      case 404: // Resource Not Found
        showMessage(
          context,
          title:
              "Sorry, we couldn't find what you were looking for. Please try again later."
                  .tr,
        );
        break;

      // Server errors
      case 500: // Internal Server Error
        showMessage(
          context,
          title:
              "We're experiencing some issues on our end. Please try again later."
                  .tr,
        );
        break;

      // Default case for unexpected status codes
      default:
        showMessage(
          context,
          title: defaultErrorMessage,
        );
        break;
    }

    return null; // Ensure a return value if no successful response
  }

  static dynamic processResponseGetMe(http.Response response) {
    switch (response.statusCode) {
      // Successful response
      case 200:
      case 201:
      case 202:
        return decodeResponseBody(response);

      case 400: // Bad request
        showMessage(Get.context, title: "username is invalid".tr);
        Go.clearAndTo(Get.context, ScreenAuth());
        break;
      case 401: // Unauthorized
        Go.clearAndTo(Get.context, ScreenAuth());
      case 403: // Forbidden
        print("Access Denied! You don't have permission to view this content.");
        showMessage(Get.context,
            title:
                "Access Denied! You don't have permission to view this content."
                    .tr);
        Go.clearAndTo(Get.context, ScreenAuth());
        break;

      case 404: // Resource Not Found

        Go.clearAndTo(Get.context, ScreenAuth());
        break;

      // Server errors
      case 500: // Internal Server Error
        showMessage(Get.context,
            title:
                "We're experiencing some issues on our end. Please try again later."
                    .tr);
        Go.clearAndTo(Get.context, ScreenAuth());
        break;

      // Default case for unexpected status codes
      default:
        showMessage(Get.context,
            title:
                "Something went wrong. Please try again or contact support if the issue persists."
                    .tr);
        Go.clearAndTo(Get.context, ScreenAuth());
        break;
    }
    return null; // Ensure a return value if no other cases are matched
  }

  static dynamic decodeResponseBody(http.Response response) {
    return jsonDecode(response.body);
  }
}
