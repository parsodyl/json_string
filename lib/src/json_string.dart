import 'dart:convert';

import 'package:json_string/src/errors.dart';
import 'package:json_string/src/functions.dart';
import 'package:json_string/src/utils.dart';

/// A single piece of JSON data.
class JsonString {

  /// The JSON data source reppresentation for this object.
  final String source;

  // <<constructors>>

  /// Constructs a [JsonString] if [source] is a valid JSON.
  /// 
  /// If not, it throws a [JsonFormatException].
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

  /// Constructs a JsonString if [source] is a valid JSON.
  /// 
  /// If not, it returns [null].
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

  /// Constructs a [JsonString] converting [value] to a valid JSON.
  /// 
  /// If [value] contains objects that are not directly encodable to 
  /// a valid JSON, the [encoder] function is used to convert it to 
  /// an object that must be directly encodable.
  JsonString.encode(Object value, {encoder(object)})
      : this.source = _encodeSafely(value, encoder: encoder);

  /// Constructs a [JsonString] converting [value] to a 
  /// valid JSON Object.
  /// 
  /// If [T] implements [Jsonable] interface, the result returned 
  /// by `.toJson()` is used during the conversion.
  /// If not, the [encoder] function must be provided.
  static JsonString encodeObject<T extends Object>(T value,
      {JsonObjectEncoder<T> encoder}) {
    assert(value != null);
    final dynamicMap = disassembleObject<T>(value, builder: encoder);
    return JsonString.encode(dynamicMap);
  }

  /// Constructs a [JsonString] converting [list] to a valid JSON List.
  /// 
  /// [T] must be a primitive type (int, double, bool or String).
  static JsonString encodePrimitiveList<T>(List<T> list) {
    assert(list != null);
    final dynamicList = disassemblePrimitiveList<T>(list);
    return JsonString.encode(dynamicList);
  }

  /// Constructs a [JsonString] converting [list] to a valid JSON list.
  /// 
  /// [T] represents a JSON Object, see `.encodeObject()` for reference. 
  static JsonString encodeObjectList<T>(List<T> list,
      {JsonObjectEncoder<T> encoder}) {
    assert(list != null);
    final dynamicList = disassembleObjectList<T>(list, builder: encoder);
    return JsonString.encode(dynamicList);
  }

  // <<decoders>>

  /// The JSON data directly decoded.
  /// 
  /// (JSON Objects are converted to maps with string keys.)
  dynamic get decodedValue => _decode(this.source);

  // <<standard methods>>

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

  // <<private methods>>

  const JsonString._(this.source); 

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
