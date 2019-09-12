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
    'success test: decode a single int value #1 (dynamic)',
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
    'success test: decode a single int value #2 (explicit)',
    () {
      // prepare input
      final source = '42';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodeAsPrimitiveValue<int>();
      // check
      expect(d, TypeMatcher<int>());
    },
  );
  test(
    'success test: decode a single double value  #1 (dynamic)',
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
    'success test: decode a single double value  #2 (explicit)',
    () {
      // prepare input
      final source = '42.0';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodeAsPrimitiveValue<double>();
      // check
      expect(d, TypeMatcher<double>());
    },
  );
  test(
    'success test: decode a single string value  #1 (dynamic)',
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
    'success test: decode a single string value  #2 (explicit)',
    () {
      // prepare input
      final source = '"Hello World!"';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodeAsPrimitiveValue<String>();
      // check
      expect(d, TypeMatcher<String>());
    },
  );
  test(
    'success test: decode a single boolean value  #1 (dynamic)',
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
    'success test: decode a single boolean value  #2 (explicit)',
    () {
      // prepare input
      final source = 'false';
      // execute
      final jsonString = JsonString(source);
      final d = jsonString.decodeAsPrimitiveValue<bool>();
      // check
      expect(d, TypeMatcher<bool>());
    },
  );
  test(
    'fail test: try to decode a JSON object as a primitive value',
    () {
      // prepare input
      final source = '{"hello":"world"}';
      // execute
      final jsonString = JsonString(source);
      final testCallList = [
        () => jsonString.decodeAsPrimitiveValue<int>(),
        () => jsonString.decodeAsPrimitiveValue<double>(),
        () => jsonString.decodeAsPrimitiveValue<String>(),
        () => jsonString.decodeAsPrimitiveValue<bool>(),
      ];
      // check
      testCallList.forEach((singleCall) =>
          expect(singleCall, throwsA(TypeMatcher<JsonDecodingError>())));
    },
  );
  test(
    'success test: try to decode null as a primitive value (TO BE MONITORED)',
    () {
      // prepare input
      final source = 'null';
      // execute
      final jsonString = JsonString(source);
      final testCallList = [
        () => jsonString.decodeAsPrimitiveValue<int>(),
        () => jsonString.decodeAsPrimitiveValue<double>(),
        () => jsonString.decodeAsPrimitiveValue<String>(),
        () => jsonString.decodeAsPrimitiveValue<bool>(),
      ];
      // check
      testCallList.forEach((singleCall) {
        final d = singleCall();
        expect(d, TypeMatcher<Null>());
      });
    },
  );
}
