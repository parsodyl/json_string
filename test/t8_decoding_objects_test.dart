import 'package:json_string/json_string.dart';
import 'package:test/test.dart';

void main() {
  group('Object (non-nullable) decode method', () {
    test(
      'success test: decode object with a proper decoder',
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
      'fail test: this is null',
      () {
        // prepare input
        final source = 'null';
        // execute
        final jsonString = JsonString(source);
        final testCall = () => jsonString.decodeAsObject(User.fromJson);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
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
  group('Object (nullable) decode method', () {
    test(
      'success test: decode nullable object with a proper decoder',
      () {
        // prepare input
        final source = '{"username":"john_doe","password":"querty"}';
        // execute
        final jsonString = JsonString(source);
        final resultObject =
            jsonString.decodeAsNullableObject(User.fromNullableJson);

        // check
        expect(resultObject, isNotNull);
        expect(resultObject, TypeMatcher<User>());
      },
    );
    test(
      'success test: this is null',
      () {
        // prepare input
        final source = 'null';
        // execute
        final jsonString = JsonString(source);
        final resultObject =
            jsonString.decodeAsNullableObject(User.fromNullableJson);

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
        final testCall =
            () => jsonString.decodeAsNullableObject(User.fromNullableJson);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
      },
    );
  });
  group('Object-list (non-nullable) decode method', () {
    test(
      'success test: decode as object list with a proper decoder',
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
      'fail test: this list contains null values',
      () {
        final source = '[{"username":"john_doe","password":"querty"}, null]';
        // execute
        final jsonString = JsonString(source);
        final testCall = () => jsonString.decodeAsObjectList(User.fromJson);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
      },
    );
    test(
      'fail test: null-filled list',
      () {
        final source = '[null, null]';
        // execute
        final jsonString = JsonString(source);
        final testCall = () => jsonString.decodeAsObjectList(User.fromJson);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
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
  });
  group('Object-list (nullable) decode method', () {
    test(
      'success test: decode as nullable object list with a proper decoder',
      () {
        // prepare input
        final source = '[{"username":"john_doe","password":"querty"}]';
        // execute
        final jsonString = JsonString(source);
        final resultObject =
            jsonString.decodeAsNullableObjectList(User.fromNullableJson);

        // check
        expect(resultObject, isNotNull);
        expect(resultObject, hasLength(isNonZero));
        expect(resultObject, TypeMatcher<List<User>>());
      },
    );
    test(
      'success test: this list contains null values',
      () {
        final source = '[{"username":"john_doe","password":"querty"}, null]';
        // execute
        final jsonString = JsonString(source);
        final resultObject =
            jsonString.decodeAsNullableObjectList(User.fromNullableJson);

        // check
        expect(resultObject, isNotNull);
        expect(resultObject, hasLength(isNonZero));
        expect(resultObject, TypeMatcher<List<User>>());
      },
    );
    test(
      'success test: null-filled list',
      () {
        final source = '[null, null]';
        // execute
        final jsonString = JsonString(source);
        final resultObject =
            jsonString.decodeAsNullableObjectList(User.fromNullableJson);

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
        final testCall =
            () => jsonString.decodeAsNullableObjectList(User.fromNullableJson);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
      },
    );
  });
}

class User {
  String? username;
  String? password;

  User({
    this.username,
    this.password,
  });

  static User fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String?,
      password: json['password'] as String?,
    );
  }

  static User fromNullableJson(Map<String, dynamic>? json) {
    return User(
      username: json?['username'] as String?,
      password: json?['password'] as String?,
    );
  }
}
