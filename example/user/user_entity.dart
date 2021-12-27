import 'package:framework/core/utils/json_serializable.dart';
import 'package:mongo_dart/mongo_dart.dart';

class UserEntity with JsonSerializable {
  late String? id;
  final String name;
  final int age;

  UserEntity({this.id, required this.name, required this.age}) {
    id ??= Uuid().v4();
  }
}
