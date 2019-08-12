import 'package:json_string/json_string.dart';
import 'package:collection/collection.dart';

void main() {
  const externalSource = '{"username":"john_doe","password":"querty"}';
  var jsonString = JsonString.orNull(externalSource);
  if (jsonString == null) {
    print("Bad source!");
  }
  final user1 = jsonString.decodedValueAsObject(User.fromJson);
  final user2 = User(username: 'clara_brothers', password: 'asdfgh');
  final userList = [user1, user2];

  jsonString = JsonString.encodeObjectList(userList);
  final internalSource = jsonString.source;
  print(internalSource);

  final decodedList = jsonString.decodedValueAsObjectList(User.fromJson);
  print(ListEquality().equals(decodedList, userList)); // true
}

class User with Jsonable {
  String username;
  String password;

  User({
    this.username,
    this.password,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        username: json['username'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          username == other.username &&
          password == other.password;
}
