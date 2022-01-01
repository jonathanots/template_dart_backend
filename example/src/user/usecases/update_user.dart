import 'dart:async';
import 'dart:convert';

import 'package:framework/core/factories/response.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../../shared/controllers/app_controller.dart';
import '../user_entity.dart';
import 'find_one_user.dart';

abstract class IUpdateUserUsecase {
  FutureOr<Response> call(ModularArguments args);
}

class UpdateUserUsecase implements IUpdateUserUsecase {
  @override
  FutureOr<Response> call(ModularArguments args) async {
    final app = Modular.get<AppController>();

    try {
      var findUserResponse = await FindOneUserUsecase().call(args);

      if (findUserResponse.statusCode == 200) {
        await app.config.initMongo();
        var mongo = app.config.mongo!.conn!;

        var coll = mongo.collection('users');

        var modifier = ModifierBuilder();

        var defaultUser = UserEntity(name: "", age: 1);

        var mapUser = defaultUser.toMap();

        var invalidFields = [];

        for (var entry in (args.data as Map<String, dynamic>).entries) {
          if (mapUser.keys.toList().contains(entry.key)) {
            modifier.set(entry.key, entry.value);
          } else {
            invalidFields.add(entry.key);
          }
        }

        if (invalidFields.isNotEmpty) {
          throw Exception("Invalid fields: [ ${invalidFields.join(' , ')} ]");
        }

        final result =
            await coll.updateOne({"id": args.params["id"]}, modifier);

        if (result.isSuccess) return HttpResponse.ok('');
        throw Exception('Failed at update data');
      }

      throw Exception('User not found');
    } catch (e) {
      return HttpResponse.notFound(jsonEncode({"error": e.toString()}));
    } finally {
      await app.config.disconnectMongo();
    }
  }
}
