class TimeoutException implements Exception {
  final String cause;
  TimeoutException(this.cause);
}

class HttpException implements Exception {
  final int statusCode;
  final String cause;
  HttpException(this.statusCode, this.cause);
  String toString() =>
      "HttpException: statusCode ${statusCode}; cause: ${cause}";
}

class AuthorizationException implements Exception {
  final String cause;
  AuthorizationException(this.cause);
  @override
  String toString() => "AuthorizationException: $cause";
}

class RestartAuthException extends AuthorizationException {
  /// Because you have a successful login last time,
  /// you need to restart the session to make LumiNUS
  /// give up recognizing you as the previous user.
  RestartAuthException() : super("Needs restarting the app");
}

class WrongCredentialsException extends AuthorizationException {
  /// This is most likely a [NoSuchMethodError] with a missing [startsWith]
  /// method.
  WrongCredentialsException() : super("Please provide correct credentials");
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
