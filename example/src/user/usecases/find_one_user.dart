import 'dart:async';
import 'dart:convert';

import 'package:framework/core/factories/response.dart';
import 'package:json_serializable_generic/json_serializable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../shared/controllers/app_controller.dart';
import '../user_entity.dart';

abstract class IFindOneUserUsecase {
  FutureOr<Response> call(ModularArguments args);
}

class FindOneUserUsecase implements IFindOneUserUsecase {
  @override
  FutureOr<Response> call(ModularArguments args) async {
    final app = Modular.get<AppController>();

    try {
      await app.config.initMongo();
      var mongo = app.config.mongo!.conn!;

      var coll = mongo.collection('users');

      final result = await coll.findOne({'id': args.params['id']});

      if (result == null) {
        throw Exception('User not found');
      }

      var user =
          JsonSerializable.fromMap<UserEntity>(result, excludes: ['_id']);

      return HttpResponse.ok(jsonEncode(user.toMap(excludes: ['_id'])));
    } catch (e) {
      return HttpResponse.error(jsonEncode({'error': e.toString()}));
    } finally {
      await app.config.disconnectMongo();
    }
  }
}
