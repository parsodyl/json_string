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
    'success test: decode a void map',
    () {
      // prepare input
      final source = '{}';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodedValue;
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
      final d = jsonString.decodedValue;  
      // check
      expect(d, TypeMatcher<List<dynamic>>());
      expect(d as List<dynamic>, hasLength(isZero));
    },
  );
  test(
    'success test: decode a single int value',
    () {
      // prepare input
      final source = '42';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodedValue;  
      // check
      expect(d, TypeMatcher<int>());
    },
  );
  test(
    'success test: decode a single double value',
    () {
      // prepare input
      final source = '42.0';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodedValue;  
      // check
      expect(d, TypeMatcher<double>());
    },
  );
  test(
    'success test: decode a single string value',
    () {
      // prepare input
      final source = '"Hello World!"';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodedValue;  
      // check
      expect(d, TypeMatcher<String>());
    },
  );
  test(
    'success test: decode a single boolean value',
    () {
      // prepare input
      final source = 'false';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodedValue;  
      // check
      expect(d, TypeMatcher<bool>());
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
      final d = jsonString.decodedValue;  
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
      final d = jsonString.decodedValue;  
      // check
      expect(d, TypeMatcher<List<dynamic>>());
      expect(d[0], equals(value0));
      expect(d[1], equals(value1));
    },
  );
}
