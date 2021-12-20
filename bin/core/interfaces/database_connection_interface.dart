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
  Future<T> connect(DatabaseSettings settings);
}

// Mysql
// ConnectionSettings(
//   host: 'localhost', 
//   port: 3306,
//   user: 'bob',
//   password: 'wibble',
//   db: 'mydb'
// )

// MongoDB
// Db("mongodb://localhost:27017/mongo_dart-blog");