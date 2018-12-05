import 'dart:core';

abstract class _Jsonable extends Object {
  static Jsonable fromJson(Map<String, dynamic> json) {
    throw "This method must be implemented!";
  }

  Map<String, dynamic> toJson();
}

/// An object directly encodable into a valid JSON.
mixin Jsonable implements _Jsonable {}
