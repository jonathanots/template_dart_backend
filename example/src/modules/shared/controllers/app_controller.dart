import 'package:backend_tool/core/classes/config.dart';
import 'package:backend_tool/core/interfaces/database_connection_interface.dart';

import '../../../../env.dart';

class AppController {
  late Config config;

  AppController([
    Config? newConfig,
  ]) {
    if (newConfig == null) {
      _init();
    } else {
      config = newConfig;
    }
  }

  _init() {
    config = Config();
    config.mongoSettings = DatabaseSettings(
      host: Env.ndbHost,
      port: Env.ndbPort,
      db: Env.ndbName,
    );
    config.initMongo();
  }
}
