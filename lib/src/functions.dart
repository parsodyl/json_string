/// Transforms a Dart object into a JSON object representation (Map<String, dynamic>).
typedef JsonObjectEncoder<T extends Object> = Map<String, dynamic> Function(
    T dartObject);

/// Transforms a JSON object representation (Map<String, dynamic>) into a Dart object.
typedef JsonObjectDecoder<T extends Object> = T Function(
    Map<String, dynamic> json);
