import 'package:framework/core/utils/json_serializable.dart';
import 'package:uuid/uuid.dart';

class CompanyEntity with JsonSerializable {
	late String? id;
	final String name;
	CompanyEntity({this.id, required this.name,}) {
		id ??= Uuid().v4();
	}}