import 'package:json_string/src/errors.dart';
import 'package:json_string/src/functions.dart';
import 'package:json_string/src/jsonable.dart';

Map<String, dynamic> disassembleObject<T extends Object>(T value,
    {JsonObjectEncoder<T> builder}) {
  assert(value != null);
  final T dartObject = value;
  if (builder != null) {
    return builder(dartObject);
  } else if (dartObject is Jsonable) {
    return dartObject.toJson();
  }
  throw JsonEncodingError(
      "this is not a Jsonable object: provide a valid encoder.");
}

List<dynamic> disassemblePrimitiveList<T>(List<T> value) {
  assert(value != null);
  final List<T> primitiveList = value;
  if (!isPrimitiveType<T>()) {
    throw JsonEncodingError(
        "type '${T.toString()}' is not a JSON primitive type");
  }
  return primitiveList;
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

bool isPrimitiveType<T>() {
  Type type = T;
  final ts = type.toString();
  return ts == 'bool' || ts == 'String' || ts == 'int' || ts == 'double';
}

Map<String, dynamic> normalizeJsonObject(Object jsonObject) {
  return jsonObject as Map<String, dynamic>;
}
