import 'package:dart_backend/shared/utils/json_serializable.dart';

class UserEntity with JsonSerializable {
  final String name;
  final int age;

  UserEntity({required this.name, required this.age});
}
