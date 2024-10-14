import 'dart:convert';

import 'package:http/http.dart' as http;

import 'exceptions.dart';

class ResponseHandler {
  static dynamic processResponse(http.Response response) {
    switch (response.statusCode) {
      case >= 200 && < 300:
        return decodeResponseBody(response);
      case 400: //Bad request
        throw BadRequestException(
          message: decodeResponseBody(response)['message'],
        );
      case 401 || 403: //Unauthorized || //Forbidden
        throw UnAuthorizedException(
          message: decodeResponseBody(response)['message'],
        );
      case 404: //Resource Not Found
        throw NotFoundException(
          message: decodeResponseBody(response)['message'],
        );
      case 500: //Internal Server Error
      default:
        throw FetchDataException(
          message: decodeResponseBody(response)['message'],
        );
    }
  }

  static dynamic decodeResponseBody(http.Response response) {
    return jsonDecode(response.body);
  }
}
