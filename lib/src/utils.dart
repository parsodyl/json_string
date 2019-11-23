import 'package:json_string/src/functions.dart';
import 'package:json_string/src/jsonable.dart';
import 'package:json_util/json_util.dart';

Map<String, dynamic> disassembleObject<T extends Object>(T value,
    {JsonObjectEncoder<T> builder}) {
  assert(value != null);
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
  assert(value != null);
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

T wrapDecodingOperation<T>(T exec()) {
  try {
    return exec();
  } on JsonUtilError catch (e) {
    throw JsonDecodingError(e);
  }
}

T wrapEncodingOperation<T>(T exec()) {
  try {
    return exec();
  } on JsonUtilError catch (e) {
    throw JsonEncodingError(e);
  }
}
