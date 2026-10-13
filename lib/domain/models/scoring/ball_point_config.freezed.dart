// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ball_point_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BallPointConfig {

 bool get enabled; int get points;
/// Create a copy of BallPointConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BallPointConfigCopyWith<BallPointConfig> get copyWith => _$BallPointConfigCopyWithImpl<BallPointConfig>(this as BallPointConfig, _$identity);

  /// Serializes this BallPointConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BallPointConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BallPointConfig&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.points, _this.points) || other.points == _this.points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BallPointConfig;
  return Object.hash(runtimeType,_this.enabled,_this.points);
}

@override
String toString() {
  final _this = this as BallPointConfig;
  return 'BallPointConfig(enabled: ${_this.enabled}, points: ${_this.points})';
}


}

/// @nodoc
abstract mixin class $BallPointConfigCopyWith<$Res>  {
  factory $BallPointConfigCopyWith(BallPointConfig value, $Res Function(BallPointConfig) _then) = _$BallPointConfigCopyWithImpl;
@useResult
$Res call({
 bool enabled, int points
});




}
/// @nodoc
class _$BallPointConfigCopyWithImpl<$Res>
    implements $BallPointConfigCopyWith<$Res> {
  _$BallPointConfigCopyWithImpl(this._self, this._then);

  final BallPointConfig _self;
  final $Res Function(BallPointConfig) _then;

/// Create a copy of BallPointConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? points = null,}) {
  return _then(BallPointConfig(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BallPointConfig].
extension BallPointConfigPatterns on BallPointConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BallPointConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BallPointConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BallPointConfig value)  $default,){
final _that = this;
switch (_that) {
case _BallPointConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BallPointConfig value)?  $default,){
final _that = this;
switch (_that) {
case _BallPointConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  int points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BallPointConfig() when $default != null:
return $default(_that.enabled,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  int points)  $default,) {final _that = this;
switch (_that) {
case _BallPointConfig():
return $default(_that.enabled,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  int points)?  $default,) {final _that = this;
switch (_that) {
case _BallPointConfig() when $default != null:
return $default(_that.enabled,_that.points);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BallPointConfig implements BallPointConfig {
  const _BallPointConfig({required this.enabled, required this.points}): assert(!enabled || points > 0, 'enabled ball must have positive points'),assert(enabled || points == 0, 'disabled ball must contribute zero');
  factory _BallPointConfig.fromJson(Map<String, dynamic> json) => _$BallPointConfigFromJson(json);

@override final  bool enabled;
@override final  int points;

/// Create a copy of BallPointConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BallPointConfigCopyWith<_BallPointConfig> get copyWith => __$BallPointConfigCopyWithImpl<_BallPointConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BallPointConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BallPointConfig&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.points, points) || other.points == points));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,enabled,points);
}

@override
String toString() {
    return 'BallPointConfig(enabled: $enabled, points: $points)';
}


}

/// @nodoc
abstract mixin class _$BallPointConfigCopyWith<$Res> implements $BallPointConfigCopyWith<$Res> {
  factory _$BallPointConfigCopyWith(_BallPointConfig value, $Res Function(_BallPointConfig) _then) = __$BallPointConfigCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, int points
});




}
/// @nodoc
class __$BallPointConfigCopyWithImpl<$Res>
    implements _$BallPointConfigCopyWith<$Res> {
  __$BallPointConfigCopyWithImpl(this._self, this._then);

  final _BallPointConfig _self;
  final $Res Function(_BallPointConfig) _then;

/// Create a copy of BallPointConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? points = null,}) {
  return _then(_BallPointConfig(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
