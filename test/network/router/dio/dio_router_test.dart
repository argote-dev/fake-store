import 'package:dio/dio.dart';
import 'package:fake_store/network/model/http/http_method.dart';
import 'package:fake_store/network/model/http/http_route.dart';
import 'package:fake_store/network/model/result/result.dart';
import 'package:fake_store/network/path/path.dart';
import 'package:fake_store/network/router/dio/dio_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'dio_router_test.mocks.dart';

class MockPath extends Path {
  MockPath(String url) : super(url: url);
}

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late DioRouter dioRouter;

  setUp(() {
    mockDio = MockDio();
    dioRouter = DioRouter(dio: mockDio);
  });

  group('DioRouter.fetch - Given/When/Then Pattern', () {
    test('Given a GET route, When dio returns 200, Then fetch should return Success', () async {
      // Given
      final route = HttpRoute(
        path: MockPath('test'),
        method: HttpMethod.get,
        query: {'q': '1'},
      );
      final responseData = {'key': 'value'};
      final response = Response(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'test'),
      );
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => response);

      // When
      final result = await dioRouter.fetch<Map<String, dynamic>>(route);

      // Then
      expect(result.isSuccess, isTrue);
      expect((result as Success).value, responseData);
      verify(mockDio.get('test', queryParameters: {'q': '1'})).called(1);
    });

    test('Given a POST route, When dio returns 200, Then fetch should return Success', () async {
      // Given
      final requestBody = {'id': 1};
      final route = HttpRoute(
        path: MockPath('test'),
        method: HttpMethod.post,
        body: requestBody,
      );
      final responseData = 'success';
      final response = Response(
        data: responseData,
        statusCode: 200,
        requestOptions: RequestOptions(path: 'test'),
      );
      when(mockDio.post(any,
              data: anyNamed('data'),
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => response);

      // When
      final result = await dioRouter.fetch<String>(route);

      // Then
      expect(result.isSuccess, isTrue);
      expect((result as Success).value, responseData);
      verify(mockDio.post('test', data: requestBody, queryParameters: null))
          .called(1);
    });

    test('Given any route, When dio throws an exception, Then fetch should return Failure', () async {
      // Given
      final route = HttpRoute(
        path: MockPath('test'),
        method: HttpMethod.get,
      );
      final exception = DioException(
        requestOptions: RequestOptions(path: 'test'),
        type: DioExceptionType.connectionTimeout,
      );
      when(mockDio.get(any, queryParameters: anyNamed('queryParameters')))
          .thenThrow(exception);

      // When
      final result = await dioRouter.fetch(route);

      // Then
      expect(result.isFailure, isTrue);
      expect((result as Failure).error, exception);
    });

    test('Given a PUT route, When fetch is called, Then it should call dio.put', () async {
      // Given
      final route = HttpRoute(path: MockPath('test'), method: HttpMethod.put);
      when(mockDio.put(any,
              data: anyNamed('data'),
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
              data: {}, requestOptions: RequestOptions(path: 'test')));

      // When
      await dioRouter.fetch(route);

      // Then
      verify(mockDio.put('test', 
             data: anyNamed('data'), 
             queryParameters: anyNamed('queryParameters'))).called(1);
    });

    test('Given a DELETE route, When fetch is called, Then it should call dio.delete', () async {
      // Given
      final route = HttpRoute(path: MockPath('test'), method: HttpMethod.delete);
      when(mockDio.delete(any,
              data: anyNamed('data'),
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
              data: {}, requestOptions: RequestOptions(path: 'test')));

      // When
      await dioRouter.fetch(route);

      // Then
      verify(mockDio.delete('test', 
             data: anyNamed('data'), 
             queryParameters: anyNamed('queryParameters'))).called(1);
    });

    test('Given a PATCH route, When fetch is called, Then it should call dio.patch', () async {
      // Given
      final route = HttpRoute(path: MockPath('test'), method: HttpMethod.patch);
      when(mockDio.patch(any,
              data: anyNamed('data'),
              queryParameters: anyNamed('queryParameters')))
          .thenAnswer((_) async => Response(
              data: {}, requestOptions: RequestOptions(path: 'test')));

      // When
      await dioRouter.fetch(route);

      // Then
      verify(mockDio.patch('test', 
             data: anyNamed('data'), 
             queryParameters: anyNamed('queryParameters'))).called(1);
    });
  });
}
