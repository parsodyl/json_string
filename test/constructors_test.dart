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
    'success test: construct JsonString #1 (default constr)',
    () {
      // prepare input
      final source = '{"username":"john_doe","password":"eiaw"}';
      // execute
      final jsonString = JsonString(source);
      // check
      expect(jsonString, TypeMatcher<JsonString>());
    },
  );
  test(
    'success test: construct JsonString #2 (orNull  constr)',
    () {
      // prepare input
      final source = '{"username":"john_doe","password":"eiaw"}';
      // execute
      final jsonString = JsonString.orNull(source);
      // check
      expect(jsonString, TypeMatcher<JsonString>());
      expect(jsonString, isNotNull);
    },
  );
  test(
    'fail test: construct JsonString with bad source #1 (default constr)',
    () {
      // prepare input
      final badSource = '{"username":"john_doe","password:"eiaw"}';
      // execute
      final testCall = () => JsonString(badSource);
      // check
      expect(testCall, throwsException);
      expect(testCall, throwsFormatException);
      expect(testCall, throwsA(TypeMatcher<JsonFormatException>()));
    },
  );
  test(
    'fail test: construct JsonString with bad source #2 (default constr)',
    () {
      // prepare input
      final badSource = 'Hello World!';
      // execute
      final testCall = () => JsonString(badSource);
      // check
      expect(testCall, throwsException);
      expect(testCall, throwsFormatException);
      expect(testCall, throwsA(TypeMatcher<JsonFormatException>()));
    },
  );
  test(
    'fail test: construct JsonString with bad source #3 (orNull constr)',
    () {
      // prepare input
      final badSource = '{"username":"john_doe","password:"eiaw"}';
      // execute
      final jsonString = JsonString.orNull(badSource);
      // check
      expect(jsonString, isNot(TypeMatcher<JsonString>()));
      expect(jsonString, isNull);
    },
  );
}
