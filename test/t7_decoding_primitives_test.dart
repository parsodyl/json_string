import 'package:json_string/json_string.dart';
import 'package:test/test.dart';

void main() {
  group('Primitive-value decode method', () {
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
          () => jsonString.decodeAsPrimitiveValue<int?>(),
          () => jsonString.decodeAsPrimitiveValue<double?>(),
          () => jsonString.decodeAsPrimitiveValue<String?>(),
          () => jsonString.decodeAsPrimitiveValue<bool?>(),
        ];
        // check
        testCallList.forEach((singleCall) {
          final d = singleCall();
          expect(d, TypeMatcher<Null>());
        });
      },
    );
  });
  group('Primitive-list decode method', () {
    test(
      'fail test: .decodeAsPrimitiveList() with wrong type input #1 (not primitive)',
      () {
        // prepare input
        final source = '[1, 2, 3]';
        // execute
        final jsonString = JsonString(source);
        final testCall = () => jsonString.decodeAsPrimitiveList<Set>();
        // check
        expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
      },
    );
    test(
      'fail test: .decodeAsPrimitiveList() with wrong type input #2 (String instead of int)',
      () {
        // prepare input
        final source = '[1, 2, 3]';
        // execute
        final jsonString = JsonString(source);
        final testCall = () => jsonString.decodeAsPrimitiveList<String>();
        // check
        expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
      },
    );
    test(
      'fail test: .decodeAsPrimitiveList() with wrong type input #3 (int instead of double)',
      () {
        // prepare input
        final source = '[1.0, 2.0, 3.0]';
        // execute
        final jsonString = JsonString(source);
        final testCall = () => jsonString.decodeAsPrimitiveList<String>();
        // check
        expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
      },
    );
    test(
      'success test: .decodeAsPrimitiveList() with right type input #1 (int)',
      () {
        // prepare input
        final source = '[1, 2, 3]';
        // execute
        final jsonString = JsonString(source);
        final resultList = jsonString.decodeAsPrimitiveList<int>();
        // check
        expect(resultList, isNotNull);
        expect(resultList, TypeMatcher<List<int>>());
      },
    );
    test(
      'success test: .decodeAsPrimitiveList() with right type input #2 (String)',
      () {
        // prepare input
        final source = '["a", "b", "c"]';
        // execute
        final jsonString = JsonString(source);
        final resultList = jsonString.decodeAsPrimitiveList<String>();
        // check
        expect(resultList, isNotNull);
        expect(resultList, TypeMatcher<List<String>>());
      },
    );
    test(
      'success test: .decodeAsPrimitiveList() with right type input #3 (double)',
      () {
        // prepare input
        final source = '[1.0, 2.0, 3.0]';
        // execute
        final jsonString = JsonString(source);
        final resultList = jsonString.decodeAsPrimitiveList<double>();
        // check
        expect(resultList, isNotNull);
        expect(resultList, TypeMatcher<List<double>>());
      },
    );
    test(
      'success test: .decodeAsPrimitiveList() with right type input #4 (bool)',
      () {
        // prepare input
        final source = '[false, true, false]';
        // execute
        final jsonString = JsonString(source);
        final resultList = jsonString.decodeAsPrimitiveList<bool>();
        // check
        expect(resultList, isNotNull);
        expect(resultList, TypeMatcher<List<bool>>());
      },
    );
    test(
      'success test: .decodeAsPrimitiveList() with an empty list',
      () {
        // prepare input
        final source = '[]';
        // execute
        final jsonString = JsonString(source);
        final intList = jsonString.decodeAsPrimitiveList<int>();
        final doubleList = jsonString.decodeAsPrimitiveList<double>();
        final boolList = jsonString.decodeAsPrimitiveList<bool>();
        final stringList = jsonString.decodeAsPrimitiveList<String>();
        // check
        expect(intList, TypeMatcher<List<int>>());
        expect(doubleList, TypeMatcher<List<double>>());
        expect(boolList, TypeMatcher<List<bool>>());
        expect(stringList, TypeMatcher<List<String>>());
      },
    );
    test(
      'success test: .decodeAsPrimitiveList() with a null filled list (TO BE MONITORED)',
      () {
        // prepare input
        final source = '[null, null, null]';
        // execute
        final jsonString = JsonString(source);
        final intList = jsonString.decodeAsPrimitiveList<int?>();
        final doubleList = jsonString.decodeAsPrimitiveList<double?>();
        final boolList = jsonString.decodeAsPrimitiveList<bool?>();
        final stringList = jsonString.decodeAsPrimitiveList<String?>();
        // check
        expect(intList, TypeMatcher<List<int?>>());
        expect(doubleList, TypeMatcher<List<double?>>());
        expect(boolList, TypeMatcher<List<bool?>>());
        expect(stringList, TypeMatcher<List<String?>>());
      },
    );
    test(
      'fail test: try to decode a not-primitive list',
      () {
        final source = '''
        [
          0,
          1,
          {
            "key0": 0,
            "key1": 1,
            "key2": 2
          }
        ]
      ''';
        // execute
        final jsonString = JsonString(source);
        final testCall = () => jsonString.decodeAsPrimitiveList<int>();
        // check
        expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
      },
    );
  });
}
