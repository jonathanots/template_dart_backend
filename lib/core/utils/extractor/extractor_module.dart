import 'package:backend_tool/core/classes/config.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'usecases/create_c_usecase.dart';
import 'usecases/create_d_usecase.dart';
import 'usecases/create_entity.dart';
import 'usecases/create_f_one_usecase.dart';
import 'usecases/create_f_usecase.dart';
import 'usecases/create_module.dart';
import 'usecases/create_u_usecase.dart';

class ExtractorModule extends Module {
  final Config config;

  ExtractorModule(this.config);

  @override
  List<ModularRoute> get routes => [
        Route.get(
            '/entity/:module',
            (ModularArguments args) =>
                ExtractorCreateEntity().call(args, config)),
        Route.get(
            '/create/:module',
            (ModularArguments args) =>
                ExtractorCreateUsecase().call(args, config)),
        Route.get(
            '/find/:module',
            (ModularArguments args) =>
                ExtractorFindUsecase().call(args, config)),
        Route.get(
            '/find_one/:module',
            (ModularArguments args) =>
                ExtractorFindOneUsecase().call(args, config)),
        Route.get(
            '/update/:module',
            (ModularArguments args) =>
                ExtractorUpdateUsecase().call(args, config)),
        Route.get(
            '/delete/:module',
            (ModularArguments args) =>
                ExtractorDeleteUsecase().call(args, config)),
        Route.get(
            '/module/:module',
            (ModularArguments args) =>
                ExtractorCreateModule().call(args, config)),
      ];
}
