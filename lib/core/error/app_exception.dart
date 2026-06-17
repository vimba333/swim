sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);
}

class NetworkException extends AppException {
  const NetworkException() : super('No internet connection');
}

class ServerException extends AppException {
  const ServerException(int code) : super('Server error: $code');
}

class RequestTimeoutException extends AppException {
  const RequestTimeoutException() : super('Request timeout');
}