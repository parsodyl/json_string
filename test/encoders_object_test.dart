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

class Car {
  String brand;
  String model;

  Car({
    this.brand,
    this.model,
  });

  static Car fromJson(Map<String, dynamic> json) {
    return Car(
      brand: json['brand'],
      model: json['model'],
    );
  }

  Map<String, dynamic> toJson() => {
        'brand': brand,
        'model': model,
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
    'fail test: .encodeObject() with null imputs #1',
    () {
      // prepare input
      final data = null;
      // execute
      final testCall = () => JsonString.encodeObject(data);
      // check
      expect(testCall, throwsA(TypeMatcher<AssertionError>()));
    },
  );
  test(
    'success test: encode a Jsonable object #1 (w/out encoder)',
    () {
      // prepare input
      final data = User(username: 'john_doe', password: 'qwerty');
      // execute
      final jsonString = JsonString.encodeObject<User>(data);
      // check
      expect(jsonString, isNotNull);
      expect(jsonString, TypeMatcher<JsonString>());
    },
  );
  test(
    'success test: encode a Jsonable object #2 (w/ encoder)',
    () {
      // prepare input
      final data = User(username: 'john_doe', password: 'qwerty');
      // execute
      final jsonString = JsonString.encodeObject<User>(data,
          encoder: (user) => user.toSecureJson());
      // check
      expect(jsonString, isNotNull);
      expect(jsonString, TypeMatcher<JsonString>());
    },
  );
  test(
    'fail test: try to encode a not-Jsonable object #1 (w/out encoder)',
    () {
      // prepare input
      final data = Car(brand: 'Fiat', model: 'Punto');
      // execute
      final testCall = () => JsonString.encodeObject<Car>(data);
      // check
      expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
    },
  );
  test(
    'success test: try to encode a not-Jsonable object #2 (w/ encoder)',
    () {
      // prepare input
      final data = Car(brand: 'Fiat', model: 'Punto');
      // execute
      final testCall = () =>
          JsonString.encodeObject<Car>(data, encoder: (car) => car.toJson());
      final jsonString = testCall();
      // check
      expect(testCall, isNot(throwsA(TypeMatcher<JsonEncodingError>())));
      expect(jsonString, isNotNull);
      expect(jsonString, TypeMatcher<JsonString>());
    },
  );
  test(
    'fail test: try to encode a primitive datatype #1',
    () {
      // prepare input
      final data = "Hello!";
      // execute
      final testCall = () => JsonString.encodeObject(data);
      // check
      expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
    },
  );
}
