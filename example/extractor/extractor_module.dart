import 'package:shelf_modular/shelf_modular.dart';

import 'usecases/create_c_usecase.dart';
import 'usecases/create_entity.dart';

class ExtractorModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/entity/:module',
            (ModularArguments args) => ExtractorCreateEntity().call(args)),
        Route.get('/create/:module',
            (ModularArguments args) => ExtractorCreateUsecase().call(args)),
      ];
}
