import 'package:json_string/json_string.dart';
import 'package:test/test.dart';

void main() {
  group('Decoded-value property', () {
    test(
      'success test: decode a void map',
      () {
        // prepare input
        final source = '{}';
        // execute
        final jsonString = JsonString(source);
        final dynamic d = jsonString.decodedValue;
        // check
        expect(d, TypeMatcher<Map<String, dynamic>>());
        expect(d as Map<String, dynamic>, hasLength(isZero));
      },
    );
    test(
      'success test: decode a void list',
      () {
        // prepare input
        final source = '[]';
        // execute
        final jsonString = JsonString(source);
        final dynamic d = jsonString.decodedValue;
        // check
        expect(d, TypeMatcher<List<dynamic>>());
        expect(d as List<dynamic>, hasLength(isZero));
      },
    );
    test(
      'success test: decode a single JSON object (Map<String, dynamic>)',
      () {
        // prepare input
        final key0 = 'username';
        final key1 = 'password';
        final value0 = 'john_doe';
        final value1 = 'eiaw';
        final source = '{"$key0":"$value0","$key1":"$value1"}';
        // execute
        final jsonString = JsonString(source);
        final dynamic d = jsonString.decodedValue;
        // check
        expect(d, TypeMatcher<Map<String, dynamic>>());
        expect(d[key0], equals(value0));
        expect(d[key1], equals(value1));
      },
    );
    test(
      'success test: decode a single JSON list (List<dynamic>)',
      () {
        // prepare input
        final value0 = 'john_doe';
        final value1 = 'clara_brothers';
        final source = '["$value0","$value1"]';
        // execute
        final jsonString = JsonString(source);
        final dynamic d = jsonString.decodedValue;
        // check
        expect(d, TypeMatcher<List<dynamic>>());
        expect(d[0], equals(value0));
        expect(d[1], equals(value1));
      },
    );
  });
  group('Decoded-value-as-map property', () {
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
  });
  group('Decoded-value-as-list property', () {
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
  });
}
