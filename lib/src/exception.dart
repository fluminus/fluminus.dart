class TimeoutException implements Exception {
  String cause;
  TimeoutException(this.cause);
}

class HttpException implements Exception {
  final int statusCode;
  final String cause;
  HttpException(this.statusCode, this.cause);
  String toString() =>
      "HttpException: statusCode ${statusCode}; cause: ${cause}";
}

class BadRequestException extends HttpException {
  BadRequestException(String cause) : super(400, 'Bad request: ' + cause);
}

class ForbiddenException extends HttpException {
  ForbiddenException(String cause) : super(403, 'Not authorized: ' + cause);
}

class NotFoundException extends HttpException {
  NotFoundException(String cause) : super(404, 'Not found: ' + cause);
}

class InternalServerErrorException extends HttpException {
  InternalServerErrorException(String cause)
      : super(500, 'Internal server error: ' + cause);
}
