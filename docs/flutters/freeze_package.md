# Freeze

using to create data classes

## Data class

is a simple class for data, not for logic
like `DTO` and `Struct`

A standart data class provide

1. Value Equality: override `==` and `hashCode`.
2. Immutabillity: all the field shoud be `final` or `readonly`.
3. Copy with `copy` and `copyWith`: u cant modify a instance of data class, u need to create a new instance.
4. String representation with `toString`: override the `toString`.

## Dart

Dart doesnt have Data class -> u have to write all the `boilerplate` (1,2,3,4).
`Freeze` is a dart package that will do it for u.

## Using Freeze

they usualy using json_serializable to using `toJson` and `fromJson` method
(Dart connect with api using this)
