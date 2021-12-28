import 'package:shelf_modular/shelf_modular.dart';

import 'usecases/create_entity.dart';

class ExtractorModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/:module',
            (ModularArguments args) => ExtractorCreateEntity().call(args)),
      ];
}
