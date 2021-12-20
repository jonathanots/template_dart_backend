import 'dart:mirrors';

abstract class JsonSerializable<T extends Object> {
  Map<String, dynamic> toMap() {
    InstanceMirror im = reflect(this);
    ClassMirror cm = im.type;

    Map<String, dynamic> map = {};

    cm.declarations.values.whereType<VariableMirror>().forEach((vm) {
      map[MirrorSystem.getName(vm.simpleName)] = im.getField(vm.simpleName).reflectee;
    });

    return map;
  }

  static fromMap<T>(Map source) {
    InstanceMirror im = reflect(T);
    ClassMirror cm = im.type;

    Map<Symbol, dynamic> args = {};

    for (var i in source.entries) {
      args[reflect(i.value).type.simpleName] = i.value;
    }

    return cm.newInstance(cm.simpleName, [], args).reflectee;
  }
}
