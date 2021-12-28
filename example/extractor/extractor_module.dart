import 'dart:async';
import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../shared/controllers/app_controller.dart';
import '../shared/utils/response.dart';
import 'usecases/create_entity.dart';

class ExtractorModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/:module', (ModularArguments args) => extractor(args)),
      ];

  FutureOr<Response> extractor(ModularArguments args) async {
    final app = Modular.get<AppController>();
    try {
      await app.config.initMongo();
      var mongo = app.config.mongo!.conn!;

      String module = args.params["module"];

      var coll = mongo.collection(module.toLowerCase());

      var result = await coll.findOne();

      if (result != null) {
        throw Exception("Collection is empty or not exists");
      }

      await CreateEntity().call(result, module);

      return HttpResponse.ok(jsonEncode(result));
    } catch (e) {
      return HttpResponse.ok(jsonEncode("failed ${e.toString()}"));
    }
  }
}
