import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../shared/controllers/app_controller.dart';
import '../../shared/utils/response.dart';

abstract class IExtractorCreateModule {
  FutureOr<Response> call(ModularArguments args);

  Future<void> _createFile(Map<String, dynamic> source, String moduleName);
}

class ExtractorCreateModule implements IExtractorCreateModule {
  @override
  Future<Response> call(ModularArguments args) async {
    final app = Modular.get<AppController>();
    try {
      await app.config.initMongo();
      var mongo = app.config.mongo!.conn!;

      var moduleName = args.params["module"];

      var coll = mongo.collection(moduleName);

      var result = await coll.findOne();

      if (result != null) {
        await _createFile(result, moduleName);
        return HttpResponse.ok(jsonEncode(
            {"status": "success", "message": "File created successufully"}));
      }

      throw Exception(
          "Failed at find some data on collection, make sure your collection exists and has at least one document inserted");
    } catch (e) {
      return HttpResponse.notFound(jsonEncode({"error": e.toString()}));
    } finally {
      await app.config.disconnectMongo();
    }
  }

  @override
  Future<void> _createFile(
      Map<String, dynamic> source, String moduleName) async {
    var className =
        "${moduleName[0].toUpperCase()}${moduleName.substring(1)}Module";

    var content = "";

    content += "import 'package:shelf_modular/shelf_modular.dart';\n";

    content += "\n";

    content += "import 'usecases/create_${moduleName.toLowerCase()}.dart';\n";
    content += "import 'usecases/find_${moduleName.toLowerCase()}.dart';\n";
    content += "import 'usecases/find_one_${moduleName.toLowerCase()}.dart';\n";
    content += "import 'usecases/update_${moduleName.toLowerCase()}.dart';\n";
    content += "import 'usecases/delete_${moduleName.toLowerCase()}.dart';\n";

    content += "\nclass $className extends Module {\n";
    content += "\t@override\n";
    content += "\tList<ModularRoute> get routes => [\n";
    content +=
        "\t\tRoute.post('/',(ModularArguments args) => Create${moduleName[0].toUpperCase()}${moduleName.substring(1)}Usecase().call(args)),\n";
    content +=
        "\t\tRoute.get('/',(ModularArguments args) => Find${moduleName[0].toUpperCase()}${moduleName.substring(1)}Usecase().call(args)),\n";
    content +=
        "\t\tRoute.get('/:id',(ModularArguments args) => FindOne${moduleName[0].toUpperCase()}${moduleName.substring(1)}Usecase().call(args)),\n";
    content +=
        "\t\tRoute.put('/:id',(ModularArguments args) => Update${moduleName[0].toUpperCase()}${moduleName.substring(1)}Usecase().call(args)),\n";
    content +=
        "\t\tRoute.delete('/:id',(ModularArguments args) => Delete${moduleName[0].toUpperCase()}${moduleName.substring(1)}Usecase().call(args)),\n";
    content += "\t];\n";

    content += "}\n";

    var path =
        "example/${moduleName.toLowerCase()}/${moduleName.toLowerCase()}_module.dart";

    var file = await File(path).create(recursive: true);

    await file.writeAsString(content, mode: FileMode.write);
  }
}
