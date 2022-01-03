import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:backend_tool/core/classes/config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import 'package:backend_tool/core/factories/response.dart';

abstract class IExtractorCreateEntity {
  // FutureOr<Response> call(ModularArguments args, Config config);
  FutureOr<Response> call(Map<String, dynamic> source, String entity);

  Future<void> _createFile(Map<String, dynamic> source, String entity);
}

class ExtractorCreateEntity implements IExtractorCreateEntity {
  @override
  // Future<Response> call(ModularArguments args, Config config) async {
  Future<Response> call(Map<String, dynamic> source, String entity) async {
    try {
      await _createFile(source, entity);
      return HttpResponse.ok(jsonEncode(
          {"status": "success", "message": "File created successufully"}));
    } catch (e) {
      throw HttpResponse.error(jsonEncode({"error": e.toString()}));
    }
  }

  @override
  Future<void> _createFile(Map<String, dynamic> source, String entity) async {
    var className = "${entity[0].toUpperCase()}${entity.substring(1)}Entity";

    var content = "";

    content +=
        "import 'package:json_serializable_generic/json_serializable.dart';\n";

    content += "import 'package:uuid/uuid.dart';\n";

    var contentClass = "\nclass $className with JsonSerializable {\n";

    contentClass += "\tlate String? id;\n";

    var constructorFields = "";

    for (var field in source.entries) {
      if (field.key == "_id" || field.key == "id") continue;

      if (field.value is List) {
        var firstValue = (field.value as List).first;
        if (firstValue is Map) {
          await ExtractorCreateEntity().call(
              Map<String, dynamic>.from(firstValue),
              field.key.replaceRange(field.key.length - 1, null, ''));

          content +=
              "import '../${field.key.replaceRange(field.key.length - 1, null, '')}/${field.key.replaceRange(field.key.length - 1, null, '')}_entity.dart';\n";

          contentClass +=
              "\tfinal List<${field.key[0].toUpperCase()}${field.key.replaceRange(field.key.length - 1, null, '').substring(1)}Entity> ${field.key};\n";
        } else {
          contentClass +=
              "\tfinal ${field.value.runtimeType}<${firstValue.runtimeType}> ${field.key};\n";
        }
      } else {
        contentClass += "\tfinal ${field.value.runtimeType} ${field.key};\n";
      }

      constructorFields += "required this.${field.key},";
    }

    contentClass += "\n\t$className({this.id, $constructorFields}) {\n";
    contentClass += "\t\tid ??= Uuid().v4();\n";
    contentClass += "\t}\n";
    contentClass += "}";

    var path =
        "src/modules/${entity.toLowerCase()}/${entity.toLowerCase()}_entity.dart";

    var file = await File(path).create(recursive: true);

    await file.writeAsString(content + contentClass, mode: FileMode.write);
  }
}
