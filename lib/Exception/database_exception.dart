class DatabaseException implements Exception{
  final String message;

  const DatabaseException([this.message = 'Connection to database failed, please reconnect']);

  @override
  String toString() => message;
}