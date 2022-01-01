import 'dart:async';
import 'dart:convert';

import 'package:framework/core/factories/response.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../shared/controllers/app_controller.dart';
import 'find_one_user.dart';

abstract class IDeleteUserUsecase {
  FutureOr<Response> call(ModularArguments args);
}

class DeleteUserUsecase implements IDeleteUserUsecase {
  @override
  FutureOr<Response> call(ModularArguments args) async {
    final app = Modular.get<AppController>();

    try {
      var findUserResponse = await FindOneUserUsecase().call(args);

      if (findUserResponse.statusCode == 200) {
        await app.config.initMongo();
        var mongo = app.config.mongo!.conn!;

        var coll = mongo.collection('users');

        final result = await coll.deleteOne({"id": args.params["id"]});

        if (result.isSuccess) return HttpResponse.ok('');
        throw Exception('Failed at delete data');
      }

      throw Exception('User not found');
    } catch (e) {
      return HttpResponse.notFound(jsonEncode({"error": e.toString()}));
    } finally {
      await app.config.disconnectMongo();
    }
  }
}
