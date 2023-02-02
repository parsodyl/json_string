import 'package:json_string/json_string.dart';
import 'package:test/test.dart';

void main() {
  group('Object encode method', () {
    test(
      'success test: encode an object with null input #1',
      () {
        // prepare input
        final User? data = null;
        // execute
        final jsonString = JsonString.encodeObject<User?>(data);
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
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
      'success test: encode a not Jsonable object #1 (w/out encoder + no check)',
      () {
        // prepare input
        final data = Car(brand: 'Fiat', model: 'Punto');
        // execute
        final jsonString =
            JsonString.encodeObject<Car>(data, checkIfJsonable: false);
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'fail test: try to encode a not-Jsonable object #1 (w/out encoder + check)',
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
        final testCall = () => JsonString.encodeObject<Car>(data,
            encoder: (car) => <String, dynamic>{
                  'brand': car.brand,
                  'model': car.model,
                });
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
        final data = 'Hello!';
        // execute
        final testCall = () => JsonString.encodeObject(data);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
      },
    );
  });
  group('Object-list encode method', () {
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
        final jsonString = JsonString.encodeObjectList(data,
            encoder: (User user) => user.toJson());
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'fail test: try to encode a not-Jsonable object list #1 (w/out encoder + check)',
      () {
        // prepare input
        final car1 = Car(brand: 'Fiat', model: 'Punto');
        final car2 = Car(brand: 'Audi', model: 'A4');
        final data = [car1, car2];
        // execute
        final testCall = () => JsonString.encodeObjectList(data);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
      },
    );
    test(
      'success test: try to encode a not-Jsonable object list #2  (w/out encoder + no check)',
      () {
        // prepare input
        final car1 = Car(brand: 'Fiat', model: 'Punto');
        final car2 = Car(brand: 'Audi', model: 'A4');
        final data = [car1, car2];
        // execute
        final jsonString =
            JsonString.encodeObjectList(data, checkIfJsonable: false);
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
        final data = <User?>[user1, null];
        // execute
        final jsonString = JsonString.encodeObjectList(
          data,
          encoder: (User? user) => user != null ? user.toJson() : null,
        );
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
        final data = [0, user1, '2'];
        // execute
        final testCall = () => JsonString.encodeObjectList(data);
        // check
        expect(testCall, throwsA(TypeMatcher<JsonEncodingError>()));
      },
    );
    test(
      'success test: try to encode a null filled list #1 (implicit type)',
      () {
        // prepare input
        final data = [null, null, null, null, null];
        // execute
        final jsonString = JsonString.encodeObjectList(data);
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
    test(
      'success test: try to encode a null filled list #2 (explicit type)',
      () {
        // prepare input
        final data = [null, null, null, null, null];
        // execute
        final jsonString = JsonString.encodeObjectList<User?>(data);
        // check
        expect(jsonString, isNotNull);
        expect(jsonString, TypeMatcher<JsonString>());
      },
    );
  });
}

class User with Jsonable {
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

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'username': username,
        'password': password,
      };

  Map<String, dynamic> toSecureJson() => <String, dynamic>{
        'username': username,
        'password': password != null
            ? String.fromCharCodes(
                List.filled(
                  password!.length,
                  '*'.codeUnitAt(0),
                ),
              )
            : null,
      };
}

class Car {
  String? brand;
  String? model;

  Car({
    this.brand,
    this.model,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'brand': brand,
        'model': model,
      };
}
