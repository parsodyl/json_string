import 'dart:convert';

import 'package:json_string/src/errors.dart';
import 'package:json_string/src/functions.dart';
import 'package:json_string/src/utils.dart';

class JsonString {
  final String source;

  // <<constructors>>

  factory JsonString(String source) {
    assert(source != null);
    try {
      final decodedSource = _decode(source);
      return JsonString._(_encode(decodedSource));
    } on FormatException catch (e) {
      throw JsonFormatException.fromParent(e);
    } catch (_) {
      throw JsonFormatException(
          "This source does not rapresent a valid json.", source);
    }
  }

  factory JsonString.orNull(String source) {
    assert(source != null);
    try {
      final decodedSource = _decode(source);
      return JsonString._(_encode(decodedSource));
    } catch (_) {
      return null;
    }
  }

   // <<encoders>>

  JsonString.encode(Object value, {encoder(object)})
      : this.source = _encodeSafely(value, encoder: encoder);

  // <<encoders>>

  dynamic get decodedValue => _decode(this.source);

  static JsonString encodeObject<T extends Object>(T value,
      {JsonObjectEncoder<T> encoder}) {
    assert(value != null);
    final dynamicMap = disassembleObject<T>(value, builder: encoder);
    return JsonString.encode(dynamicMap);
  }

  // <<standard methods>>

  const JsonString._(this.source);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is JsonString &&
          runtimeType == other.runtimeType &&
          source == other.source;

  @override
  int get hashCode => source.hashCode;

  @override
  String toString() {
    return 'JsonString{source: $source}';
  }

  static Object _decode(String source,
      {Function(Object key, Object value) decoder}) {
    assert(source != null);
    return json.decode(source, reviver: decoder);
  }

  static String _encode(Object value, {Function(Object) encoder}) {
    return json.encode(value, toEncodable: encoder);
  }

  static String _encodeSafely(Object value, {Function(Object) encoder}) {
    assert(value != null);
    try {
      return json.encode(value, toEncodable: encoder);
    } catch (e) {
      throw JsonEncodingError(e);
    }
  }

}