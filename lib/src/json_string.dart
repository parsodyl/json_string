import 'package:json_string/src/functions.dart';
import 'package:json_string/src/jsonable.dart';
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
    return _constructJsonString(source, enableCache);
  }

  /// Constructs a [JsonString] if [source] is a valid JSON.
  ///
  /// If not, it returns `null`.
  ///
  /// If the optional [enableCache] parameter is set to `true`,
  /// a cache of the decoded value is provided.
  static JsonString? orNull(String source, {bool enableCache = false}) {
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
  JsonString.encode(Object? value, {ToEncodable? encoder})
      : source = _encodeSafely(value, encoder: encoder),
        _cachedValue = null;

  /// Constructs a [JsonString] converting [value] into a valid JSON
  /// primitive value.
  ///
  /// [T] must be a primitive type (int, double, bool, String or Null).
  static JsonString encodePrimitiveValue<T>(T value) {
    return wrapJsonUtilOperation(() {
      final encodable = EncodableValue.fromPrimitiveValue<T>(value);
      return JsonString._(encodable.encode(), null);
    });
  }

  /// Constructs a [JsonString] converting [list] into a valid JSON List.
  ///
  /// [T] must be a primitive type (int, double, bool, String or Null).
  static JsonString encodePrimitiveList<T>(List<T> list) {
    return wrapJsonUtilOperation(() {
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
  ///
  /// To turn the runtime [Jsonable] check off, set [checkIfJsonable]
  /// to `false`.
  static JsonString encodeObject<T>(
    T value, {
    JsonObjectEncoder<T>? encoder,
    bool checkIfJsonable = true,
  }) {
    if (checkIfJsonable && encoder == null && value is! Jsonable?) {
      throw JsonEncodingError('[T] must mix in Jsonable when `checkIfJsonable` '
          'is set to true and an encoder is not provided');
    }
    return wrapJsonUtilOperation(() {
      final encodable = EncodableValue.fromObject<T, Map<String, dynamic>?>(
        value,
        encoder: encoder,
      );
      return JsonString._(encodable.encode(), null);
    });
  }

  /// Constructs a [JsonString] converting [list] into a valid JSON list.
  ///
  /// [T] represents a JSON Object, see `.encodeObject()` for reference.
  static JsonString encodeObjectList<T>(
    List<T> list, {
    JsonObjectEncoder<T>? encoder,
    bool checkIfJsonable = true,
  }) {
    if (checkIfJsonable && encoder == null && list is! List<Jsonable?>) {
      throw JsonEncodingError('[T] must mix in Jsonable when `checkIfJsonable` '
          'is set to true and an encoder is not provided');
    }
    return wrapJsonUtilOperation(() {
      final encodable = EncodableValue.fromObjectList<T, Map<String, dynamic>?>(
        list,
        encoder: encoder,
      );
      return JsonString._(encodable.encode(), null);
    });
  }

  // <<decoding properties>>

  /// The JSON data directly decoded as a dynamic type.
  ///
  /// (this is the most general one.)
  dynamic get decodedValue =>
      wrapJsonUtilOperation<dynamic>(() => _decodedValue.value);

  /// The JSON data decoded as an instance of [Map<String, dynamic>].
  ///
  /// The JSON data must be a JSON object or it will throw
  /// a [JsonDecodingError].
  Map<String, dynamic> get decodedValueAsMap =>
      wrapJsonUtilOperation(() => _decodedValue.asMap());

  /// The JSON data decoded as an instance of [List<dynamic>].
  ///
  /// The JSON data must be a JSON list or it will throw
  /// a [JsonDecodingError].
  List<dynamic> get decodedValueAsList =>
      wrapJsonUtilOperation(() => _decodedValue.asList());

  // <<decoding methods>>

  /// Returns the JSON data decoded as an instance of [T].
  ///
  /// The JSON data must be a JSON primitive value and [T] must be a primitive
  ///  type (int, double, bool or String) or it will throw a [JsonDecodingError].
  T decodeAsPrimitiveValue<T>() =>
      wrapJsonUtilOperation(() => _decodedValue.asPrimitiveValue<T>());

  /// Returns the JSON data decoded as an instance of [List<T>].
  ///
  /// The JSON data must be a list of JSON primitive values and [T] must
  /// be a primitive type (int, double, bool or String) or it will throw
  /// a [JsonDecodingError].
  List<T> decodeAsPrimitiveList<T>() =>
      wrapJsonUtilOperation(() => _decodedValue.asPrimitiveList<T>());

  /// Returns the JSON data decoded as an instance of [T extends Object].
  ///
  /// The JSON data must be a JSON object or it will throw
  /// a [JsonDecodingError].
  ///
  /// For JSON nullable objects, please use [decodeAsNullableObject].
  T decodeAsObject<T>(JsonObjectDecoder<T> decoder) {
    return wrapJsonUtilOperation(() => _decodedValue.asObject(decoder));
  }

  /// Returns the JSON data decoded as an instance of [T extends Object].
  ///
  /// The JSON data must be a JSON object or null, otherwise it will throw
  /// a [JsonDecodingError].
  T decodeAsNullableObject<T>(JsonObjectNullableDecoder<T> decoder) {
    return wrapJsonUtilOperation(() => _decodedValue.asObject(decoder));
  }

  /// Returns the JSON data decoded as an instance of [List<T extends Object>].
  ///
  /// The JSON data must be a list of JSON objects or it
  /// will throw a [JsonDecodingError]
  ///
  /// For JSON nullable objects, please use [decodeAsNullableObjectList].
  List<T> decodeAsObjectList<T>(JsonObjectDecoder<T> decoder) {
    return wrapJsonUtilOperation(() => _decodedValue.asObjectList(decoder));
  }

  /// Returns the JSON data decoded as an instance of [List<T extends Object>].
  ///
  /// The JSON data must be a list of JSON objects or null, otherwise it will
  /// throw a [JsonDecodingError].
  List<T> decodeAsNullableObjectList<T>(JsonObjectNullableDecoder<T> decoder) {
    return wrapJsonUtilOperation(() => _decodedValue.asObjectList(decoder));
  }

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

  // <<private constructor>>

  const JsonString._(this.source, this._cachedValue);

  // <<private fields>>

  final DecodedValue? _cachedValue;

  // <<private getters>>

  DecodedValue get _decodedValue =>
      (_cachedValue != null) ? _cachedValue! : DecodedValue.from(source);

  // <<private static methods>>

  static JsonString _constructJsonString(String source, bool enableCache) {
    final decodedSource = DecodedValue.from(source);
    final cachedValue = enableCache ? decodedSource : null;
    return JsonString._(convertEncode(decodedSource.value), cachedValue);
  }

  static String _encodeSafely(Object? value, {ToEncodable? encoder}) {
    try {
      return convertEncode(value, toEncodable: encoder);
    } catch (e) {
      throw JsonEncodingError(e);
    }
  }
}
