import 'usecases/create_user.dart';
import 'usecases/delete_user.dart';
import 'usecases/find_one_user.dart';
import 'usecases/find_user.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'usecases/update_user.dart';

class UserModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.post(
          '/',
          (ModularArguments args) => CreateUserUsecase().call(args),
        ),
        Route.get(
          '/',
          (ModularArguments args) => FindUserUsecase().call(args),
        ),
        Route.get(
          '/:id',
          (ModularArguments args) => FindOneUserUsecase().call(args),
        ),
        Route.put(
          '/:id',
          (ModularArguments args) => UpdateUserUsecase().call(args),
        ),
        Route.delete(
          '/:id',
          (ModularArguments args) => DeleteUserUsecase().call(args),
        ),
      ];
}
