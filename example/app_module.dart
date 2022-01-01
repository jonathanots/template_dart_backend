import 'package:framework/core/utils/extractor/extractor_module.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'shared/controllers/app_controller.dart';
import 'src/user/user_module.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [Bind.singleton((i) => AppController())];

  @override
  List<ModularRoute> get routes => [
        Route.get('/', (ModularArguments args) => Response.ok('OK!')),
        Route.module('/user', module: UserModule()),
        Route.module('/extractor',
            module: ExtractorModule(Modular.get<AppController>().config)),
      ];
}
