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
    'success test: yes, this is a (void) list',
    () {
      // prepare input
      final source = '[]';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodedValueAsList;
      // check
      expect(d, TypeMatcher<List<dynamic>>());
      expect(d, hasLength(isZero));
    },
  );
  test(
    'success test: yes, this is a (complex) list',
    () {
      // prepare input
      final source = '''
        [
          42,
          {
            "key0": [
              "list_item0",
              "list_item1",
              "list_item2"
            ],
            "key1": "subvalue1",
            "key2": 42.0
          }
        ]
      ''';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodedValueAsList;
      // check
      expect(d, TypeMatcher<List<dynamic>>());
    },
  );
   test(
    'fail test: no, this is not a list',
    () {
      // prepare input
      final source = '{}';
      // execute
      final jsonString = JsonString(source);
      final testCall = () => jsonString.decodedValueAsList;
      // check
      expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
    },
  );
}
