import 'package:fake_store/network/model/http/http_method.dart';
import 'package:fake_store/network/path/path.dart';

class HttpRoute {
  final Path path;
  final HttpMethod method;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? query;
  final Object? body;

  HttpRoute({
    required this.path,
    required this.method,
    this.headers,
    this.query,
    this.body,
  });
}
