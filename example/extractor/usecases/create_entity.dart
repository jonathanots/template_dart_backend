import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../shared/controllers/app_controller.dart';
import '../../shared/utils/response.dart';

abstract class IExtractorCreateEntity {
  FutureOr<Response> call(ModularArguments args);

  Future<void> _createFile(Map<String, dynamic> source, String entity);
}

class ExtractorCreateEntity implements IExtractorCreateEntity {
  @override
  Future<Response> call(ModularArguments args) async {
    final app = Modular.get<AppController>();
    try {
      await app.config.initMongo();
      var mongo = app.config.mongo!.conn!;

      var entity = args.params["module"];

      var coll = mongo.collection(entity);

      var result = await coll.findOne();

      if (result != null) {
        await _createFile(result, entity);
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
  Future<void> _createFile(Map<String, dynamic> source, String entity) async {
    var className = "${entity[0].toUpperCase()}${entity.substring(1)}Entity";

    var content = "";

    content +=
        "import 'package:framework/core/utils/json_serializable.dart';\n";

    content += "import 'package:uuid/uuid.dart';\n";

    content += "\nclass $className with JsonSerializable {\n";

    content += "\tlate String? id;\n";

    var constructorFields = "";

    for (var field in source.entries) {
      if (field.key == "_id" || field.key == "id") continue;
      content += "\tfinal ${field.value.runtimeType} ${field.key};\n";
      constructorFields += "required this.${field.key},";
    }

    content += "\n\t$className({this.id, $constructorFields}) {\n";
    content += "\t\tid ??= Uuid().v4();\n";
    content += "\t}\n";
    content += "}";

    var path =
        "example/${entity.toLowerCase()}/${entity.toLowerCase()}_entity.dart";

    var file = await File(path).create(recursive: true);

    await file.writeAsString(content, mode: FileMode.write);
  }
}
