import 'package:shelf_modular/shelf_modular.dart';

import 'usecases/create_c_usecase.dart';
import 'usecases/create_entity.dart';
import 'usecases/create_f_usecase.dart';
import 'usecases/create_module.dart';
import 'usecases/create_u_usecase.dart';

class ExtractorModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/entity/:module',
            (ModularArguments args) => ExtractorCreateEntity().call(args)),
        Route.get('/create/:module',
            (ModularArguments args) => ExtractorCreateUsecase().call(args)),
        Route.get('/find/:module',
            (ModularArguments args) => ExtractorFindUsecase().call(args)),
        Route.get('/update/:module',
            (ModularArguments args) => ExtractorUpdateUsecase().call(args)),
        Route.get('/module/:module',
            (ModularArguments args) => ExtractorCreateModule().call(args)),
      ];
}
