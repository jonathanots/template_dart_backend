import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../shared/controllers/app_controller.dart';
import '../shared/utils/response.dart';

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

      var className = "${module}Entity";

      var content = "";

      content +=
          "import 'package:framework/core/utils/json_serializable.dart';\n";

      content += "import 'package:uuid/uuid.dart';\n";

      content += "\nclass $className with JsonSerializable {\n";

      content += "\tlate String? id;\n";

      var constructorFields = "";

      for (var field in result!.entries) {
        if (field.key == "_id") continue;
        content += "\tfinal ${field.value.runtimeType} ${field.key};\n";
        constructorFields += "required this.${field.key},";
      }

      content += "\t$className({this.id, $constructorFields}) {\n";
      content += "\t\tid ??= Uuid().v4();\n";
      content += "\t}";
      content += "}";

      var file = await File(
              'example/${module.toLowerCase()}/${module.toLowerCase()}_entity.dart')
          .create(recursive: true);

      await file.writeAsString(content, mode: FileMode.write);
      return HttpResponse.ok(jsonEncode(result));
    } catch (e) {
      return HttpResponse.ok(jsonEncode("failed ${e.toString()}"));
    }
  }
}
