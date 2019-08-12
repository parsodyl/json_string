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
    'fail test: .decodedValueAsPrimitiveList() with no type input',
    () {
      // prepare input
      final source = '[1, 2, 3]';
      // execute
      final jsonString = JsonString(source);
      final testCall = () => jsonString.decodedValueAsPrimitiveList();
      // check
      expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
    },
  );
  test(
    'fail test: .decodedValueAsPrimitiveList() with wrong type input #1 (not primitive)',
    () {
      // prepare input
      final source = '[1, 2, 3]';
      // execute
      final jsonString = JsonString(source);
      final testCall = () => jsonString.decodedValueAsPrimitiveList<User>();
      // check
      expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
    },
  );
  test(
    'fail test: .decodedValueAsPrimitiveList() with wrong type input #2 (String instead of int)',
    () {
      // prepare input
      final source = '[1, 2, 3]';
      // execute
      final jsonString = JsonString(source);
      final testCall = () => jsonString.decodedValueAsPrimitiveList<String>();
      // check
      expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
    },
  );
  test(
    'fail test: .decodedValueAsPrimitiveList() with wrong type input #3 (int instead of double)',
    () {
      // prepare input
      final source = '[1.0, 2.0, 3.0]';
      // execute
      final jsonString = JsonString(source);
      final testCall = () => jsonString.decodedValueAsPrimitiveList<String>();
      // check
      expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
    },
  );
  test(
    'success test: .decodedValueAsPrimitiveList() with right type input #1 (int)',
    () {
      // prepare input
      final source = '[1, 2, 3]';
      // execute
      final jsonString = JsonString(source);
      final resultList = jsonString.decodedValueAsPrimitiveList<int>();
      // check
      expect(resultList, isNotNull);
      expect(resultList, TypeMatcher<List<int>>());
    },
  );
  test(
    'success test: .decodedValueAsPrimitiveList() with right type input #2 (String)',
    () {
      // prepare input
      final source = '["a", "b", "c"]';
      // execute
      final jsonString = JsonString(source);
      final resultList = jsonString.decodedValueAsPrimitiveList<String>();
      // check
      expect(resultList, isNotNull);
      expect(resultList, TypeMatcher<List<String>>());
    },
  );
  test(
    'success test: .decodedValueAsPrimitiveList() with right type input #3 (double)',
    () {
      // prepare input
      final source = '[1.0, 2.0, 3.0]';
      // execute
      final jsonString = JsonString(source);
      final resultList = jsonString.decodedValueAsPrimitiveList<double>();
      // check
      expect(resultList, isNotNull);
      expect(resultList, TypeMatcher<List<double>>());
    },
  );
  test(
    'success test: .decodedValueAsPrimitiveList() with right type input #4 (bool)',
    () {
      // prepare input
      final source = '[false, true, false]';
      // execute
      final jsonString = JsonString(source);
      final resultList = jsonString.decodedValueAsPrimitiveList<bool>();
      // check
      expect(resultList, isNotNull);
      expect(resultList, TypeMatcher<List<bool>>());
    },
  );
  test(
    'success test: .decodedValueAsPrimitiveList() with an empty list',
    () {
      // prepare input
      final source = '[]';
      // execute
      final jsonString = JsonString(source);
      final intList = jsonString.decodedValueAsPrimitiveList<int>();
      final doubleList = jsonString.decodedValueAsPrimitiveList<double>();
      final boolList = jsonString.decodedValueAsPrimitiveList<bool>();
      final stringList = jsonString.decodedValueAsPrimitiveList<String>();
      // check
      expect(intList, TypeMatcher<List<int>>());
      expect(doubleList, TypeMatcher<List<double>>());
      expect(boolList, TypeMatcher<List<bool>>());
      expect(stringList, TypeMatcher<List<String>>());
    },
  );
  test(
    'success test: .decodedValueAsPrimitiveList() with a null filled list',
    () {
      // prepare input
      final source = '[null, null, null]';
      // execute
      final jsonString = JsonString(source);
      final intList = jsonString.decodedValueAsPrimitiveList<int>();
      final doubleList = jsonString.decodedValueAsPrimitiveList<double>();
      final boolList = jsonString.decodedValueAsPrimitiveList<bool>();
      final stringList = jsonString.decodedValueAsPrimitiveList<String>();
      // check
      expect(intList, TypeMatcher<List<int>>());
      expect(doubleList, TypeMatcher<List<double>>());
      expect(boolList, TypeMatcher<List<bool>>());
      expect(stringList, TypeMatcher<List<String>>());
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
      final testCall = () => jsonString.decodedValueAsPrimitiveList<int>();
      // check
      expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
    },
  );
  test(
    'fail test: .decodedValueAsObjectList() with null input',
    () {
      // prepare input
      final source = '[{"username":"john_doe","password":"querty"}]';
      // execute
      final jsonString = JsonString(source);
      final testCall = () => jsonString.decodedValueAsObjectList(null);
      // check
      expect(testCall, throwsA(TypeMatcher<AssertionError>()));
    },
  );
  test(
    'success test: .decodedValueAsObjectList() with a proper decoder',
    () {
      // prepare input
      final source = '[{"username":"john_doe","password":"querty"}]';
      // execute
      final jsonString = JsonString(source);
      final resultObject = jsonString.decodedValueAsObjectList(User.fromJson);

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
      final testCall = () => jsonString.decodedValueAsObjectList(User.fromJson);
      // check
      expect(testCall, throwsA(TypeMatcher<JsonDecodingError>()));
    },
  );
  test(
    'success test: .decodedValueAsObjectList() with a null filled list',
    () {
      // prepare input
      final source = '[null, null, null]';
      // execute
      final jsonString = JsonString(source);
      final objectList = jsonString.decodedValueAsObjectList(User.fromJson);
      // check
      expect(objectList, isNotNull);
      expect(objectList, hasLength(isNonZero));
      expect(objectList, TypeMatcher<List<User>>());
    },
  );
}