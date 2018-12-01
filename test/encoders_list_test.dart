import 'package:test/test.dart';
import 'package:json_string/json_string.dart';

class User with Jsonable {
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

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  Map<String, dynamic> toSecureJson() => {
        'username': username,
        'password': String.fromCharCodes(
            List.filled(password.length, "*".codeUnitAt(0))),
      };
}

void main() {
  setUp(() {
    // setup
  });
  tearDown(() {
    // teardown
  });
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
  test(
    'fail test: .encodeObjectList() with null imputs #1',
    () {
      // prepare input
      final data = null;
      // execute
      final testCall = () => JsonString.encodeObjectList(data);
      // check
      expect(testCall, throwsA(TypeMatcher<AssertionError>()));
    },
  );
  test(
    'success test: encode an object list #1 (Jsonable w/out encoder)',
    () {
      // prepare input
      final user1 = User(username: 'john_doe', password: 'querty');
      final user2 = User(username: 'clara_brothers', password: 'qwerty');
      final data = [user1, user2];
      // execute
      final jsonString = JsonString.encodeObjectList(data);
      // check
      expect(jsonString, isNotNull);
      expect(jsonString, TypeMatcher<JsonString>());
    },
  );
  test(
    'success test: encode an object list #2 (Jsonable w/ encoder)',
    () {
      // prepare input
      final user1 = User(username: 'john_doe', password: 'querty');
      final user2 = User(username: 'clara_brothers', password: 'qwerty');
      final data = [user1, user2];
      // execute
      final jsonString =
          JsonString.encodeObjectList(data, encoder: (user) => user.toJson());
      // check
      expect(jsonString, isNotNull);
      expect(jsonString, TypeMatcher<JsonString>());
    },
  );
  test(
    'success test: encode an object list #3 (contains null values)',
    () {
      // prepare input
      final user1 = User(username: 'john_doe', password: 'querty');
      final user2 = null;
      final data = [user1, user2];
      // execute
      final jsonString =
          JsonString.encodeObjectList(data, encoder: (user) => user.toJson());
      // check
      expect(jsonString, isNotNull);
      expect(jsonString, TypeMatcher<JsonString>());
    },
  );
  test(
    'fail test: try to encode a primitive list as Object list #1',
    () {
      // prepare input
      final data = [1, 2, 3];
      // execute
      final testCall = () => JsonString.encodeObjectList(data);
      // check
      expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
    },
  );
  test(
    'fail test: try to encode a mixed list as Object list #1',
    () {
      // prepare input
      final user1 = User(username: 'john_doe', password: 'querty');
      final data = [0, user1, "2"];
      // execute
      final testCall = () => JsonString.encodeObjectList(data);
      // check
      expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
    },
  );
}
