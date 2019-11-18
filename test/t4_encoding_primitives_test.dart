import 'package:json_string/json_string.dart';
import 'package:test/test.dart';

void main() {
  group('Primitive-value encode method', () {
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
  });
  group('Primitive-list encode method', () {
    test(
      'fail test: .encodePrimitiveList() with null imputs #1',
      () {
        // prepare input
        final data = null;
        // execute
        final testCall = () => JsonString.encodePrimitiveList(data);
        // check
        expect(testCall, throwsA(TypeMatcher<AssertionError>()));
      },
    );
    test(
      'success test: encode a primivive list #1 (int)',
      () {
        // prepare input
        final data = [1, 2, 3, 4, 5];
        // execute
        final jsonString = JsonString.encodePrimitiveList(data);
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'success test: encode a primivive list #2 (double)',
      () {
        // prepare input
        final data = [1.0, 2.0, 3.0, 4.0, 5.0];
        // execute
        final jsonString = JsonString.encodePrimitiveList(data);
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'success test: encode a primivive list #3 (bool)',
      () {
        // prepare input
        final data = [true, false, false, true, false];
        // execute
        final jsonString = JsonString.encodePrimitiveList(data);
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'success test: encode a primivive list #4 (String)',
      () {
        // prepare input
        final data = ["h", "e", "l", "l", "o"];
        // execute
        final jsonString = JsonString.encodePrimitiveList(data);
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'fail test: try to encode a null filled list #1 (implicit type)',
      () {
        // prepare input
        final data = [null, null, null, null, null];
        // execute
        final testCall = () => JsonString.encodePrimitiveList(data);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
      },
    );
    test(
      'seccess test: try to encode a null filled list #2 (explicit type)',
      () {
        // prepare input
        final data = [null, null, null, null, null];
        // execute
        final testCall = () => JsonString.encodePrimitiveList<String>(data);
        final jsonString = testCall();
        // check
        expect(testCall, isNot(throwsA(TypeMatcher<JsonEncodingError>())));
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'fail test: try to encode a not-primitive list #1',
      () {
        // prepare input
        final data = [Exception('shame'), Exception('on'), Exception('you')];
        // execute
        final testCall = () => JsonString.encodePrimitiveList(data);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
      },
    );
  });
}
