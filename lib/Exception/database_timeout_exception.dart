class DatabaseTimeoutException implements Exception{
  final String message;

  DatabaseTimeoutException([this.message = '']);

  @override
  String toString() => message;
}