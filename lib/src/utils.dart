import 'package:json_string/src/errors.dart';
import 'package:json_string/src/functions.dart';
import 'package:json_string/src/jsonable.dart';

T checkPrimitiveValue<T>(T value) {
  assert(value != null);
  if (!isPrimitiveType<T>()) {
    throw JsonEncodingError(
        "type '${T.toString()}' is not a JSON primitive type");
  }
  return value;
}

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

T assembleObject<T extends Object>(
    Map<String, dynamic> jsonObject, JsonObjectDecoder<T> builder) {
  assert(jsonObject != null);
  assert(builder != null);
  return builder(jsonObject);
}

List<T> assembleObjectList<T extends Object>(
    List<dynamic> jsonList, JsonObjectDecoder<T> builder) {
  assert(jsonList != null);
  assert(builder != null);
  return jsonList.map((e) {
    if (e == null) {
      return e as T;
    }
    final map = castToMap(e);
    return assembleObject<T>(map, builder);
  }).toList();
}

Map<String, dynamic> castToMap(dynamic value) {
  assert(value != null);
  final Object jsonObject = value;
  if (!isMap(jsonObject)) {
    throw JsonDecodingError(
        "value '${jsonObject.toString()}' is not an instance of Map<String, dynamic>");
  }
  return normalizeJsonObject(jsonObject);
}

List<dynamic> castToList(dynamic value) {
  assert(value != null);
  final Object jsonList = value;
  if (!isList(jsonList)) {
    throw JsonDecodingError(
        "value '${jsonList.toString()}' is not an instance of List<dynamic>");
  }
  return jsonList as List<dynamic>;
}

List<T> castToPrimitiveList<T>(dynamic value) {
  assert(value != null);
  if (!isPrimitiveType<T>()) {
    throw JsonDecodingError(
        "type '${T.toString()}' is not a JSON primitive type");
  }
  final Object jsonList = value;
  if (!isTypedList<T>(jsonList)) {
    throw JsonDecodingError(
        "value '${jsonList.toString()}' is not an instance of List<${T.toString()}>");
  }
  return List<T>.from(jsonList);
}

T castToPrimitiveValue<T>(dynamic value) {
  if (!isPrimitiveType<T>()) {
    throw JsonDecodingError(
        "type '${T.toString()}' is not a JSON primitive type");
  }
  if (!isTypedValue<T>(value)) {
    throw JsonDecodingError(
        "value '${value.toString()}' is not an instance of ${T.toString()}");
  }
  return value as T;
}

bool isPrimitiveType<T>() {
  Type type = T;
  final ts = type.toString();
  return ts == 'bool' || ts == 'String' || ts == 'int' || ts == 'double';
}

bool isMap(dynamic node) {
  return node is Map<String, dynamic>;
}

bool isList(dynamic node) {
  return node is List<dynamic>;
}

bool isTypedList<T>(dynamic node) {
  if (!isList(node)) {
    return false;
  }
  for (final e in node) {
    if (e == null) {
      continue;
    }
    if (!(e is T)) {
      return false;
    }
  }
  return true;
}

bool isTypedValue<T>(dynamic node) {
  final e = node;
  if (e == null) {
    return true;
  }
  return e is T;
}

Map<String, dynamic> normalizeJsonObject(Object jsonObject) {
  return jsonObject as Map<String, dynamic>;
}
