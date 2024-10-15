import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mformatic_crm_delegate/App/View/widgets/showsnack.dart';

class ResponseHandler {
  static dynamic processResponse(http.Response response) {
    switch (response.statusCode) {
      // Successful response
      case 200:
      case 201:
      case 202:
        return decodeResponseBody(response);

      // Client errors
      case 400: // Bad request

        if (decodeResponseBody(response)[0]["statecode "] == "105") {
          showMessage(Get.context, title: "username is invalid".tr);
        } else {
          if (decodeResponseBody(response)[0]["message"] ==
              "the password is wrong") {
            showMessage(Get.context, title: "the password is wrong".tr);
          } else {
            showMessage(Get.context,
                title:
                    "Oops! It seems there was an issue with your request. Please try again."
                        .tr);
          }
        }

        break;
      case 401: // Unauthorized
      case 403: // Forbidden
        showMessage(Get.context,
            title:
                "Access Denied! You don't have permission to view this content."
                    .tr);
        break;
      case 404: // Resource Not Found
        showMessage(Get.context,
            title:
                "Sorry, we couldn't find what you were looking for. Please try again later."
                    .tr);
        break;

      // Server errors
      case 500: // Internal Server Error
        showMessage(Get.context,
            title:
                "We're experiencing some issues on our end. Please try again later."
                    .tr);
        break;

      // Default case for unexpected status codes
      default:
        showMessage(Get.context,
            title:
                "Something went wrong. Please try again or contact support if the issue persists."
                    .tr);
        break;
    }
    return null; // Ensure a return value if no other cases are matched
  }

  static dynamic decodeResponseBody(http.Response response) {
    return jsonDecode(response.body);
  }
}
