import 'package:shelf/shelf.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';

class HttpResponse {
  /// Constructs a 200 OK response.
  ///
  /// This indicates that the request has succeeded.
  ///
  /// [body] is the response body. It may be either a [String], a [List<int>], a
  /// [Stream<List<int>>], or `null` to indicate no body.
  ///
  /// If the body is a [String], [encoding] is used to encode it to a
  /// [Stream<List<int>>]. It defaults to UTF-8. If it's a [String], a
  /// [List<int>], or `null`, the Content-Length header is set automatically
  /// unless a Transfer-Encoding header is set. Otherwise, it's a
  /// [Stream<List<int>>] and no Transfer-Encoding header is set, the adapter
  /// will set the Transfer-Encoding header to "chunked" and apply the chunked
  /// encoding to the body.
  ///
  /// If [encoding] is passed, the "encoding" field of the Content-Type header
  /// in [headers] will be set appropriately. If there is no existing
  /// Content-Type header, it will be set to "application/octet-stream".
  /// [headers] must contain values that are either `String` or `List<String>`.
  /// An empty list will cause the header to be omitted.
  static Response created(body) {
    final overrideHeaders = {
      ACCESS_CONTROL_ALLOW_ORIGIN: '*',
      'Content-Type': 'application/json;charset=utf-8'
    };

    return Response(201, body: body, headers: overrideHeaders);
  }

  static Response ok(body) {
    final overrideHeaders = {
      ACCESS_CONTROL_ALLOW_ORIGIN: '*',
      'Content-Type': 'application/json;charset=utf-8'
    };

    return Response.ok(body, headers: overrideHeaders);
  }

  static Response error(body, [int statusCode = 400]) {
    final overrideHeaders = {
      ACCESS_CONTROL_ALLOW_ORIGIN: '*',
      'Content-Type': 'application/json;charset=utf-8'
    };

    return Response(statusCode, body: body, headers: overrideHeaders);
  }

  static Response notFound(body) {
    final overrideHeaders = {
      ACCESS_CONTROL_ALLOW_ORIGIN: '*',
      'Content-Type': 'application/json;charset=utf-8'
    };

    return Response.notFound(body, headers: overrideHeaders);
  }
}
