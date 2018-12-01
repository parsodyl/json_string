import 'dart:core';

class JsonFormatException extends FormatException {
  JsonFormatException([String message = "", String source, int offset])
      : super(message, source, offset);

  JsonFormatException.fromParent(FormatException parent)
      : super(parent.message, parent.source, parent.offset);

  @override
  String toString() {
    return 'Json${super.toString()}';
  }
}

class JsonEncodingError extends Error {
  final dynamic cause;

  JsonEncodingError(this.cause);

  @override
  String toString() {
    return 'JsonEncodingError{cause: $cause}';
  }
}

class JsonDecodingError extends Error {
  final dynamic cause;

  JsonDecodingError(this.cause);

  @override
  String toString() {
    return 'JsonDecodingError{cause: $cause}';
  }
}