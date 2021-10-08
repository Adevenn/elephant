class ConnectivityException implements Exception{
  String message;

  ConnectivityException([this.message = 'You have no internet connection']);

  @override
  String toString() => message;
}