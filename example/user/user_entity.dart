import 'package:framework/core/utils/json_serializable.dart';

class UserEntity with JsonSerializable {
  final String name;
  final int age;

  UserEntity({required this.name, required this.age});
}
