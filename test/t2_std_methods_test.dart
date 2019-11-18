import 'package:json_string/json_string.dart';
import 'package:test/test.dart';

void main() {
  group('== method', () {
    test(
      'success test: compare JsonString objects #1 (same source string)',
      () {
        // prepare input
        final source = '{"username":"john_doe","password":"eiaw"}';
        // execute
        final jsonString1 = JsonString(source);
        final jsonString2 = JsonString(source);
        // check
        expect(jsonString1, equals(jsonString2));
      },
    );
    test(
      'success test: compare JsonString objects #2 (same content)',
      () {
        // prepare input
        final source1 = '''
      {
        "username": "john_doe",
        "password": "eiaw"
      }
      ''';
        final source2 = '{"username":"john_doe","password":"eiaw"}';
        // execute
        final jsonString1 = JsonString(source1);
        final jsonString2 = JsonString(source2);
        // check
        expect(jsonString1, equals(jsonString2));
      },
    );
    test(
      'fail test: compare JsonString objects #3 (same content, different order)',
      () {
        // prepare input
        final source1 = '{"username":"john_doe","password":"eiaw"}';
        final source2 = '{"password":"eiaw", "username":"john_doe"}';
        // execute
        final jsonString1 = JsonString(source1);
        final jsonString2 = JsonString(source2);
        // check
        expect(jsonString1, isNot(equals(jsonString2)));
      },
    );
  });
}
