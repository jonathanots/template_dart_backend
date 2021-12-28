import 'dart:io';

class CreateEntity {
  Future<void> call(Map<String, dynamic>? source, String moduleName) async {
    var className =
        "${moduleName[0].toUpperCase()}${moduleName.substring(1)}Entity";

    var content = "";

    content +=
        "import 'package:framework/core/utils/json_serializable.dart';\n";

    content += "import 'package:uuid/uuid.dart';\n";

    content += "\nclass $className with JsonSerializable {\n";

    content += "\tlate String? id;\n";

    var constructorFields = "";

    for (var field in source!.entries) {
      if (field.key == "_id") continue;
      content += "\tfinal ${field.value.runtimeType} ${field.key};\n";
      constructorFields += "required this.${field.key},";
    }

    content += "\n\t$className({this.id, $constructorFields}) {\n";
    content += "\t\tid ??= Uuid().v4();\n";
    content += "\t}\n";
    content += "}";

    var path =
        "example/${moduleName.toLowerCase()}/${moduleName.toLowerCase()}_entity.dart";

    var file = await File(path).create(recursive: true);

    await file.writeAsString(content, mode: FileMode.write);
  }
}
