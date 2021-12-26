class DatabaseSettings {
  final String host;
  final int port;
  final String user;
  final String password;
  final String db;

  DatabaseSettings({
    required this.host,
    required this.port,
    required this.user,
    required this.password,
    required this.db,
  });
}

abstract class IDatabaseConnection<T> {
  T? conn;

  Future<T> connect(DatabaseSettings? settings);

  Future<void> disconnect();
}
