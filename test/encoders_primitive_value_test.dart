import 'package:json_string/json_string.dart';
import 'package:test/test.dart';

void main() {
  setUp(() {
    // setup
  });
  tearDown(() {
    // teardown
  });
  test(
    'fail test: .encodePrimitiveValue() with null imputs #1',
    () {
      // prepare input
      final data = null;
      // execute
      final testCall = () => JsonString.encodePrimitiveValue(data);
      // check
      expect(testCall, throwsA(TypeMatcher<AssertionError>()));
    },
  );
  test(
    'success test: encode a primitive value #1 (int)',
    () {
      // prepare input
      final data = 42;
      // execute
      final jsonString = JsonString.encodePrimitiveValue(data);
      // check
      expect(jsonString, isNotNull);
      expect(jsonString, TypeMatcher<JsonString>());
    },
  );
  test(
    'success test: encode a primitive value #2 (double)',
    () {
      // prepare input
      final data = 3.14;
      // execute
      final jsonString = JsonString.encodePrimitiveValue(data);
      // check
      expect(jsonString, isNotNull);
      expect(jsonString, TypeMatcher<JsonString>());
    },
  );
  test(
    'success test: encode a primitive value #3 (bool)',
    () {
      // prepare input
      final data = true;
      // execute
      final jsonString = JsonString.encodePrimitiveValue(data);
      // check
      expect(jsonString, isNotNull);
      expect(jsonString, TypeMatcher<JsonString>());
    },
  );
  test(
    'success test: encode a primitive value #4 (String)',
    () {
      // prepare input
      final data = "Happy coding!";
      // execute
      final jsonString = JsonString.encodePrimitiveValue(data);
      // check
      expect(jsonString, isNotNull);
      expect(jsonString, TypeMatcher<JsonString>());
    },
  );
  test(
    'fail test: try to encode a not-primitive value #1',
    () {
      // prepare input
      final data = Exception('shame on you');
      // execute
      final testCall = () => JsonString.encodePrimitiveValue(data);
      // check
      expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
    },
  );
}
