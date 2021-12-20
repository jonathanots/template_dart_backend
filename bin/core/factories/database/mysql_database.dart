import 'package:mysql1/mysql1.dart';
import '../../errors/database_errors.dart';
import '../../interfaces/database_connection_interface.dart';

class MySqlDatabase implements IDatabaseConnection<MySqlConnection> {
  @override
  MySqlConnection? conn;

  @override
  Future<MySqlConnection> connect(DatabaseSettings? settings) async {
    if (settings == null) throw NullableSettings("Failed to create a instance of MySQL when settings is null.");

    var connection = await MySqlConnection.connect(ConnectionSettings(
      host: settings.host,
      port: settings.port,
      user: settings.user,
      password: settings.password,
      db: settings.db,
    ));

    conn = connection;

    return connection;
  }

  @override
  Future<void> disconnect() async {
    await conn?.close();
  }
}
