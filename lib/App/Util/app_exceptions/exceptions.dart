

class TemplateException implements Exception {
  String? message;
  String? code;
  TemplateException({this.message, this.code}) : super();
  @override
  String toString() {
    // if (code != null) {
    //   return serverErrorTranslator(code!, langCubit.appLang);
    // } else {
    return "$message";
    //}
  }
}

class FeedBackPositionUndefinedException extends TemplateException {
  FeedBackPositionUndefinedException({String? message, String? code}) : super(message: message, code: code);
}

class ReachSearchLimitException extends TemplateException {
  ReachSearchLimitException({String? message, String? code}) : super(message: message, code: code);
}

class BadRequestException extends TemplateException {
  BadRequestException({String? message, String? code}) : super(message: message, code: code);
}

class AccountNotActiveException extends TemplateException {
  AccountNotActiveException({String? message, String? code}) : super(message: message, code: code);
}

class FetchDataException extends TemplateException {
  FetchDataException({String? message, String? code}) : super(message: message, code: code);
}

class UnAuthorizedException extends TemplateException {
  UnAuthorizedException({String? message, String? code}) : super(message: message, code: code);
}

class UnAuthenticatedException extends TemplateException {
  UnAuthenticatedException({String? message, String? code}) : super(message: message, code: code);
}

class NotFoundException extends TemplateException {
  NotFoundException({String? message, String? code}) : super(message: message, code: code);
}
