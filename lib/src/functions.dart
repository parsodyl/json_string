/// Transforms a Dart object into a JSON object representation
/// (Map<String, dynamic>).
typedef JsonObjectEncoder<T> = Map<String, dynamic>? Function(T dartObject);

/// Transforms a JSON object representation (Map<String, dynamic>) into a Dart
/// object.
typedef JsonObjectDecoder<T> = T Function(Map<String, dynamic> json);

/// Transforms a nullable JSON object representation (Map<String, dynamic>?)
/// into a Dart object.
typedef JsonObjectNullableDecoder<T> = T Function(Map<String, dynamic>? json);
