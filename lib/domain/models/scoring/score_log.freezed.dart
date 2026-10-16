// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScoreLog {

 String get participantId; int get previousScore; int get newScore;
/// Create a copy of ScoreLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreLogCopyWith<ScoreLog> get copyWith => _$ScoreLogCopyWithImpl<ScoreLog>(this as ScoreLog, _$identity);

  /// Serializes this ScoreLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScoreLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreLog&&(identical(other.participantId, _this.participantId) || other.participantId == _this.participantId)&&(identical(other.previousScore, _this.previousScore) || other.previousScore == _this.previousScore)&&(identical(other.newScore, _this.newScore) || other.newScore == _this.newScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScoreLog;
  return Object.hash(runtimeType,_this.participantId,_this.previousScore,_this.newScore);
}

@override
String toString() {
  final _this = this as ScoreLog;
  return 'ScoreLog(participantId: ${_this.participantId}, previousScore: ${_this.previousScore}, newScore: ${_this.newScore})';
}


}

/// @nodoc
abstract mixin class $ScoreLogCopyWith<$Res>  {
  factory $ScoreLogCopyWith(ScoreLog value, $Res Function(ScoreLog) _then) = _$ScoreLogCopyWithImpl;
@useResult
$Res call({
 String participantId, int previousScore, int newScore
});




}
/// @nodoc
class _$ScoreLogCopyWithImpl<$Res>
    implements $ScoreLogCopyWith<$Res> {
  _$ScoreLogCopyWithImpl(this._self, this._then);

  final ScoreLog _self;
  final $Res Function(ScoreLog) _then;

/// Create a copy of ScoreLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? participantId = null,Object? previousScore = null,Object? newScore = null,}) {
  return _then(ScoreLog(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,previousScore: null == previousScore ? _self.previousScore : previousScore // ignore: cast_nullable_to_non_nullable
as int,newScore: null == newScore ? _self.newScore : newScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoreLog].
extension ScoreLogPatterns on ScoreLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoreLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoreLog value)  $default,){
final _that = this;
switch (_that) {
case _ScoreLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoreLog value)?  $default,){
final _that = this;
switch (_that) {
case _ScoreLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String participantId,  int previousScore,  int newScore)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreLog() when $default != null:
return $default(_that.participantId,_that.previousScore,_that.newScore);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String participantId,  int previousScore,  int newScore)  $default,) {final _that = this;
switch (_that) {
case _ScoreLog():
return $default(_that.participantId,_that.previousScore,_that.newScore);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String participantId,  int previousScore,  int newScore)?  $default,) {final _that = this;
switch (_that) {
case _ScoreLog() when $default != null:
return $default(_that.participantId,_that.previousScore,_that.newScore);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScoreLog implements ScoreLog {
  const _ScoreLog({required this.participantId, required this.previousScore, required this.newScore});
  factory _ScoreLog.fromJson(Map<String, dynamic> json) => _$ScoreLogFromJson(json);

@override final  String participantId;
@override final  int previousScore;
@override final  int newScore;

/// Create a copy of ScoreLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreLogCopyWith<_ScoreLog> get copyWith => __$ScoreLogCopyWithImpl<_ScoreLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScoreLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreLog&&(identical(other.participantId, participantId) || other.participantId == participantId)&&(identical(other.previousScore, previousScore) || other.previousScore == previousScore)&&(identical(other.newScore, newScore) || other.newScore == newScore));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,participantId,previousScore,newScore);
}

@override
String toString() {
    return 'ScoreLog(participantId: $participantId, previousScore: $previousScore, newScore: $newScore)';
}


}

/// @nodoc
abstract mixin class _$ScoreLogCopyWith<$Res> implements $ScoreLogCopyWith<$Res> {
  factory _$ScoreLogCopyWith(_ScoreLog value, $Res Function(_ScoreLog) _then) = __$ScoreLogCopyWithImpl;
@override @useResult
$Res call({
 String participantId, int previousScore, int newScore
});




}
/// @nodoc
class __$ScoreLogCopyWithImpl<$Res>
    implements _$ScoreLogCopyWith<$Res> {
  __$ScoreLogCopyWithImpl(this._self, this._then);

  final _ScoreLog _self;
  final $Res Function(_ScoreLog) _then;

/// Create a copy of ScoreLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? participantId = null,Object? previousScore = null,Object? newScore = null,}) {
  return _then(_ScoreLog(
participantId: null == participantId ? _self.participantId : participantId // ignore: cast_nullable_to_non_nullable
as String,previousScore: null == previousScore ? _self.previousScore : previousScore // ignore: cast_nullable_to_non_nullable
as int,newScore: null == newScore ? _self.newScore : newScore // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
