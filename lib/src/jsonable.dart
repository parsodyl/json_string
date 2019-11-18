import 'dart:core';

abstract class _Jsonable extends Object {
  /// Returns the JSON object representation (Map<String, dynamic>)
  /// of this object.
  Map<String, dynamic> toJson();
}

/// An object that can be encoded into some valid JSON.
mixin Jsonable implements _Jsonable {
  Map<String, dynamic> toMap() {
    return this.toJson();
  }
}
