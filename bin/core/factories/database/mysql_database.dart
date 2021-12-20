import 'package:mysql1/mysql1.dart';
import '../../interfaces/database_connection_interface.dart';

class MySqlDatabase implements IDatabaseConnection<MySqlConnection> {
  @override
  Future<MySqlConnection> connect(DatabaseSettings settings) async {
    return await MySqlConnection.connect(ConnectionSettings(
      host: settings.host,
      port: settings.port,
      user: settings.user,
      password: settings.password,
      db: settings.db,
    ));
  }
}
