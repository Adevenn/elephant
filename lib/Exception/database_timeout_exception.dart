class DatabaseTimeoutException implements Exception{
  final String message;

  const DatabaseTimeoutException([this.message = '']);

  @override
  String toString() => message;
}