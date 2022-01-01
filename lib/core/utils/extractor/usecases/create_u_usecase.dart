import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backend_tool/core/classes/config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'package:backend_tool/core/factories/response.dart';

abstract class IExtractorUpdateCUsecase {
  FutureOr<Response> call(ModularArguments args, Config config);

  Future<void> _createFile(Map<String, dynamic> source, String moduleName);
}

class ExtractorUpdateUsecase implements IExtractorUpdateCUsecase {
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
    content += "import 'dart:mirrors';\n";

    content += "\n";

    content += "import 'package:mongo_dart/mongo_dart.dart';\n";
    content += "import 'package:shelf/shelf.dart';\n";
    content += "import 'package:shelf_modular/shelf_modular.dart';\n";

    content += "\n";

    content += "import'../../../shared/controllers/app_controller.dart';\n";
    content += "import 'package:backend_tool/core/factories/response.dart';\n";
    content += "import '../${moduleName.toLowerCase()}_entity.dart';\n";
    content += "import 'find_one_${moduleName.toLowerCase()}.dart';\n";

    content += "\nabstract class IUpdate$className {\n";
    content += "\tFutureOr<Response> call(ModularArguments args);\n";
    content += "}\n";

    content += "\n";

    content += "class Update$className implements IUpdate$className {\n";
    content += "\t@override\n";
    content += "\tFutureOr<Response> call(ModularArguments args) async {\n";
    content += "\t\tfinal app = Modular.get<AppController>();\n";

    content += "\t\t\n";

    content += "\t\ttry{\n";
    content +=
        "\t\t\tvar findOne${moduleName[0].toUpperCase()}${moduleName.substring(1)}Response = await FindOne${moduleName[0].toUpperCase()}${moduleName.substring(1)}Usecase().call(args);\n";

    content += "\t\t\t\n";

    content +=
        "\t\t\tif (findOne${moduleName[0].toUpperCase()}${moduleName.substring(1)}Response.statusCode == 200) {\n";

    content += "\t\t\t\tawait app.config.initMongo();\n";
    content += "\t\t\t\tvar mongo = app.config.mongo!.conn!;\n";

    content += "\t\t\t\t\n";

    content +=
        "\t\t\t\tvar coll = mongo.collection('${moduleName.toLowerCase()}');\n";

    content += "\t\t\t\t\n";

    content += "\t\t\t\tvar modifier = ModifierBuilder();\n";

    content +=
        "\t\t\t\tvar c = reflectClass(${moduleName[0].toUpperCase()}${moduleName.substring(1)}Entity);\n";
    content +=
        "\t\t\t\tvar declarations = c.declarations.values.whereType<VariableMirror>().toList();\n";

    content +=
        "\t\t\t\tvar ${moduleName}Variables = declarations.map((e) => MirrorSystem.getName(e.simpleName)).toList();\n";

    content += "\t\t\t\t\n";

    content += "\t\t\t\tvar invalidFields = [];\n";

    content += "\t\t\t\t\n";

    content +=
        "\t\t\t\tfor (var entry in (args.data as Map<String, dynamic>).entries) {\n";

    content += "\t\t\t\t\tif (${moduleName}Variables.contains(entry.key)) {\n";
    content += "\t\t\t\t\t\t modifier.set(entry.key, entry.value);\n";
    content += "\t\t\t\t\t} else {\n";
    content += "\t\t\t\t\t\tinvalidFields.add(entry.key);\n";
    content += "\t\t\t\t\t}\n";
    content += "\t\t\t\t}\n";

    content += "\t\t\t\t\n";

    content += "\t\t\t\tif (invalidFields.isNotEmpty) {\n";
    content +=
        "\t\t\t\t\tthrow Exception('Invalid fields: [ \${invalidFields.join(' , ')} ]');\n";
    content += "\t\t\t\t}\n";

    content += "\t\t\t\t\n";

    content +=
        "\t\t\t\tfinal result = await coll.updateOne({'id': args.params['id']}, modifier);\n";

    content += "\t\t\t\t\n";

    content += "\t\t\t\tif (result.isSuccess) return HttpResponse.ok('');\n";
    content += "\t\t\t\tthrow Exception('Failed at update data');\n";
    content += "\t\t\t}\n";

    content += "\t\t\t\n";

    content +=
        "\t\t\tthrow Exception('${moduleName[0].toUpperCase()}${moduleName.substring(1)} not found');\n";
    content += "\t\t} on Exception catch (e) {\n";
    content +=
        "\t\t\treturn HttpResponse.error(jsonEncode({'error': e.toString()}));\n";
    content += "\t\t} finally {\n";
    content += "\t\t\tawait app.config.disconnectMongo();\n";
    content += "\t\t}\n";
    content += "\t}\n";
    content += "}\n";

    var path =
        "src/modules/${moduleName.toLowerCase()}/usecases/update_${moduleName.toLowerCase()}.dart";

    var file = await File(path).create(recursive: true);

    await file.writeAsString(content, mode: FileMode.write);
  }
}
