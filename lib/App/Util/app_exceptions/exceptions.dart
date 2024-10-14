class BadRequestException implements Exception {
  String? message;
  BadRequestException({
    String? message,
  });
  @override
  String toString() {
    return "$runtimeType($message)";
  }
}

class FetchDataException implements Exception {
  String? message;
  FetchDataException({
    this.message,
  });
  @override
  String toString() {
    return "$runtimeType($message)";
  }
}

class UnAuthorizedException implements Exception {
  String? message;
  UnAuthorizedException({
    String? message,
  });
  @override
  String toString() {
    return "$runtimeType($message)";
  }
}

class NotFoundException implements Exception {
  String? message;
  NotFoundException({
    String? message,
  });
  @override
  String toString() {
    return "$runtimeType($message)";
  }
}
