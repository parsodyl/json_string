import 'dart:convert';

import 'package:json_string/src/functions.dart';
import 'package:json_string/src/utils.dart';
import 'package:json_util/json_util.dart';

/// A single piece of JSON data.
class JsonString {
  /// The JSON data source representation for this object.
  final String source;

  // <<constructors>>

  /// Constructs a [JsonString] if [source] is a valid JSON.
  ///
  /// If not, it throws a [JsonFormatException].
  ///
  /// If the optional [enableCache] parameter is set to `true`,
  /// a cache of the decoded value is provided.
  factory JsonString(String source, {bool enableCache = false}) {
    assert(source != null);
    try {
      return _constructJsonString(source, enableCache);
    } on FormatException catch (e) {
      throw JsonFormatException.fromParent(e);
    } catch (_) {
      throw JsonFormatException(
          "This source does not represent a valid JSON.", source);
    }
  }

  /// Constructs a [JsonString] if [source] is a valid JSON.
  ///
  /// If not, it returns [null].
  ///
  /// If the optional [enableCache] parameter is set to `true`,
  /// a cache of the decoded value is provided.
  factory JsonString.orNull(String source, {bool enableCache = false}) {
    assert(source != null);
    try {
      return _constructJsonString(source, enableCache);
    } catch (_) {
      return null;
    }
  }

  // <<encoders>>

  /// Constructs a [JsonString] converting [value] into a valid JSON.
  ///
  /// Attention: this is just a wrapper around the Dart built-in
  /// function `json.encode()`, you should use this in special cases only.
  /// Check the other encoding functions for more common usages.
  JsonString.encode(Object value, {encoder(object)})
      : this.source = _encodeSafely(value, encoder: encoder),
        this._cachedValue = null;

  /// Constructs a [JsonString] converting [value] into a valid JSON
  /// primitive value.
  ///
  /// [T] must be a primitive type (int, double, bool or String).
  static JsonString encodePrimitiveValue<T>(T value) {
    assert(value != null);
    return wrapEncodingOperation(() {
      final encodable = EncodableValue.fromPrimitiveValue<T>(value);
      return JsonString._(encodable.encode(), null);
    });
  }

  /// Constructs a [JsonString] converting [list] into a valid JSON List.
  ///
  /// [T] must be a primitive type (int, double, bool or String).
  static JsonString encodePrimitiveList<T>(List<T> list) {
    assert(list != null);
    return wrapEncodingOperation(() {
      final encodable = EncodableValue.fromPrimitiveList<T>(list);
      return JsonString._(encodable.encode(), null);
    });
  }

  /// Constructs a [JsonString] converting [value] into a
  /// valid JSON Object.
  ///
  /// If [T] implements [Jsonable] interface, the result returned
  /// by `.toJson()` is used during the conversion.
  /// If not, the [encoder] function must be provided.
  static JsonString encodeObject<T extends Object>(T value,
      {JsonObjectEncoder<T> encoder}) {
    assert(value != null);
    return wrapEncodingOperation(() {
      final dyMap = disassembleObject<T>(value, builder: encoder);
      final encodable = EncodableValue.map(dyMap);
      return JsonString._(encodable.encode(), null);
    });
  }

  /// Constructs a [JsonString] converting [list] into a valid JSON list.
  ///
  /// [T] represents a JSON Object, see `.encodeObject()` for reference.
  static JsonString encodeObjectList<T extends Object>(List<T> list,
      {JsonObjectEncoder<T> encoder}) {
    assert(list != null);
    return wrapEncodingOperation(() {
      final dyList = disassembleObjectList<T>(list, builder: encoder);
      final encodable = EncodableValue.list(dyList);
      return JsonString._(encodable.encode(), null);
    });
  }

  // <<decoding properties>>

  /// The JSON data directly decoded as a dynamic type.
  ///
  /// (this is the most general one.)
  dynamic get decodedValue => wrapDecodingOperation(() => _decodedValue.value);

  /// The JSON data decoded as an instance of [Map<String, dynamic>].
  ///
  /// The JSON data must be a JSON object or it will throw
  /// a [JsonDecodingError].
  Map<String, dynamic> get decodedValueAsMap =>
      wrapDecodingOperation(() => _decodedValue.asMap());

  /// The JSON data decoded as an instance of [List<dynamic>].
  ///
  /// The JSON data must be a JSON list or it will throw
  /// a [JsonDecodingError].
  List<dynamic> get decodedValueAsList =>
      wrapDecodingOperation(() => _decodedValue.asList());

  // <<decoding methods>>

  /// Returns the JSON data decoded as an instance of [T].
  ///
  /// The JSON data must be a JSON primitive value and [T] must be a primitive
  ///  type (int, double, bool or String) or it will throw a [JsonDecodingError].
  T decodeAsPrimitiveValue<T>() =>
      wrapDecodingOperation(() => _decodedValue.asPrimitiveValue<T>());

  /// Returns the JSON data decoded as an instance of [List<T>].
  ///
  /// The JSON data must be a list of JSON primitive values and [T] must
  /// be a primitive type (int, double, bool or String) or it will throw
  /// a [JsonDecodingError].
  List<T> decodeAsPrimitiveList<T>() =>
      wrapDecodingOperation(() => _decodedValue.asPrimitiveList<T>());

  /// Returns the JSON data decoded as an instance of [T extends Object].
  ///
  /// The JSON data must be a JSON object or it will throw
  /// a [JsonDecodingError].
  T decodeAsObject<T extends Object>(JsonObjectDecoder<T> decoder) =>
      wrapDecodingOperation(
          () => _decodedValue.asObject(decoder, skipIfNull: true));

  /// Returns the JSON data decoded as an instance of [List<T extends Object>].
  ///
  /// The JSON data must be a list of JSON objects or it
  /// will throw a [JsonDecodingError].
  List<T> decodeAsObjectList<T extends Object>(JsonObjectDecoder<T> decoder) =>
      wrapDecodingOperation(
          () => _decodedValue.asObjectList(decoder, skipNullValues: true));

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

  // <<private fields>>

  final DecodedValue _cachedValue;

  DecodedValue get _decodedValue =>
      (_cachedValue != null) ? _cachedValue : _getDecodedValue(this.source);

  // <<private methods>>

  static JsonString _constructJsonString(String source, bool enableCache) {
    final decodedSource = _getDecodedValue(source);
    final cachedValue = enableCache ? decodedSource : null;
    return JsonString._(_encode(decodedSource.value), cachedValue);
  }

  const JsonString._(this.source, this._cachedValue);

  static String _encode(Object value, {Function(Object) encoder}) {
    return json.encode(value, toEncodable: encoder);
  }

  static String _encodeSafely(Object value, {Function(Object) encoder}) {
    assert(value != null);
    try {
      return _encode(value, encoder: encoder);
    } catch (e) {
      throw JsonEncodingError(e);
    }
  }

  static DecodedValue _getDecodedValue(String source) {
    assert(source != null);
    try {
      return DecodedValue.from(source);
    } catch (e) {
      throw JsonDecodingError(e);
    }
  }
}
