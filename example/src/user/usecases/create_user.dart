import 'dart:async';
import 'dart:convert';

import 'package:framework/core/factories/response.dart';
import 'package:json_serializable_generic/json_serializable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../shared/controllers/app_controller.dart';
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

      final result = await coll.insert(user.toMap());

      if (result.isNotEmpty) {
        return HttpResponse.created(jsonEncode(user.toMap()));
      }

      throw Exception('Failed at insert new user');
    } on Exception catch (e) {
      return HttpResponse.error(jsonEncode({"error": e.toString()}));
    } finally {
      await app.config.disconnectMongo();
    }
  }
}
