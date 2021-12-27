import 'dart:async';
import 'dart:convert';

import 'package:framework/core/utils/json_serializable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../shared/controllers/app_controller.dart';
import '../../shared/utils/response.dart';
import '../user_entity.dart';

abstract class IFindUserUsecase {
  FutureOr<Response> call(ModularArguments args);
}

class FindUserUsecase implements IFindUserUsecase {
  @override
  FutureOr<Response> call(ModularArguments args) async {
    final app = Modular.get<AppController>();

    try {
      await app.config.initMongo();
      var mongo = app.config.mongo!.conn!;

      var coll = mongo.collection('users');

      int page = args.queryParams['page'] != null
          ? int.parse(args.queryParams['page']!)
          : 1;
      int limit = args.queryParams['amount'] != null
          ? int.parse(args.queryParams['amount']!)
          : 100;

      var results =
          await coll.find().skip((page - 1) * limit).take(limit).toList();

      var response = results
          .map<UserEntity>(
              (e) => JsonSerializable.fromMap<UserEntity>(e, excludes: ['_id']))
          .toList();

      return HttpResponse.ok(
          jsonEncode(response.map((e) => e.toMap(excludes: ['_id'])).toList()));
    } catch (e) {
      return HttpResponse.notFound(jsonEncode({"error": e.toString()}));
    } finally {
      app.config.disconnectMongo();
    }
  }
}
