import 'package:test/test.dart';
import 'package:json_string/json_string.dart';

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

void main() {
  setUp(() {
    // setup
  });
  tearDown(() {
    // teardown
  });
  test(
    'fail test: .decodedValueAsObject() with null input',
    () {
      // prepare input
      final source = '{"username":"john_doe","password":"querty"}';
      // execute
      final jsonString = JsonString(source);
      final testCall = () => jsonString.decodedValueAsObject(null);
      // check
      expect(testCall, throwsA(TypeMatcher<AssertionError>()));
    },
  );
  test(
    'success test: .decodedValueAsObject() with a proper decoder',
    () {
      // prepare input
      final source = '{"username":"john_doe","password":"querty"}';
      // execute
      final jsonString = JsonString(source);
      final resultObject = jsonString.decodedValueAsObject(User.fromJson);

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
      final testCall = () => jsonString.decodedValueAsObject(User.fromJson);
      // check
      expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
    },
  );
}