import 'package:mongo_dart/mongo_dart.dart';
import '../../errors/database_errors.dart';
import '../../interfaces/database_connection_interface.dart';

class MongoDatabase implements IDatabaseConnection<Db> {
  @override
  Db? conn;

  @override
  Future<Db> connect(DatabaseSettings? settings) async {
    if (settings == null) {
      throw NullableSettings(
          "Failed to create a instance of MongoDB when settings is null.");
    }

    var authString = '';
    if ((settings.user?.isNotEmpty ?? false) &&
        (settings.password?.isNotEmpty ?? false)) {
      authString = "${settings.user}${settings.password}@";
    }

    var db = Db(
        "mongodb://$authString${settings.host}:${settings.port}/${settings.db}");
    await db.open();

    conn = db;

    return db;
  }

  @override
  Future<void> disconnect() async {
    await conn?.close();
  }
}
