import 'package:json_string/json_string.dart';
import 'package:test/test.dart';

void main() {
  group('Default Constructor', () {
    test(
      'success test: construct JsonString #1 (basic usage)',
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
      'success test: construct JsonString #2 (cache enabled)',
      () {
        // prepare input
        final source = '{"username":"john_doe","password":"eiaw"}';
        // execute
        final jsonString = JsonString(source, enableCache: true);
        // check
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'fail test: construct JsonString with bad source #1 (format error)',
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
      'fail test: construct JsonString with bad source #2 (no JSON found)',
      () {
        // prepare input
        final badSource = 'HelloWorld!';
        // execute
        final testCall = () => JsonString(badSource);
        // check
        expect(testCall, throwsException);
        expect(testCall, throwsFormatException);
        expect(testCall, throwsA(TypeMatcher<JsonFormatException>()));
      },
    );
  });
  group('DotNull Constructor', () {
    test(
      'success test: construct JsonString #1 (basic usage)',
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
      'success test: construct JsonString #2 (cache enabled)',
      () {
        // prepare input
        final source = '{"username":"john_doe","password":"eiaw"}';
        // execute
        final jsonString = JsonString.orNull(source, enableCache: true);
        // check
        expect(jsonString, TypeMatcher<JsonString>());
        expect(jsonString, isNotNull);
      },
    );
    test(
      'fail test: construct JsonString with bad source #1 (format error)',
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
    test(
      'fail test: construct JsonString with bad source #2 (no JSON found)',
      () {
        // prepare input
        final badSource = 'HelloWorld!';
        // execute
        final jsonString = JsonString.orNull(badSource);
        // check
        expect(jsonString, isNot(TypeMatcher<JsonString>()));
        expect(jsonString, isNull);
      },
    );
  });
}
