// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_in_game.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerInGame {

 String get id; String get displayName; DateTime get joinedAt; DateTime? get leftAt;
/// Create a copy of PlayerInGame
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerInGameCopyWith<PlayerInGame> get copyWith => _$PlayerInGameCopyWithImpl<PlayerInGame>(this as PlayerInGame, _$identity);

  /// Serializes this PlayerInGame to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlayerInGame;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerInGame&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.joinedAt, _this.joinedAt) || other.joinedAt == _this.joinedAt)&&(identical(other.leftAt, _this.leftAt) || other.leftAt == _this.leftAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlayerInGame;
  return Object.hash(runtimeType,_this.id,_this.displayName,_this.joinedAt,_this.leftAt);
}

@override
String toString() {
  final _this = this as PlayerInGame;
  return 'PlayerInGame(id: ${_this.id}, displayName: ${_this.displayName}, joinedAt: ${_this.joinedAt}, leftAt: ${_this.leftAt})';
}


}

/// @nodoc
abstract mixin class $PlayerInGameCopyWith<$Res>  {
  factory $PlayerInGameCopyWith(PlayerInGame value, $Res Function(PlayerInGame) _then) = _$PlayerInGameCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, DateTime joinedAt, DateTime? leftAt
});




}
/// @nodoc
class _$PlayerInGameCopyWithImpl<$Res>
    implements $PlayerInGameCopyWith<$Res> {
  _$PlayerInGameCopyWithImpl(this._self, this._then);

  final PlayerInGame _self;
  final $Res Function(PlayerInGame) _then;

/// Create a copy of PlayerInGame
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? joinedAt = null,Object? leftAt = freezed,}) {
  return _then(PlayerInGame(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,leftAt: freezed == leftAt ? _self.leftAt : leftAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerInGame].
extension PlayerInGamePatterns on PlayerInGame {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerInGame value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerInGame() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerInGame value)  $default,){
final _that = this;
switch (_that) {
case _PlayerInGame():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerInGame value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerInGame() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  DateTime joinedAt,  DateTime? leftAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerInGame() when $default != null:
return $default(_that.id,_that.displayName,_that.joinedAt,_that.leftAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  DateTime joinedAt,  DateTime? leftAt)  $default,) {final _that = this;
switch (_that) {
case _PlayerInGame():
return $default(_that.id,_that.displayName,_that.joinedAt,_that.leftAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  DateTime joinedAt,  DateTime? leftAt)?  $default,) {final _that = this;
switch (_that) {
case _PlayerInGame() when $default != null:
return $default(_that.id,_that.displayName,_that.joinedAt,_that.leftAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerInGame implements PlayerInGame {
  const _PlayerInGame({required this.id, required this.displayName, required this.joinedAt, this.leftAt});
  factory _PlayerInGame.fromJson(Map<String, dynamic> json) => _$PlayerInGameFromJson(json);

@override final  String id;
@override final  String displayName;
@override final  DateTime joinedAt;
@override final  DateTime? leftAt;

/// Create a copy of PlayerInGame
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerInGameCopyWith<_PlayerInGame> get copyWith => __$PlayerInGameCopyWithImpl<_PlayerInGame>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerInGameToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerInGame&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.leftAt, leftAt) || other.leftAt == leftAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,displayName,joinedAt,leftAt);
}

@override
String toString() {
    return 'PlayerInGame(id: $id, displayName: $displayName, joinedAt: $joinedAt, leftAt: $leftAt)';
}


}

/// @nodoc
abstract mixin class _$PlayerInGameCopyWith<$Res> implements $PlayerInGameCopyWith<$Res> {
  factory _$PlayerInGameCopyWith(_PlayerInGame value, $Res Function(_PlayerInGame) _then) = __$PlayerInGameCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, DateTime joinedAt, DateTime? leftAt
});




}
/// @nodoc
class __$PlayerInGameCopyWithImpl<$Res>
    implements _$PlayerInGameCopyWith<$Res> {
  __$PlayerInGameCopyWithImpl(this._self, this._then);

  final _PlayerInGame _self;
  final $Res Function(_PlayerInGame) _then;

/// Create a copy of PlayerInGame
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? joinedAt = null,Object? leftAt = freezed,}) {
  return _then(_PlayerInGame(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,leftAt: freezed == leftAt ? _self.leftAt : leftAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
