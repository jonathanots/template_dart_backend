import 'dart:async';
import 'dart:convert';

import 'package:framework/core/utils/json_serializable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../shared/controllers/app_controller.dart';
import '../../shared/utils/response.dart';
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

      var result = await coll.findOne({'id': args.params['id']});

      if (result == null) {
        throw Exception('User not found');
      }

      var user =
          JsonSerializable.fromMap<UserEntity>(result, excludes: ['_id']);

      return HttpResponse.ok(jsonEncode(user.toMap(excludes: ['_id'])));
    } catch (e) {
      return HttpResponse.notFound(jsonEncode({'error': e.toString()}));
    } finally {
      app.config.disconnectMongo();
    }
  }
}