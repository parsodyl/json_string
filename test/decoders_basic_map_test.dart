import 'package:test/test.dart';
import 'package:json_string/json_string.dart';

void main() {
  setUp(() {
    // setup
  });
  tearDown(() {
    // teardown
  });
  test(
    'success test: yes, this is a (void) map',
    () {
      // prepare input
      final source = '{}';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodedValueAsMap;
      // check
      expect(d, TypeMatcher<Map<String, dynamic>>());
      expect(d, hasLength(isZero));
    },
  );
  test(
    'success test: yes, this is a (complex) map',
    () {
      // prepare input
      final source = '''
        {
          "key0": 42,
          "key1": {
            "subkey0": [
              "list_item0",
              "list_item1",
              "list_item2"
            ],
            "subkey1": "subvalue1",
            "subkey2": 42.0
          }
        }
      ''';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodedValueAsMap;
      // check
      expect(d, TypeMatcher<Map<String, dynamic>>());
    },
  );
  test(
    'fail test: no, this is not a map',
    () {
      // prepare input
      final source = '[]';
      // execute
      final jsonString = JsonString(source);
      final testCall = () => jsonString.decodedValueAsMap;
      // check
      expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
    },
  );
}
