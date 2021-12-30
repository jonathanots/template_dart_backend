import 'package:framework/core/utils/json_serializable.dart';
import 'package:uuid/uuid.dart';

class ExampleEntity with JsonSerializable {
	late String? id;
	final String field1;
	final double age;

	ExampleEntity({this.id, required this.field1,required this.age,}) {
		id ??= Uuid().v4();
	}
}