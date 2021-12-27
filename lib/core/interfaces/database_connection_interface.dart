class DatabaseSettings {
  final String host;
  final int port;
  final String db;
  final String? user;
  final String? password;

  DatabaseSettings({
    required this.host,
    required this.port,
    required this.db,
    this.password,
    this.user,
  });
}

abstract class IDatabaseConnection<T> {
  T? conn;

  Future<T> connect(DatabaseSettings? settings);

  Future<void> disconnect();
}
