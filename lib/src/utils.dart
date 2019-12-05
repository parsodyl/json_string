import 'package:json_string/src/functions.dart';
import 'package:json_string/src/jsonable.dart';
import 'package:json_util/json_util.dart';

Map<String, dynamic> disassembleObject<T extends Object>(T value,
    {JsonObjectEncoder<T> builder}) {
  final T dartObject = value;
  if (builder != null) {
    return builder(dartObject);
  } else if (dartObject is Jsonable) {
    return dartObject.toMap();
  }
  throw JsonEncodingError(
      "this is not a Jsonable object: provide a valid encoder.");
}

List<dynamic> disassembleObjectList<T extends Object>(List<T> value,
    {JsonObjectEncoder<T> builder}) {
  final List<T> dartObjectList = value;
  return dartObjectList.map((e) {
    if (e == null) {
      return normalizeJsonObject(e);
    }
    return disassembleObject<T>(e, builder: builder);
  }).toList();
}

Map<String, dynamic> normalizeJsonObject(Object jsonObject) {
  return jsonObject as Map<String, dynamic>;
}

T wrapJsonUtilOperation<T>(T exec()) {
  try {
    return exec();
  } on DecodedValueError catch (e) {
    throw JsonDecodingError(e);
  } on EncodableValueError catch (e) {
    throw JsonEncodingError(e);
  }
}
