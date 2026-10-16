// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rule_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RuleTemplate {

 String get id; String get name;@JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson) Map<int, BallPointConfig> get ballPoints; DateTime get createdAt;
/// Create a copy of RuleTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RuleTemplateCopyWith<RuleTemplate> get copyWith => _$RuleTemplateCopyWithImpl<RuleTemplate>(this as RuleTemplate, _$identity);

  /// Serializes this RuleTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RuleTemplate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RuleTemplate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.ballPoints, _this.ballPoints)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RuleTemplate;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.ballPoints),_this.createdAt);
}

@override
String toString() {
  final _this = this as RuleTemplate;
  return 'RuleTemplate(id: ${_this.id}, name: ${_this.name}, ballPoints: ${_this.ballPoints}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $RuleTemplateCopyWith<$Res>  {
  factory $RuleTemplateCopyWith(RuleTemplate value, $Res Function(RuleTemplate) _then) = _$RuleTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson) Map<int, BallPointConfig> ballPoints, DateTime createdAt
});




}
/// @nodoc
class _$RuleTemplateCopyWithImpl<$Res>
    implements $RuleTemplateCopyWith<$Res> {
  _$RuleTemplateCopyWithImpl(this._self, this._then);

  final RuleTemplate _self;
  final $Res Function(RuleTemplate) _then;

/// Create a copy of RuleTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? ballPoints = null,Object? createdAt = null,}) {
  return _then(RuleTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ballPoints: null == ballPoints ? _self.ballPoints : ballPoints // ignore: cast_nullable_to_non_nullable
as Map<int, BallPointConfig>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [RuleTemplate].
extension RuleTemplatePatterns on RuleTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RuleTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RuleTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RuleTemplate value)  $default,){
final _that = this;
switch (_that) {
case _RuleTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RuleTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _RuleTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson)  Map<int, BallPointConfig> ballPoints,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RuleTemplate() when $default != null:
return $default(_that.id,_that.name,_that.ballPoints,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson)  Map<int, BallPointConfig> ballPoints,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _RuleTemplate():
return $default(_that.id,_that.name,_that.ballPoints,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson)  Map<int, BallPointConfig> ballPoints,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _RuleTemplate() when $default != null:
return $default(_that.id,_that.name,_that.ballPoints,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RuleTemplate implements RuleTemplate {
  const _RuleTemplate({required this.id, required this.name, @JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson) required  Map<int, BallPointConfig> ballPoints, required this.createdAt}): _ballPoints = ballPoints;
  factory _RuleTemplate.fromJson(Map<String, dynamic> json) => _$RuleTemplateFromJson(json);

@override final  String id;
@override final  String name;
 final  Map<int, BallPointConfig> _ballPoints;
@override@JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson) Map<int, BallPointConfig> get ballPoints {
  if (_ballPoints is EqualUnmodifiableMapView) return _ballPoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_ballPoints);
}

@override final  DateTime createdAt;

/// Create a copy of RuleTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RuleTemplateCopyWith<_RuleTemplate> get copyWith => __$RuleTemplateCopyWithImpl<_RuleTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RuleTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RuleTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.ballPoints, _ballPoints)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_ballPoints),createdAt);
}

@override
String toString() {
    return 'RuleTemplate(id: $id, name: $name, ballPoints: $ballPoints, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$RuleTemplateCopyWith<$Res> implements $RuleTemplateCopyWith<$Res> {
  factory _$RuleTemplateCopyWith(_RuleTemplate value, $Res Function(_RuleTemplate) _then) = __$RuleTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(fromJson: _ballMapFromJson, toJson: _ballMapToJson) Map<int, BallPointConfig> ballPoints, DateTime createdAt
});




}
/// @nodoc
class __$RuleTemplateCopyWithImpl<$Res>
    implements _$RuleTemplateCopyWith<$Res> {
  __$RuleTemplateCopyWithImpl(this._self, this._then);

  final _RuleTemplate _self;
  final $Res Function(_RuleTemplate) _then;

/// Create a copy of RuleTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? ballPoints = null,Object? createdAt = null,}) {
  return _then(_RuleTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,ballPoints: null == ballPoints ? _self._ballPoints : ballPoints // ignore: cast_nullable_to_non_nullable
as Map<int, BallPointConfig>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
