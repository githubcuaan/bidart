// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rule_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RuleConfig {

 String get id; int get version;@JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson) Map<int, BallPointConfig> get ballPoints;
/// Create a copy of RuleConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RuleConfigCopyWith<RuleConfig> get copyWith => _$RuleConfigCopyWithImpl<RuleConfig>(this as RuleConfig, _$identity);

  /// Serializes this RuleConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RuleConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RuleConfig&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.version, _this.version) || other.version == _this.version)&&const DeepCollectionEquality().equals(other.ballPoints, _this.ballPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RuleConfig;
  return Object.hash(runtimeType,_this.id,_this.version,const DeepCollectionEquality().hash(_this.ballPoints));
}

@override
String toString() {
  final _this = this as RuleConfig;
  return 'RuleConfig(id: ${_this.id}, version: ${_this.version}, ballPoints: ${_this.ballPoints})';
}


}

/// @nodoc
abstract mixin class $RuleConfigCopyWith<$Res>  {
  factory $RuleConfigCopyWith(RuleConfig value, $Res Function(RuleConfig) _then) = _$RuleConfigCopyWithImpl;
@useResult
$Res call({
 String id, int version,@JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson) Map<int, BallPointConfig> ballPoints
});




}
/// @nodoc
class _$RuleConfigCopyWithImpl<$Res>
    implements $RuleConfigCopyWith<$Res> {
  _$RuleConfigCopyWithImpl(this._self, this._then);

  final RuleConfig _self;
  final $Res Function(RuleConfig) _then;

/// Create a copy of RuleConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? version = null,Object? ballPoints = null,}) {
  return _then(RuleConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,ballPoints: null == ballPoints ? _self.ballPoints : ballPoints // ignore: cast_nullable_to_non_nullable
as Map<int, BallPointConfig>,
  ));
}

}


/// Adds pattern-matching-related methods to [RuleConfig].
extension RuleConfigPatterns on RuleConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RuleConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RuleConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RuleConfig value)  $default,){
final _that = this;
switch (_that) {
case _RuleConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RuleConfig value)?  $default,){
final _that = this;
switch (_that) {
case _RuleConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int version, @JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson)  Map<int, BallPointConfig> ballPoints)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RuleConfig() when $default != null:
return $default(_that.id,_that.version,_that.ballPoints);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int version, @JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson)  Map<int, BallPointConfig> ballPoints)  $default,) {final _that = this;
switch (_that) {
case _RuleConfig():
return $default(_that.id,_that.version,_that.ballPoints);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int version, @JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson)  Map<int, BallPointConfig> ballPoints)?  $default,) {final _that = this;
switch (_that) {
case _RuleConfig() when $default != null:
return $default(_that.id,_that.version,_that.ballPoints);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RuleConfig implements RuleConfig {
  const _RuleConfig({required this.id, required this.version, @JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson) required  Map<int, BallPointConfig> ballPoints}): _ballPoints = ballPoints;
  factory _RuleConfig.fromJson(Map<String, dynamic> json) => _$RuleConfigFromJson(json);

@override final  String id;
@override final  int version;
 final  Map<int, BallPointConfig> _ballPoints;
@override@JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson) Map<int, BallPointConfig> get ballPoints {
  if (_ballPoints is EqualUnmodifiableMapView) return _ballPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_ballPoints);
}


/// Create a copy of RuleConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RuleConfigCopyWith<_RuleConfig> get copyWith => __$RuleConfigCopyWithImpl<_RuleConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RuleConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RuleConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.ballPoints, _ballPoints));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,version,const DeepCollectionEquality().hash(_ballPoints));
}

@override
String toString() {
    return 'RuleConfig(id: $id, version: $version, ballPoints: $ballPoints)';
}


}

/// @nodoc
abstract mixin class _$RuleConfigCopyWith<$Res> implements $RuleConfigCopyWith<$Res> {
  factory _$RuleConfigCopyWith(_RuleConfig value, $Res Function(_RuleConfig) _then) = __$RuleConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, int version,@JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson) Map<int, BallPointConfig> ballPoints
});




}
/// @nodoc
class __$RuleConfigCopyWithImpl<$Res>
    implements _$RuleConfigCopyWith<$Res> {
  __$RuleConfigCopyWithImpl(this._self, this._then);

  final _RuleConfig _self;
  final $Res Function(_RuleConfig) _then;

/// Create a copy of RuleConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? version = null,Object? ballPoints = null,}) {
  return _then(_RuleConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,ballPoints: null == ballPoints ? _self._ballPoints : ballPoints // ignore: cast_nullable_to_non_nullable
as Map<int, BallPointConfig>,
  ));
}


}

// dart format on
