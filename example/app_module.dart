import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'user/user_module.dart';

class AppModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/', (ModularArguments args) => Response.ok('OK!')),
        Route.module('/user', module: UserModule()),
      ];
}
