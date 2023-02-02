import 'package:collection/collection.dart';
import 'package:json_string/json_string.dart';

void main() {
  const externalSource = '{"username":"john_doe","password":"querty"}';
  var jsonString = JsonString.orNull(externalSource);
  if (jsonString == null) {
    print('Bad source!');
    return;
  }
  final user1 = jsonString.decodeAsObject(User.fromJson);
  final user2 = User(username: 'clara_brothers', password: 'asdfgh');
  final userList = [user1, user2];

  jsonString = JsonString.encodeObjectList(userList);
  final internalSource = jsonString.source;
  print(internalSource);

  final decodedList = jsonString.decodeAsObjectList(User.fromJson);
  print(ListEquality<User>().equals(decodedList, userList)); // true
}

class User with Jsonable {
  String username;
  String password;

  User({
    required this.username,
    required this.password,
  });

  static User fromJson(Map<String, dynamic> json) => User(
        username: json['username'] as String,
        password: json['password'] as String,
      );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
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
