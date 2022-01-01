import 'package:json_serializable_generic/json_serializable.dart';
import 'package:uuid/uuid.dart';

class UserEntity with JsonSerializable {
  late String? id;
  final String name;
  final int age;

  UserEntity({this.id, required this.name, required this.age}) {
    id ??= Uuid().v4();
  }
}
