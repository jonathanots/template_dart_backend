import 'dart:async';
import 'dart:convert';

import 'package:framework/core/utils/json_serializable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';

import '../../shared/controllers/app_controller.dart';
import '../../shared/utils/response.dart';
import '../example_entity.dart';

abstract class IFindExampleUsecase {
	FutureOr<Response> call(ModularArguments args);
}

class FindExampleUsecase implements IFindExampleUsecase {
	@override
	FutureOr<Response> call(ModularArguments args) async {
		final app = Modular.get<AppController>();
		
		try{
			await app.config.initMongo();
			var mongo = app.config.mongo!.conn!;
			
			var coll = mongo.collection('example');
			
			int page = args.queryParams['page'] != null
				? int.parse(args.queryParams['page']!)
				: 1;
			
			int limit = args.queryParams['amount'] != null
				? int.parse(args.queryParams['amount']!)
				: 100;
			
			final results = await coll.find().skip((page - 1) * limit).take(limit).toList();
			
			var response = results
				.map<ExampleEntity>(
					(e) => JsonSerializable.fromMap<ExampleEntity>(e, excludes: ['_id']))
				.toList();
			
				return HttpResponse.ok(jsonEncode(response.map((e) => e.toMap(excludes: ['_id'])).toList()));
		} on Exception catch (e) {
			return HttpResponse.notFound(jsonEncode({'error': e.toString()}));
		} finally {
			await app.config.disconnectMongo();
		}
	}
}
