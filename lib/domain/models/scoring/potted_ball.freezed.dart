// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'potted_ball.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PottedBall {

 int get ballNumber; int get points; bool get isRespotted;
/// Create a copy of PottedBall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PottedBallCopyWith<PottedBall> get copyWith => _$PottedBallCopyWithImpl<PottedBall>(this as PottedBall, _$identity);

  /// Serializes this PottedBall to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PottedBall;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PottedBall&&(identical(other.ballNumber, _this.ballNumber) || other.ballNumber == _this.ballNumber)&&(identical(other.points, _this.points) || other.points == _this.points)&&(identical(other.isRespotted, _this.isRespotted) || other.isRespotted == _this.isRespotted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PottedBall;
  return Object.hash(runtimeType,_this.ballNumber,_this.points,_this.isRespotted);
}

@override
String toString() {
  final _this = this as PottedBall;
  return 'PottedBall(ballNumber: ${_this.ballNumber}, points: ${_this.points}, isRespotted: ${_this.isRespotted})';
}


}

/// @nodoc
abstract mixin class $PottedBallCopyWith<$Res>  {
  factory $PottedBallCopyWith(PottedBall value, $Res Function(PottedBall) _then) = _$PottedBallCopyWithImpl;
@useResult
$Res call({
 int ballNumber, int points, bool isRespotted
});




}
/// @nodoc
class _$PottedBallCopyWithImpl<$Res>
    implements $PottedBallCopyWith<$Res> {
  _$PottedBallCopyWithImpl(this._self, this._then);

  final PottedBall _self;
  final $Res Function(PottedBall) _then;

/// Create a copy of PottedBall
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ballNumber = null,Object? points = null,Object? isRespotted = null,}) {
  return _then(PottedBall(
ballNumber: null == ballNumber ? _self.ballNumber : ballNumber // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,isRespotted: null == isRespotted ? _self.isRespotted : isRespotted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PottedBall].
extension PottedBallPatterns on PottedBall {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PottedBall value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PottedBall() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PottedBall value)  $default,){
final _that = this;
switch (_that) {
case _PottedBall():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PottedBall value)?  $default,){
final _that = this;
switch (_that) {
case _PottedBall() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int ballNumber,  int points,  bool isRespotted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PottedBall() when $default != null:
return $default(_that.ballNumber,_that.points,_that.isRespotted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int ballNumber,  int points,  bool isRespotted)  $default,) {final _that = this;
switch (_that) {
case _PottedBall():
return $default(_that.ballNumber,_that.points,_that.isRespotted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int ballNumber,  int points,  bool isRespotted)?  $default,) {final _that = this;
switch (_that) {
case _PottedBall() when $default != null:
return $default(_that.ballNumber,_that.points,_that.isRespotted);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PottedBall implements PottedBall {
  const _PottedBall({required this.ballNumber, required this.points, required this.isRespotted}): assert(ballNumber >= 1 && ballNumber <= 9, 'ball must be 1-9'),assert(points >= 0, 'points must be non-negative');
  factory _PottedBall.fromJson(Map<String, dynamic> json) => _$PottedBallFromJson(json);

@override final  int ballNumber;
@override final  int points;
@override final  bool isRespotted;

/// Create a copy of PottedBall
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PottedBallCopyWith<_PottedBall> get copyWith => __$PottedBallCopyWithImpl<_PottedBall>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PottedBallToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PottedBall&&(identical(other.ballNumber, ballNumber) || other.ballNumber == ballNumber)&&(identical(other.points, points) || other.points == points)&&(identical(other.isRespotted, isRespotted) || other.isRespotted == isRespotted));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ballNumber,points,isRespotted);
}

@override
String toString() {
    return 'PottedBall(ballNumber: $ballNumber, points: $points, isRespotted: $isRespotted)';
}


}

/// @nodoc
abstract mixin class _$PottedBallCopyWith<$Res> implements $PottedBallCopyWith<$Res> {
  factory _$PottedBallCopyWith(_PottedBall value, $Res Function(_PottedBall) _then) = __$PottedBallCopyWithImpl;
@override @useResult
$Res call({
 int ballNumber, int points, bool isRespotted
});




}
/// @nodoc
class __$PottedBallCopyWithImpl<$Res>
    implements _$PottedBallCopyWith<$Res> {
  __$PottedBallCopyWithImpl(this._self, this._then);

  final _PottedBall _self;
  final $Res Function(_PottedBall) _then;

/// Create a copy of PottedBall
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ballNumber = null,Object? points = null,Object? isRespotted = null,}) {
  return _then(_PottedBall(
ballNumber: null == ballNumber ? _self.ballNumber : ballNumber // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,isRespotted: null == isRespotted ? _self.isRespotted : isRespotted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
