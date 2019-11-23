import 'dart:core';

//import 'package:json_util/json_util.dart' show JsonFormatException, JsonUtilError;

/// Exception thrown when a string does not have the
/// expected JSON format and cannot be parsed.
class JsonFormatException extends FormatException {
  /// Default constructor.
  JsonFormatException([String message = "", String source, int offset])
      : super(message, source, offset);

  /// Constructs a [JsonFormatException] starting from a parent [FormatException].
  JsonFormatException.fromParent(FormatException parent)
      : super(parent.message, parent.source, parent.offset);

  @override
  String toString() {
    return 'Json${super.toString()}';
  }
}

/// Error thrown during a JSON encoding operation.
class JsonEncodingError extends Error {
  /// The cause of this error.
  final dynamic cause;

  /// Default constructor.
  JsonEncodingError(this.cause);

  @override
  String toString() {
    return 'JsonEncodingError{cause: $cause}';
  }
}

/// Error thrown during a JSON decoding operation.
class JsonDecodingError extends Error {
  /// The cause of this error.
  final dynamic cause;

  /// Default constructor.
  JsonDecodingError(this.cause);

  @override
  String toString() {
    return 'JsonDecodingError{cause: $cause}';
  }
}
