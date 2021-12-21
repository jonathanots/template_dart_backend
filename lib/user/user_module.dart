import 'dart:async';

import 'package:dart_backend/user/user_entity.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/', (ModularArguments args) => test()),
      ];

  FutureOr<Response> test() {
    var user = UserEntity(name: 'Jonathan', age: 24);
    var map = user.toMap();

    // var parsed = JsonSerializable.fromMap<UserEntity>({"name": "Jonathan", "age": 24});
    return Response.ok(map);
  }
}
