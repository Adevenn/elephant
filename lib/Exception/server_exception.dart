class ServerException implements Exception {
  final String message;

  const ServerException(
      [this.message = 'Connection to server failed, please reconnect']);

  @override
  String toString() => '$message Server disconnected';
}
