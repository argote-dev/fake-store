import 'package:fake_store/common/models/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Result', () {
    test('Given a Success result, When checking properties, Then it should report correctly', () {
      // Given
      const value = 10;
      const result = Success<int>(value);

      // When
      final isSuccess = result.isSuccess;
      final isFailure = result.isFailure;
      final resultValue = result.value;

      // Then
      expect(isSuccess, isTrue);
      expect(isFailure, isFalse);
      expect(resultValue, value);
    });

    test('Given a Failure result, When checking properties, Then it should report correctly', () {
      // Given
      final exception = Exception('Error');
      final result = Failure<int>(exception);

      // When
      final isSuccess = result.isSuccess;
      final isFailure = result.isFailure;
      final resultError = result.error;

      // Then
      expect(isSuccess, isFalse);
      expect(isFailure, isTrue);
      expect(resultError, exception);
    });

    test('Given a Success result, When calling when(), Then it should execute the success callback', () {
      // Given
      const result = Success<String>('hello');

      // When
      final output = result.when(
        success: (v) => v.toUpperCase(),
        failure: (e) => 'fail',
      );

      // Then
      expect(output, 'HELLO');
    });

    test('Given a Failure result, When calling when(), Then it should execute the failure callback', () {
      // Given
      final result = Result<String>.failure(Exception('oops'));

      // When
      final output = result.when(
        success: (v) => v,
        failure: (e) => 'fail',
      );

      // Then
      expect(output, 'fail');
    });

    test('Given a Success result, When calling map(), Then it should transform the value', () {
      // Given
      const result = Success<int>(5);

      // When
      final mapped = result.map((v) => v * 2);

      // Then
      expect(mapped.isSuccess, isTrue);
      expect((mapped as Success).value, 10);
    });

    test('Given a Failure result, When calling map(), Then it should return the same failure', () {
      // Given
      final result = Result<int>.failure(Exception('oops'));

      // When
      final mapped = result.map((v) => v * 2);

      // Then
      expect(mapped.isFailure, isTrue);
    });
  });
}
