import 'package:dart_backend/user/json_serializable.dart';

class UserEntity with JsonSerializable<UserEntity> {
  final String name;
  final int age;

  UserEntity({required this.name, required this.age});
}
