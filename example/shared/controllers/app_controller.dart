import 'package:framework/core/classes/config.dart';

import '../utils/constants.dart';

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
    config.mongoSettings = mongoSettings;
    config.initMongo();
  }
}
