import 'package:fake_store/network/model/http/http_route.dart';
import 'package:fake_store/network/model/result/result.dart';

abstract class NetworkRouter {
  Future<Result<T>> fetch<T>(HttpRoute route);
}
