class DbException implements Exception{
  final String message;

  const DbException([this.message = 'Connection to database failed, please reconnect']);

  @override
  String toString() => message;
}