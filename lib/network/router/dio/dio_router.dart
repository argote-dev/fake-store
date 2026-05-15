import 'package:fake_store/common/environment/environment.dart';
import 'package:fake_store/network/model/http/http_method.dart';
import 'package:fake_store/network/model/http/http_route.dart';
import 'package:fake_store/common/models/result.dart';
import 'package:fake_store/network/router/network_router.dart';
import 'package:dio/dio.dart';

class DioRouter implements NetworkRouter {
  late Dio _client;

  DioRouter({Dio? dio}) {
    if (dio != null) {
      _client = dio;
      return;
    }
    final baseUrl =
        Environment.baseURL ??
        (throw ArgumentError.notNull('Base url not configurated'));
    _client = Dio(BaseOptions(baseUrl: baseUrl));
  }

  @override
  Future<Result<T>> fetch<T>(HttpRoute route) async {
    try {
      switch (route.method) {
        case HttpMethod.get:
          final response = await _client.get(
            route.path.url,
            queryParameters: route.query,
          );
          return Result.success(response.data);
        case HttpMethod.post:
          final response = await _client.post(
            route.path.url,
            queryParameters: route.query,
            data: route.body,
          );
          return Result.success(response.data);
        case HttpMethod.put:
          final response = await _client.put(
            route.path.url,
            queryParameters: route.query,
            data: route.body,
          );
          return Result.success(response.data);
        case HttpMethod.delete:
          final response = await _client.delete(
            route.path.url,
            queryParameters: route.query,
            data: route.body,
          );
          return Result.success(response.data);
        case HttpMethod.patch:
          final response = await _client.patch(
            route.path.url,
            queryParameters: route.query,
            data: route.body,
          );
          return Result.success(response.data);
      }
    } on Exception catch (error) {
      return Result.failure(error);
    }
  }
}
