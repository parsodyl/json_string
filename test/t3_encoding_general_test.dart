import 'package:json_string/json_string.dart';
import 'package:test/test.dart';

void main() {
  group('Built-in encode method, ', () {
    test(
      'success test: call encode() with null input',
      () {
        // prepare input
        final dynamic data = null;
        // execute
        final jsonString = JsonString.encode(data);
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
        expect(jsonString.source, equals('null'));
      },
    );
    test(
      'success test: call encode() with generic Dart datatypes #1',
      () {
        // prepare input
        final data = {
          'FCA': ['Jeep', 'Alfa Romeo', 'Chrysler', 'Lancia']
        };
        // execute
        final jsonString = JsonString.encode(data);
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'success test: call encode() with generic Dart datatypes #2',
      () {
        // prepare input
        final data = [
          1,
          'H',
          3.15,
          [
            [
              ['W']
            ]
          ]
        ];
        // execute
        final jsonString = JsonString.encode(data);
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'fail test: try to encode a Dart hashset #1 (w/out encoder)',
      () {
        // prepare input
        final data = Set.of([1, 2, 3, 3, 1, 2, 2]);
        // execute
        final testCall = () => JsonString.encode(data);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
      },
    );
    test(
      'success test: try to encode a Dart hashset #2 (w/ encoder)',
      () {
        // prepare input
        final data = Set.of([1, 2, 3, 3, 1, 2, 2]);
        // execute
        final testCall = () => JsonString.encode(data, encoder: (e) {
              return (e is Set) ? e.toList() : e;
            });
        final jsonString = testCall();
        // check
        expect(testCall, isNot(throwsA(TypeMatcher<JsonEncodingError>())));
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'fail test: try to encode a JsonString instance #1 (w/out encoder)',
      () {
        // prepare input
        final data = JsonString('{"hello":"world"}');
        // execute
        final testCall = () => JsonString.encode(data);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
      },
    );
    test(
      'success test: try to encode a JsonString instance #2 (w/ encoder)',
      () {
        // prepare input
        final data = JsonString('{"hello":"world"}');
        // execute
        final testCall = () => JsonString.encode(data, encoder: (e) {
              if (e is JsonString) {
                return {'source': e.source};
              }
              return e;
            });
        final jsonString = testCall();
        // check
        expect(testCall, isNot(throwsA(TypeMatcher<JsonEncodingError>())));
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'success test: try to encode an object instance with a valid .toJson() method',
      () {
        // prepare input
        final data = Data('Hey!');
        // execute
        final testCall = () => JsonString.encode(data);
        final jsonString = testCall();
        // check
        expect(testCall, isNot(throwsA(TypeMatcher<JsonEncodingError>())));
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
  });
}

class Data {
  final String content;

  Data(this.content);

  dynamic toJson() => content;
}
