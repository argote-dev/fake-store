import 'package:fake_store/network/model/http/http_method.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HttpMethod', () {
    test('should return correct string name for each method', () {
      // Given (nothing specific for enum constants)
      
      // When/Then
      expect(HttpMethod.get.name, 'GET');
      expect(HttpMethod.post.name, 'POST');
      expect(HttpMethod.put.name, 'PUT');
      expect(HttpMethod.delete.name, 'DELETE');
      expect(HttpMethod.patch.name, 'PATCH');
    });
  });
}
