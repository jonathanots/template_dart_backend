import 'dart:async';
import 'dart:convert';
import 'package:framework/core/utils/json_serializable.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_modular/shelf_modular.dart';
import '../../shared/controllers/app_controller.dart';
import '../../shared/utils/response.dart';
import '../example_entity.dart';

abstract class ICreateExampleUsecase {
	FutureOr<Response> call(ModularArguments args);
}

class CreateExampleUsecase implements ICreateExampleUsecase {
	@override
	FutureOr<Response> call(ModularArguments args) async {
		final app = Modular.get<AppController>();
		
		try{
			await app.config.initMongo();
			var mongo = app.config.mongo!.conn!;
			
			var example = JsonSerializable.fromMap<ExampleEntity>(args.data, excludes:['id']);
			
			var coll = mongo.collection('example');
			
			final result = await coll.insert(example.toMap());
			
			if (result.isNotEmpty) {
				return HttpResponse.ok(jsonEncode(example.toMap()));
			}
			
			throw Exception('Failed at insert new example');
		} on Exception catch (e) {
			return HttpResponse.notFound(jsonEncode({'error': e.toString()}));
		} finally {
			await app.config.disconnectMongo();
		}
	}
}
