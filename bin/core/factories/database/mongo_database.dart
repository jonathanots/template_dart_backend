import 'package:mongo_dart/mongo_dart.dart';
import '../../interfaces/database_connection_interface.dart';

class MongoDatabase implements IDatabaseConnection<Db> {
  @override
  Db? conn;

  @override
  Future<Db> connect(DatabaseSettings settings) async {
    var db = await Db.create("mongodb+srv://${settings.user}:${settings.password}@${settings.host}:${settings.port}/${settings.db}");
    await db.open();
    return db;
  }

  @override
  Future<void> disconnect() async {
    await conn?.close();
  }
}
