import 'package:json_util/json_util.dart';

/// Wraps a generic operation from the json_util library
T wrapJsonUtilOperation<T>(T Function() exec) {
  try {
    return exec();
  } on DecodedValueError catch (e) {
    throw JsonDecodingError(e);
  } on EncodableValueError catch (e) {
    throw JsonEncodingError(e);
  }
}
