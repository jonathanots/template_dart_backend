import '../factories/database/mongo_database.dart';
import '../factories/database/mysql_database.dart';
import '../interfaces/database_connection_interface.dart';

class Config {
  MySqlDatabase? mysql;
  DatabaseSettings? mysqlSettings;

  MongoDatabase? mongo;
  DatabaseSettings? mongoSettings;

  Future<void> initMySql() async {
    if (mysql == null) {
      mysql = MySqlDatabase();
      mysql!.connect(mysqlSettings);
    }
  }

  Future<void> disconnectMySql() async {
    if (mysql != null) {
      await mysql!.disconnect();
      mysql = null;
    }
  }

  Future<void> initMongo() async {
    if (mongo == null) {
      mongo = MongoDatabase();
      await mongo!.connect(mongoSettings);
    }
  }

  Future<void> disconnectMongo() async {
    if (mongo != null) {
      await mongo!.disconnect();
      mongo = null;
    }
  }
}
