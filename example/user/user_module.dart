import 'dart:async';
import 'dart:convert';

import 'package:framework/core/classes/config.dart';
import 'package:framework/core/interfaces/database_connection_interface.dart';
import 'package:framework/core/utils/json_serializable.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../shared/controllers/app_controller.dart';
import '../shared/utils/response.dart';
import 'user_entity.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

class UserModule extends Module {
  @override
  List<ModularRoute> get routes => [
        Route.get('/', (ModularArguments args) => test()),
      ];

  FutureOr<Response> test() async {
    var app = Modular.get<AppController>();

    var mongo = app.config.mongo!.conn!;

    var coll = mongo.collection('users');

    var results = await coll.find().toList();

    var response = results
        .map<UserEntity>(
            (e) => JsonSerializable.fromMap<UserEntity>(e, excludes: ['_id']))
        .toList();

    return HttpResponse.ok(jsonEncode(response.map((e) => e.toMap()).toList()));
  }
}
