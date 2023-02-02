import 'dart:core';

abstract class _Jsonable extends Object {
  /// Returns the JSON object representation of this object.
  dynamic toJson();
}

/// An object that can be encoded into some valid JSON.
mixin Jsonable implements _Jsonable {}
