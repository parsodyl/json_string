## 3.0.1

- Upgraded json_util dependency.
- README little fix.

## 3.0.0

- Full null-safety migration
- `Jsonable` has changed as followed (typically non-breaking):
    - `toJson()` has now **dynamic** as return type and can be overridden
    - when using `encodeObject<T>()` or `encodeObjectList<T>()`, making **T** `Jsonable` is no longer required
      if `checkIfJsonable` is set to **false**
- New methods defined for object decoding (breaking):
    - `decodeAsObject<T>(decoder)`
    - `decodeAsNullableObject<T>(nullableDecoder)`
    - `decodeAsObjectList<T>(decoder)`
    - `decodeAsNullableObjectList<T>(nullableDecoder)`

## 2.0.1

- Upgraded json_util dependency.
- README fix.

## 2.0.0

- **JsonFormatException**, **JsonEncodingError**, **JsonDecodingError** are still visible, but moved to json_util
  package.
- Null values are now treated as primitive values.
- **encodeObjectList()** now accepts null filled lists as input.

## 1.1.0

* Clarified `Jsonable` mixin usage (non-breaking).

## 1.0.1

* Documentation corrected.

## 1.0.0

**Breaking:**

- `decodedValueAsObject()` is now called **decodeAsObject()**
- `decodedValueAsObjectList()` is now called **decodeAsObjectList()**
- `decodedValueAsPrimitiveList()` is now called **decodeAsPrimitiveList()**

**Non-breaking:**

- Added **decodeAsPrimitiveValue()**
- `encode()` now throws an instance of **JsonEncodingError** in case of error

## 0.2.0

* New decoding options added.

## 0.1.0

* Documentation corrected.
* First stable release.

## 0.0.5

* Cache option added.

## 0.0.4

* README updated.

## 0.0.3

* README updated.

## 0.0.2

* Pub maintenance score improved.
* First simple example added.

## 0.0.1

* Initial release.
