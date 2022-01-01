import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:framework/core/classes/config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'package:framework/core/factories/response.dart';

abstract class IExtractorFindOneCUsecase {
  FutureOr<Response> call(ModularArguments args, Config config);

  Future<void> _createFile(Map<String, dynamic> source, String moduleName);
}

class ExtractorFindOneUsecase implements IExtractorFindOneCUsecase {
  @override
  Future<Response> call(ModularArguments args, Config config) async {
    try {
      await config.initMongo();
      var mongo = config.mongo!.conn!;

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
      throw HttpResponse.error(jsonEncode({"error": e.toString()}));
    } finally {
      await config.disconnectMongo();
    }
  }

  @override
  Future<void> _createFile(
      Map<String, dynamic> source, String moduleName) async {
    var className =
        "${moduleName[0].toUpperCase()}${moduleName.substring(1)}Usecase";

    var content = "";

    content += "import 'dart:async';\n";
    content += "import 'dart:convert';\n";

    content += "\n";

    content +=
        "import 'package:json_serializable_generic/json_serializable.dart';\n";
    content += "import 'package:shelf/shelf.dart';\n";
    content += "import 'package:shelf_modular/shelf_modular.dart';\n";

    content += "\n";

    content += "import'../../../shared/controllers/app_controller.dart';\n";
    content += "import 'package:framework/core/factories/response.dart';\n";
    content += "import '../${moduleName.toLowerCase()}_entity.dart';\n";

    content += "\nabstract class IFindOne$className {\n";
    content += "\tFutureOr<Response> call(ModularArguments args);\n";
    content += "}\n";

    content += "\n";

    content += "class FindOne$className implements IFindOne$className {\n";
    content += "\t@override\n";
    content += "\tFutureOr<Response> call(ModularArguments args) async {\n";
    content += "\t\tfinal app = Modular.get<AppController>();\n";

    content += "\t\t\n";

    content += "\t\ttry{\n";
    content += "\t\t\tawait app.config.initMongo();\n";
    content += "\t\t\tvar mongo = app.config.mongo!.conn!;\n";

    content += "\t\t\t\n";

    content +=
        "\t\t\tvar coll = mongo.collection('${moduleName.toLowerCase()}');\n";

    content += "\t\t\t\n";

    content +=
        "\t\t\tfinal result = await coll.findOne({'id': args.params['id']});\n";

    content += "\t\t\t\n";

    content += "\t\t\tif (result == null) {\n";
    content +=
        "\t\t\t\tthrow Exception('${moduleName[0].toUpperCase()}${moduleName.substring(1)} not found');\n";
    content += "\t\t\t}\n";

    content +=
        "\t\t\tvar $moduleName = JsonSerializable.fromMap<${moduleName[0].toUpperCase()}${moduleName.substring(1)}Entity>(result, excludes: ['_id']);\n";

    content += "\t\t\t\n";

    content +=
        "\t\t\t\treturn HttpResponse.ok(jsonEncode($moduleName.toMap(excludes: ['_id'])));\n";

    content += "\t\t} on Exception catch (e) {\n";
    content +=
        "\t\t\treturn HttpResponse.error(jsonEncode({'error': e.toString()}));\n";
    content += "\t\t} finally {\n";
    content += "\t\t\tawait app.config.disconnectMongo();\n";
    content += "\t\t}\n";
    content += "\t}\n";
    content += "}\n";

    var path =
        "src/${moduleName.toLowerCase()}/usecases/find_one_${moduleName.toLowerCase()}.dart";

    var file = await File(path).create(recursive: true);

    await file.writeAsString(content, mode: FileMode.write);
  }
}
