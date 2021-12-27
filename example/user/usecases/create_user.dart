import 'dart:async';
import 'dart:convert';

import 'package:framework/core/utils/json_serializable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../shared/controllers/app_controller.dart';
import '../../shared/utils/response.dart';
import '../user_entity.dart';

abstract class ICreateUserUsecase {
  FutureOr<Response> call(ModularArguments args);
}

class CreateUserUsecase implements ICreateUserUsecase {
  @override
  FutureOr<Response> call(ModularArguments args) async {
    final app = Modular.get<AppController>();

    try {
      await app.config.initMongo();
      var mongo = app.config.mongo!.conn!;

      var user =
          JsonSerializable.fromMap<UserEntity>(args.data, excludes: ['id']);

      var coll = mongo.collection('users');

      await coll.insert(user.toMap());

      return HttpResponse.ok(jsonEncode(user.toMap()));
    } catch (e) {
      return HttpResponse.notFound(jsonEncode({"error": e.toString()}));
    } finally {
      app.config.disconnectMongo();
    }
  }
}
