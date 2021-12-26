import 'dart:convert';
import 'dart:mirrors';

abstract class JsonSerializable {
  Map<String, dynamic> toMap() {
    InstanceMirror im = reflect(this);
    ClassMirror cm = im.type;

    Map<String, dynamic> map = {};

    cm.declarations.values.whereType<VariableMirror>().forEach((vm) {
      map[MirrorSystem.getName(vm.simpleName)] = im.getField(vm.simpleName).reflectee;
    });

    return map;
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  static fromMap<B>(Map source) {
    ClassMirror cm = reflectClass(B);

    Map<Symbol, dynamic> args = {};

    print(source.entries);

    for (var i in source.entries) {
      args[Symbol(i.key)] = i.value;
    }

    InstanceMirror im = cm.newInstance(Symbol(''), [], args);
    var o = im.reflectee;

    return o;
  }

  static fromJson<B>(String source) => fromMap<B>(jsonDecode(source));
}
