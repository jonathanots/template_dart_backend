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

  Future<void> initMongo() async {
    if (mongo == null) {
      mongo = MongoDatabase();
      mongo!.connect(mongoSettings);
    }
  }
}
