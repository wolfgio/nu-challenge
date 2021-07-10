class ServerException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  ServerException({required this.message, this.code, this.stackTrace});
}
