class ServerException implements Exception{
  String message;

  ServerException([this.message = 'Connection to server failed, please reconnect']);

  @override
  String toString() => '$message Server disconnected';
}