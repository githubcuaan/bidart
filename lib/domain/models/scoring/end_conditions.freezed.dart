// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'end_conditions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EndConditions {

 int? get durationSeconds; int? get scoreThreshold;
/// Create a copy of EndConditions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EndConditionsCopyWith<EndConditions> get copyWith => _$EndConditionsCopyWithImpl<EndConditions>(this as EndConditions, _$identity);

  /// Serializes this EndConditions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EndConditions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EndConditions&&(identical(other.durationSeconds, _this.durationSeconds) || other.durationSeconds == _this.durationSeconds)&&(identical(other.scoreThreshold, _this.scoreThreshold) || other.scoreThreshold == _this.scoreThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EndConditions;
  return Object.hash(runtimeType,_this.durationSeconds,_this.scoreThreshold);
}

@override
String toString() {
  final _this = this as EndConditions;
  return 'EndConditions(durationSeconds: ${_this.durationSeconds}, scoreThreshold: ${_this.scoreThreshold})';
}


}

/// @nodoc
abstract mixin class $EndConditionsCopyWith<$Res>  {
  factory $EndConditionsCopyWith(EndConditions value, $Res Function(EndConditions) _then) = _$EndConditionsCopyWithImpl;
@useResult
$Res call({
 int? durationSeconds, int? scoreThreshold
});




}
/// @nodoc
class _$EndConditionsCopyWithImpl<$Res>
    implements $EndConditionsCopyWith<$Res> {
  _$EndConditionsCopyWithImpl(this._self, this._then);

  final EndConditions _self;
  final $Res Function(EndConditions) _then;

/// Create a copy of EndConditions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? durationSeconds = freezed,Object? scoreThreshold = freezed,}) {
  return _then(EndConditions(
durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,scoreThreshold: freezed == scoreThreshold ? _self.scoreThreshold : scoreThreshold // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [EndConditions].
extension EndConditionsPatterns on EndConditions {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EndConditions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EndConditions() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EndConditions value)  $default,){
final _that = this;
switch (_that) {
case _EndConditions():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EndConditions value)?  $default,){
final _that = this;
switch (_that) {
case _EndConditions() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? durationSeconds,  int? scoreThreshold)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EndConditions() when $default != null:
return $default(_that.durationSeconds,_that.scoreThreshold);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? durationSeconds,  int? scoreThreshold)  $default,) {final _that = this;
switch (_that) {
case _EndConditions():
return $default(_that.durationSeconds,_that.scoreThreshold);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? durationSeconds,  int? scoreThreshold)?  $default,) {final _that = this;
switch (_that) {
case _EndConditions() when $default != null:
return $default(_that.durationSeconds,_that.scoreThreshold);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EndConditions implements EndConditions {
  const _EndConditions({this.durationSeconds, this.scoreThreshold});
  factory _EndConditions.fromJson(Map<String, dynamic> json) => _$EndConditionsFromJson(json);

@override final  int? durationSeconds;
@override final  int? scoreThreshold;

/// Create a copy of EndConditions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EndConditionsCopyWith<_EndConditions> get copyWith => __$EndConditionsCopyWithImpl<_EndConditions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EndConditionsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EndConditions&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.scoreThreshold, scoreThreshold) || other.scoreThreshold == scoreThreshold));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,durationSeconds,scoreThreshold);
}

@override
String toString() {
    return 'EndConditions(durationSeconds: $durationSeconds, scoreThreshold: $scoreThreshold)';
}


}

/// @nodoc
abstract mixin class _$EndConditionsCopyWith<$Res> implements $EndConditionsCopyWith<$Res> {
  factory _$EndConditionsCopyWith(_EndConditions value, $Res Function(_EndConditions) _then) = __$EndConditionsCopyWithImpl;
@override @useResult
$Res call({
 int? durationSeconds, int? scoreThreshold
});




}
/// @nodoc
class __$EndConditionsCopyWithImpl<$Res>
    implements _$EndConditionsCopyWith<$Res> {
  __$EndConditionsCopyWithImpl(this._self, this._then);

  final _EndConditions _self;
  final $Res Function(_EndConditions) _then;

/// Create a copy of EndConditions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? durationSeconds = freezed,Object? scoreThreshold = freezed,}) {
  return _then(_EndConditions(
durationSeconds: freezed == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int?,scoreThreshold: freezed == scoreThreshold ? _self.scoreThreshold : scoreThreshold // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
