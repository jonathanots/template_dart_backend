abstract class IDatabaseFailure implements Exception {
  final dynamic message;

  IDatabaseFailure([this.message]);

  @override
  String toString() {
    Object? message = this.message;
    if (message == null) return "Database Exception";
    return "Database Exception: $message";
  }
}

class NullableSettings extends IDatabaseFailure {
  NullableSettings([var message = "Nullable Database Settings. Please use a valid setting"]) : super(message);
}
