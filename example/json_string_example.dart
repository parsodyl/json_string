import 'package:json_string/json_string.dart';

void main() {
  const externalSource = '{"username":"john_doe","password":"querty"}';
  var jsonString = JsonString.orNull(externalSource);
  if(jsonString == null) {
    print("Bad source!");
  }
  final user1 = User.fromJson(jsonString.decodedValue);
  final user2 = User(username: 'clara_brothers', password: 'asdfgh');
  final userList = [user1, user2];
  
  jsonString = JsonString.encodeObjectList(userList);
  final internalSource = jsonString.source;
  print(internalSource);
}

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
}
