
/// Transforms a Dart object into a JSON object representation.
typedef JsonObjectEncoder<T extends Object> = Map<String, dynamic> Function(
    T dartObject);
    