import 'package:json_string/json_string.dart';
import 'package:test/test.dart';

void main() {
  group('Object decode method', () {
    test(
      'fail test: .decodeAsObject() with null input',
      () {
        // prepare input
        final source = '{"username":"john_doe","password":"querty"}';
        // execute
        final jsonString = JsonString(source);
        final testCall = () => jsonString.decodeAsObject(null);
        // check
        expect(testCall, throwsA(TypeMatcher<AssertionError>()));
      },
    );
    test(
      'success test: .decodeAsObject() with a proper decoder',
      () {
        // prepare input
        final source = '{"username":"john_doe","password":"querty"}';
        // execute
        final jsonString = JsonString(source);
        final resultObject = jsonString.decodeAsObject(User.fromJson);

        // check
        expect(resultObject, isNotNull);
        expect(resultObject, TypeMatcher<User>());
      },
    );
    test(
      'fail test: no, this is not an object',
      () {
        // prepare input
        final source = '["john_doe","querty"]';
        // execute
        final jsonString = JsonString(source);
        final testCall = () => jsonString.decodeAsObject(User.fromJson);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
      },
    );
  });
  group('Object-list decode method', () {
    test(
      'fail test: .decodeAsObjectList() with null input',
      () {
        // prepare input
        final source = '[{"username":"john_doe","password":"querty"}]';
        // execute
        final jsonString = JsonString(source);
        final testCall = () => jsonString.decodeAsObjectList(null);
        // check
        expect(testCall, throwsA(TypeMatcher<AssertionError>()));
      },
    );
    test(
      'success test: .decodeAsObjectList() with a proper decoder',
      () {
        // prepare input
        final source = '[{"username":"john_doe","password":"querty"}]';
        // execute
        final jsonString = JsonString(source);
        final resultObject = jsonString.decodeAsObjectList(User.fromJson);

        // check
        expect(resultObject, isNotNull);
        expect(resultObject, hasLength(isNonZero));
        expect(resultObject, TypeMatcher<List<User>>());
      },
    );
    test(
      'fail test: try to decode a not-object list',
      () {
        final source = '[0, 1, 2, 3]';
        // execute
        final jsonString = JsonString(source);
        final testCall = () => jsonString.decodeAsObjectList(User.fromJson);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
      },
    );
    test(
      'success test: .decodeAsObjectList() with a null filled list',
      () {
        // prepare input
        final source = '[null, null, null]';
        // execute
        final jsonString = JsonString(source);
        final objectList = jsonString.decodeAsObjectList(User.fromJson);
        // check
        expect(objectList, isNotNull);
        expect(objectList, hasLength(isNonZero));
        expect(objectList, TypeMatcher<List<User>>());
      },
    );
  });
}

class User {
  String username;
  String password;

  User({
    this.username,
    this.password,
  });

  static User fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      password: json['password'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          password == other.password;
}
