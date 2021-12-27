import 'usecases/create_user.dart';
import 'usecases/find_one_user.dart';
import 'usecases/find_user.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/', (ModularArguments args) => FindUserUsecase().call(args)),
        Route.get(
            '/:id', (ModularArguments args) => FindOneUserUsecase().call(args)),
        Route.post(
            '/', (ModularArguments args) => CreateUserUsecase().call(args)),
      ];
}
