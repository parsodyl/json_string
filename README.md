# json_string

[![Dart CI](https://github.com/parsodyl/json_string/workflows/Dart%20CI/badge.svg)](https://github.com/parsodyl/json_string/actions) [![codecov](https://codecov.io/gh/parsodyl/json_string/branch/master/graph/badge.svg)](https://codecov.io/gh/parsodyl/json_string) [![Pub](https://img.shields.io/pub/v/json_string.svg)](https://pub.dartlang.org/packages/json_string)

A simple and lightweight JSON data container for Dart and Flutter.

## Why?

The Dart language doesn't have an official way to mark an object as a piece of JSON data. You have to carry it in a simple string and then use `dart:convert` when you need the decoded value. 
Furthermore, since [JsonCodec](https://api.dartlang.org/stable/dart-convert/JsonCodec-class.html) is designed for general purpose, encoding and decoding operations result completely type-unsafe.
**json_string** not only keeps your JSON data as light as possible, but also encapsulates `dart:convert` directly into it, offering you better [soundness](https://dart.dev/guides/language/sound-dart) and a much clearer syntax.

## Configure

Add `json_string` to `pubspec.yaml` under the `dependencies` subsection.

```yaml
dependencies:
  json_string: ^3.0.1
```
## Install

Install packages from the command line (or using your favourite IDE).

with **pub**:

```bash
$ pub get
```

with **flutter**:

```bash
$ flutter pub get
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

if (jsonString == null) {
    print('Invalid JSON format');
}
// ...
```

Then, access your data through the `source` property:

```dart
final source = jsonString.source;

print(source); // {"username":"john_doe","password":"querty"}
```
Or read the equivalent `decodedValue` object, without using any other library:

```dart
final credentials = jsonString.decodedValue;

print(credentials['username']); // john_doe
print(credentials['password']); // querty
```

### Encoding

JsonString provides a set of different methods to encode Dart types, all implemented in a **type-safe** way.

#### Plain objects

Mark as `Jsonable` your "json2dart" style class, so you won't forget to implement the `toJson()` method:

```dart
// class declaration
class User with Jsonable {
  String username;
  String password;

  User({
    required this.username,
    required this.password,
  });
  
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
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

If you want to encode a list of primitive values (**int**, **double**, **String**, **bool** or **Null**), use `encodePrimitiveList()`:

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

// nulls
final usefulList = [null, null, null, null];
final jsonString = JsonString.encodePrimitiveList(usefulList);
```
#### Primitive values

Sometimes you have to encode just a single value, in that case use `encodePrimitiveValue()`:

```dart
// integer
final answer = 42;
final jsonString = JsonString.encodePrimitiveValue(answer);

// string
final message = "hello!";
final jsonString = JsonString.encodePrimitiveValue(message);

// double
final pi = 3.14159;
final jsonString = JsonString.encodePrimitiveValue(pi);

// boolean
final amIaGenius = false;
final jsonString = JsonString.encodePrimitiveValue(amIaGenius);

// null
final usefulValue = null;
final jsonString = JsonString.encodePrimitiveValue(usefulValue);
```

### Decoding

It's time to access the Dart counterpart of some JSON data. 
Here json_string helps you with several solutions. You have **properties** for simple general access and **methods** for some finer decoding operations.

#### Properties

When you construct a JsonString object, it checks on your behalf if the source represents a valid piece of JSON data, but it doesn’t tell you **what kind of data** it contains.
If you don’t know the expected type or you simply don’t care about it, just access the `decodedValue` property. It works every time: 

```dart
// any type
final decodedValue = jsonString.decodedValue;
```

But since most of the time you need to cope with big objects or lists, if you have this information before, it is better to use `decodedValueAsMap` or `decodedValueAsList`:

```dart
// object expected
try {
    final decodedObject = jsonString.decodedValueAsMap;
    print(decodedObject.runtimeType); // Map<String, dynamic>
} on JsonDecodingError catch (e) {
    throw "This is not an object.";
}

// list expected
try {
    final decodedList = jsonString.decodedValueAsList;
    print(decodedList.runtimeType); // List<dynamic>
} on JsonDecodingError catch (e) {
    throw "This is not a list.";
}
```

#### Methods

Decoding methods are similar to the encoding ones. They simply do the job the other way round.

##### Plain objects and object lists (non-nullable)

```dart
// class declaration
class User {
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
}

// object decoding
final jsonString = JsonString('{"username":"john_doe","password":"querty"}');

final user = jsonString.decodeAsObject(User.fromJson);

// object list decoding
final jsonString = JsonString('''[
  {"username":"john_doe","password":"querty"},
  {"username":"clara_brothers","password":"asdfgh"}
]''');

final userList = jsonString.decodeAsObjectList(User.fromJson);
```

##### Plain objects and object lists (nullable)

```dart
// class declaration
class User {
  String? username;
  String? password;

  User({
    this.username,
    this.password,
  });

  static User fromJson(Map<String, dynamic>? json) => User(
        username: json?['username'] as String?,
        password: json?['password'] as String?,
      );
}

// object decoding
final jsonString = JsonString('null');

final user = jsonString.decodeAsNullableObject(User.fromJson);

// object list decoding
final jsonString = JsonString('''[
  {"username":"john_doe","password":"querty"},
  null
]''');

final userList = jsonString.decodeAsNullableObjectList(User.fromJson);
```

##### Primitive lists

```dart
// integer list decoding
final jsonString = JsonString('[1, 1, 2, 3, 5, 8, 13]');
final fibonacci = jsonString.decodeAsPrimitiveList<int>();

// string list decoding
final jsonString = JsonString('["h", "e", "l", "l", "o", "!"]');
final message = jsonString.decodeAsPrimitiveList<String>();

// double list decoding
final jsonString = JsonString('[16.0, 18.0, 21.0, 19.0]');
final temperatures = jsonString.decodeAsPrimitiveList<double>();

// boolean list decoding
final jsonString = JsonString('[false, false, true, false]');
final flags = jsonString.decodeAsPrimitiveList<bool>();
```

##### Primitive values

```dart
// integer value decoding
final jsonString = JsonString('42');
final answer = jsonString.decodeAsPrimitiveValue<int>();

// string value decoding
final jsonString = JsonString('hello!');
final message = jsonString.decodeAsPrimitiveValue<String>();

// double value decoding
final jsonString = JsonString('3.14159');
final pi = jsonString.decodeAsPrimitiveValue<double>();

// boolean value decoding
final jsonString = JsonString('false');
final amIaGenius = jsonString.decodeAsPrimitiveValue<bool>();
```

##### Nullable primitive lists and values

```dart
// nullable integer list decoding
final jsonString = JsonString('[42, null, 25, 74, null]');
final availableAges = jsonString.decodeAsPrimitiveList<int?>();

// nullable integer value decoding
final jsonString = JsonString('null');
final maybeAnswer = jsonString.decodeAsPrimitiveValue<int?>();
```

### Advanced

Here's a list of some advanced available options.

#### Complex encoding

If you need to encode complicated structures, you can use `JsonString.encode()` which is just a wrapper around the built-in `dart:convert` [encode](https://api.dartlang.org/stable/dart-convert/JsonCodec/encode.html) method:

```dart
const data = [{
  "key0": [1, 2, 3],
  "key1": 123,
  "key2": "123",
}, "value1", false];
try {
  final jsonString = JsonString.encode(data);
  // ...
} on JsonEncodingError catch (e) {
  print('${data.toString()} is impossible to encode : $e');
}
```

#### Caching

Decoding operations may take time and be expensive in terms of computing resources. When you construct a JsonString object, you can specify an `enableCache` flag, which keeps a copy of the `decodedValue` property. This makes every usage of decoding properties or methods **way faster**. The only drawback to this is the necessary memory occupation:

```dart
final jsonString = JsonString(source, enableCache: true);
final decodedMap = jsonString.decodedValueAsMap; // immediate access
```

#### Turn off Jsonable check

If you don't want to use `Jsonable`, you can set `checkIfJsonable` to **false** when encoding objects.

```dart
// singleObject is not a Jsonable object
final jsonString = JsonString.encodeObject(singleObject, checkIfJsonable: false);
// objectList is not a list of Jsonable objects
final jsonString = JsonString.encodeObjectList(objectList, checkIfJsonable: false);
```

## Contribute

If you find a bug, or you would like to see a new feature, please create an [issue](https://github.com/parsodyl/json_string/issues). 
