import 'dart:convert';

import 'package:backend_tool/core/utils/extractor/extractor_module.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'src/modules/shared/controllers/app_controller.dart';
// import 'src/modules/user/user_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [Bind.singleton((i) => AppController())];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', (ModularArguments args) => Response.ok('OK!')),
        Route.get(
            '/server/status',
            (ModularArguments args) => Response.ok(
                jsonEncode({"status": 200, "message": "Server is running"}))),
        // Route.module('/user', module: UserModule()),
        Route.module('/extractor',
            module: ExtractorModule(Modular.get<AppController>().config)),
      ];
}
