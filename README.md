# json_string

[![Pub](https://img.shields.io/pub/v/json_string.svg)](https://pub.dartlang.org/packages/json_string)

A simple and lightweight JSON data container for Dart and Flutter.

## Configure

Add `json_string` to `pubspec.yaml` under the `dependencies` subsection.

```yaml
dependencies:
  json_string: ^0.1.0
```
## Install

Install packages from the command line (or using your favourite IDE).

with **pub**:

```bash
$ pub get
```

with **flutter**:

```bash
$ flutter packages get
```

## Import

In your library, add the following line:

```dart
import 'package:json_string/json_string.dart';
```
## How to use it

All you need is the `JsonString` class. This is where your JSON data is stored.
When you create a new instance, your JSON data is **evaluated** and **minified**.

### Overview

Check if your string represents a valid JSON, simply using the default constructor:

```dart
try {
    final jsonString = JsonString('{"username":"john_doe","password":"querty"}');
    // ...
} on JsonFormatException catch (e) {
    print('Invalid JSON format: $e');
}
```

Or just work with null values, if you prefer:

```dart
final jsonString = JsonString.orNull('{"username":"john_doe","password":"querty"}');

if(jsonString == null) {
    print('Invalid JSON format');
}
// ...
```

Then, access your data through the `source` property:

```dart
final source = jsonString.source;

print(source); // {"username":"john_doe","password":"querty"}
```
Or, read the equivalent `decodedValue` object, without using any other library:

```dart
final credentials = jsonString.decodedValue;

print(credentials['username']); // john_doe
print(credentials['password']); // querty
```

### Encoding

JsonString provides a set of different methods to encode Dart types, all implemented in a **type-safe** way and without any use of reflection or code generators.

#### Plain objects

Mark as `Jsonable` your "json2dart" style class, and encode it with no effort:

```dart
// class declaration
class User with Jsonable {
  String username;
  String password;

  User({
    this.username,
    this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}

// encoding
final user = User(username: 'john_doe', password: 'qwerty');
final jsonString = JsonString.encodeObject(user);
```

Or, provide an `encoder` to specify how to map your object:

```dart
final jsonString = JsonString.encodeObject(user, encoder: (u) => {
    'ba': btoa("${u.username}:${u.password}"),
});
```

#### Object lists

In the same way, you can encode a list of objects:

```dart
final userList = [
    User(username: 'john_doe', password: 'qwerty'),
    User(username: 'clara_brothers', password: 'asdfgh')
];

// default encoding
final jsonString1 = JsonString.encodeObjectList(userList);

// custom encoding
final jsonString2 = JsonString.encodeObjectList(userList, encoder: (u) => {
    'ba': btoa("${u.username}:${u.password}"),
});
```
#### Primitive lists

If you want to encode a list of primitive values (**int**, **double**, **String** or **bool**), use `encodePrimitiveList()`:

```dart
// integers
final fibonacci = [1, 1, 2, 3, 5, 8, 13];
final jsonString = JsonString.encodePrimitiveList(fibonacci);

// strings
final message = ["h", "e", "l", "l", "o", "!"];
final jsonString = JsonString.encodePrimitiveList(message);

// doubles
final temperatures = [16.0, 18.0, 21.0, 19.0];
final jsonString = JsonString.encodePrimitiveList(temperatures);

// booleans
final flags = [false, false, true, false];
final jsonString = JsonString.encodePrimitiveList(flags);
```



## Contribute

If you find a bug or you would like to see a new feature, please create an [issue](https://github.com/parsodyl/json_string/issues). 
