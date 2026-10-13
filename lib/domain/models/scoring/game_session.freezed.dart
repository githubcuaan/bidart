// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameSession {

 String get id; String get roomId; int get gameNumber; GameStatus get status; DateTime get startedAt; DateTime? get endedAt; String get currentPlayerId; String? get previousPlayerId; String get payerId; List<String> get playerOrder; Set<int> get remainingBalls; ChainState get chainState; String? get winnerId; String? get finalPayerId; bool get isBreakClear; List<Turn> get turns;
/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameSessionCopyWith<GameSession> get copyWith => _$GameSessionCopyWithImpl<GameSession>(this as GameSession, _$identity);

  /// Serializes this GameSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GameSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameSession&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.roomId, _this.roomId) || other.roomId == _this.roomId)&&(identical(other.gameNumber, _this.gameNumber) || other.gameNumber == _this.gameNumber)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.currentPlayerId, _this.currentPlayerId) || other.currentPlayerId == _this.currentPlayerId)&&(identical(other.previousPlayerId, _this.previousPlayerId) || other.previousPlayerId == _this.previousPlayerId)&&(identical(other.payerId, _this.payerId) || other.payerId == _this.payerId)&&const DeepCollectionEquality().equals(other.playerOrder, _this.playerOrder)&&const DeepCollectionEquality().equals(other.remainingBalls, _this.remainingBalls)&&(identical(other.chainState, _this.chainState) || other.chainState == _this.chainState)&&(identical(other.winnerId, _this.winnerId) || other.winnerId == _this.winnerId)&&(identical(other.finalPayerId, _this.finalPayerId) || other.finalPayerId == _this.finalPayerId)&&(identical(other.isBreakClear, _this.isBreakClear) || other.isBreakClear == _this.isBreakClear)&&const DeepCollectionEquality().equals(other.turns, _this.turns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GameSession;
  return Object.hash(runtimeType,_this.id,_this.roomId,_this.gameNumber,_this.status,_this.startedAt,_this.endedAt,_this.currentPlayerId,_this.previousPlayerId,_this.payerId,const DeepCollectionEquality().hash(_this.playerOrder),const DeepCollectionEquality().hash(_this.remainingBalls),_this.chainState,_this.winnerId,_this.finalPayerId,_this.isBreakClear,const DeepCollectionEquality().hash(_this.turns));
}

@override
String toString() {
  final _this = this as GameSession;
  return 'GameSession(id: ${_this.id}, roomId: ${_this.roomId}, gameNumber: ${_this.gameNumber}, status: ${_this.status}, startedAt: ${_this.startedAt}, endedAt: ${_this.endedAt}, currentPlayerId: ${_this.currentPlayerId}, previousPlayerId: ${_this.previousPlayerId}, payerId: ${_this.payerId}, playerOrder: ${_this.playerOrder}, remainingBalls: ${_this.remainingBalls}, chainState: ${_this.chainState}, winnerId: ${_this.winnerId}, finalPayerId: ${_this.finalPayerId}, isBreakClear: ${_this.isBreakClear}, turns: ${_this.turns})';
}


}

/// @nodoc
abstract mixin class $GameSessionCopyWith<$Res>  {
  factory $GameSessionCopyWith(GameSession value, $Res Function(GameSession) _then) = _$GameSessionCopyWithImpl;
@useResult
$Res call({
 String id, String roomId, int gameNumber, GameStatus status, DateTime startedAt, DateTime? endedAt, String currentPlayerId, String? previousPlayerId, String payerId, List<String> playerOrder, Set<int> remainingBalls, ChainState chainState, String? winnerId, String? finalPayerId, bool isBreakClear, List<Turn> turns
});


$ChainStateCopyWith<$Res> get chainState;

}
/// @nodoc
class _$GameSessionCopyWithImpl<$Res>
    implements $GameSessionCopyWith<$Res> {
  _$GameSessionCopyWithImpl(this._self, this._then);

  final GameSession _self;
  final $Res Function(GameSession) _then;

/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roomId = null,Object? gameNumber = null,Object? status = null,Object? startedAt = null,Object? endedAt = freezed,Object? currentPlayerId = null,Object? previousPlayerId = freezed,Object? payerId = null,Object? playerOrder = null,Object? remainingBalls = null,Object? chainState = null,Object? winnerId = freezed,Object? finalPayerId = freezed,Object? isBreakClear = null,Object? turns = null,}) {
  return _then(GameSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,gameNumber: null == gameNumber ? _self.gameNumber : gameNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentPlayerId: null == currentPlayerId ? _self.currentPlayerId : currentPlayerId // ignore: cast_nullable_to_non_nullable
as String,previousPlayerId: freezed == previousPlayerId ? _self.previousPlayerId : previousPlayerId // ignore: cast_nullable_to_non_nullable
as String?,payerId: null == payerId ? _self.payerId : payerId // ignore: cast_nullable_to_non_nullable
as String,playerOrder: null == playerOrder ? _self.playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,remainingBalls: null == remainingBalls ? _self.remainingBalls : remainingBalls // ignore: cast_nullable_to_non_nullable
as Set<int>,chainState: null == chainState ? _self.chainState : chainState // ignore: cast_nullable_to_non_nullable
as ChainState,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,finalPayerId: freezed == finalPayerId ? _self.finalPayerId : finalPayerId // ignore: cast_nullable_to_non_nullable
as String?,isBreakClear: null == isBreakClear ? _self.isBreakClear : isBreakClear // ignore: cast_nullable_to_non_nullable
as bool,turns: null == turns ? _self.turns : turns // ignore: cast_nullable_to_non_nullable
as List<Turn>,
  ));
}
/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChainStateCopyWith<$Res> get chainState {
  
  return $ChainStateCopyWith<$Res>(_self.chainState, (value) {
    return _then(_self.copyWith(chainState: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameSession].
extension GameSessionPatterns on GameSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameSession value)  $default,){
final _that = this;
switch (_that) {
case _GameSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameSession value)?  $default,){
final _that = this;
switch (_that) {
case _GameSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String roomId,  int gameNumber,  GameStatus status,  DateTime startedAt,  DateTime? endedAt,  String currentPlayerId,  String? previousPlayerId,  String payerId,  List<String> playerOrder,  Set<int> remainingBalls,  ChainState chainState,  String? winnerId,  String? finalPayerId,  bool isBreakClear,  List<Turn> turns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameSession() when $default != null:
return $default(_that.id,_that.roomId,_that.gameNumber,_that.status,_that.startedAt,_that.endedAt,_that.currentPlayerId,_that.previousPlayerId,_that.payerId,_that.playerOrder,_that.remainingBalls,_that.chainState,_that.winnerId,_that.finalPayerId,_that.isBreakClear,_that.turns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String roomId,  int gameNumber,  GameStatus status,  DateTime startedAt,  DateTime? endedAt,  String currentPlayerId,  String? previousPlayerId,  String payerId,  List<String> playerOrder,  Set<int> remainingBalls,  ChainState chainState,  String? winnerId,  String? finalPayerId,  bool isBreakClear,  List<Turn> turns)  $default,) {final _that = this;
switch (_that) {
case _GameSession():
return $default(_that.id,_that.roomId,_that.gameNumber,_that.status,_that.startedAt,_that.endedAt,_that.currentPlayerId,_that.previousPlayerId,_that.payerId,_that.playerOrder,_that.remainingBalls,_that.chainState,_that.winnerId,_that.finalPayerId,_that.isBreakClear,_that.turns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String roomId,  int gameNumber,  GameStatus status,  DateTime startedAt,  DateTime? endedAt,  String currentPlayerId,  String? previousPlayerId,  String payerId,  List<String> playerOrder,  Set<int> remainingBalls,  ChainState chainState,  String? winnerId,  String? finalPayerId,  bool isBreakClear,  List<Turn> turns)?  $default,) {final _that = this;
switch (_that) {
case _GameSession() when $default != null:
return $default(_that.id,_that.roomId,_that.gameNumber,_that.status,_that.startedAt,_that.endedAt,_that.currentPlayerId,_that.previousPlayerId,_that.payerId,_that.playerOrder,_that.remainingBalls,_that.chainState,_that.winnerId,_that.finalPayerId,_that.isBreakClear,_that.turns);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _GameSession implements GameSession {
  const _GameSession({required this.id, required this.roomId, required this.gameNumber, required this.status, required this.startedAt, this.endedAt, required this.currentPlayerId, this.previousPlayerId, required this.payerId, required  List<String> playerOrder, required  Set<int> remainingBalls, required this.chainState, this.winnerId, this.finalPayerId, this.isBreakClear = false,  List<Turn> turns = const []}): _playerOrder = playerOrder,_remainingBalls = remainingBalls,_turns = turns;
  factory _GameSession.fromJson(Map<String, dynamic> json) => _$GameSessionFromJson(json);

@override final  String id;
@override final  String roomId;
@override final  int gameNumber;
@override final  GameStatus status;
@override final  DateTime startedAt;
@override final  DateTime? endedAt;
@override final  String currentPlayerId;
@override final  String? previousPlayerId;
@override final  String payerId;
 final  List<String> _playerOrder;
@override List<String> get playerOrder {
  if (_playerOrder is EqualUnmodifiableListView) return _playerOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerOrder);
}

 final  Set<int> _remainingBalls;
@override Set<int> get remainingBalls {
  if (_remainingBalls is EqualUnmodifiableSetView) return _remainingBalls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_remainingBalls);
}

@override final  ChainState chainState;
@override final  String? winnerId;
@override final  String? finalPayerId;
@override@JsonKey() final  bool isBreakClear;
 final  List<Turn> _turns;
@override@JsonKey() List<Turn> get turns {
  if (_turns is EqualUnmodifiableListView) return _turns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_turns);
}


/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameSessionCopyWith<_GameSession> get copyWith => __$GameSessionCopyWithImpl<_GameSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameSessionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameSession&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.gameNumber, gameNumber) || other.gameNumber == gameNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.currentPlayerId, currentPlayerId) || other.currentPlayerId == currentPlayerId)&&(identical(other.previousPlayerId, previousPlayerId) || other.previousPlayerId == previousPlayerId)&&(identical(other.payerId, payerId) || other.payerId == payerId)&&const DeepCollectionEquality().equals(other.playerOrder, _playerOrder)&&const DeepCollectionEquality().equals(other.remainingBalls, _remainingBalls)&&(identical(other.chainState, chainState) || other.chainState == chainState)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.finalPayerId, finalPayerId) || other.finalPayerId == finalPayerId)&&(identical(other.isBreakClear, isBreakClear) || other.isBreakClear == isBreakClear)&&const DeepCollectionEquality().equals(other.turns, _turns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,roomId,gameNumber,status,startedAt,endedAt,currentPlayerId,previousPlayerId,payerId,const DeepCollectionEquality().hash(_playerOrder),const DeepCollectionEquality().hash(_remainingBalls),chainState,winnerId,finalPayerId,isBreakClear,const DeepCollectionEquality().hash(_turns));
}

@override
String toString() {
    return 'GameSession(id: $id, roomId: $roomId, gameNumber: $gameNumber, status: $status, startedAt: $startedAt, endedAt: $endedAt, currentPlayerId: $currentPlayerId, previousPlayerId: $previousPlayerId, payerId: $payerId, playerOrder: $playerOrder, remainingBalls: $remainingBalls, chainState: $chainState, winnerId: $winnerId, finalPayerId: $finalPayerId, isBreakClear: $isBreakClear, turns: $turns)';
}


}

/// @nodoc
abstract mixin class _$GameSessionCopyWith<$Res> implements $GameSessionCopyWith<$Res> {
  factory _$GameSessionCopyWith(_GameSession value, $Res Function(_GameSession) _then) = __$GameSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String roomId, int gameNumber, GameStatus status, DateTime startedAt, DateTime? endedAt, String currentPlayerId, String? previousPlayerId, String payerId, List<String> playerOrder, Set<int> remainingBalls, ChainState chainState, String? winnerId, String? finalPayerId, bool isBreakClear, List<Turn> turns
});


@override $ChainStateCopyWith<$Res> get chainState;

}
/// @nodoc
class __$GameSessionCopyWithImpl<$Res>
    implements _$GameSessionCopyWith<$Res> {
  __$GameSessionCopyWithImpl(this._self, this._then);

  final _GameSession _self;
  final $Res Function(_GameSession) _then;

/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roomId = null,Object? gameNumber = null,Object? status = null,Object? startedAt = null,Object? endedAt = freezed,Object? currentPlayerId = null,Object? previousPlayerId = freezed,Object? payerId = null,Object? playerOrder = null,Object? remainingBalls = null,Object? chainState = null,Object? winnerId = freezed,Object? finalPayerId = freezed,Object? isBreakClear = null,Object? turns = null,}) {
  return _then(_GameSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,gameNumber: null == gameNumber ? _self.gameNumber : gameNumber // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as GameStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,currentPlayerId: null == currentPlayerId ? _self.currentPlayerId : currentPlayerId // ignore: cast_nullable_to_non_nullable
as String,previousPlayerId: freezed == previousPlayerId ? _self.previousPlayerId : previousPlayerId // ignore: cast_nullable_to_non_nullable
as String?,payerId: null == payerId ? _self.payerId : payerId // ignore: cast_nullable_to_non_nullable
as String,playerOrder: null == playerOrder ? _self._playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,remainingBalls: null == remainingBalls ? _self._remainingBalls : remainingBalls // ignore: cast_nullable_to_non_nullable
as Set<int>,chainState: null == chainState ? _self.chainState : chainState // ignore: cast_nullable_to_non_nullable
as ChainState,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,finalPayerId: freezed == finalPayerId ? _self.finalPayerId : finalPayerId // ignore: cast_nullable_to_non_nullable
as String?,isBreakClear: null == isBreakClear ? _self.isBreakClear : isBreakClear // ignore: cast_nullable_to_non_nullable
as bool,turns: null == turns ? _self._turns : turns // ignore: cast_nullable_to_non_nullable
as List<Turn>,
  ));
}

/// Create a copy of GameSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChainStateCopyWith<$Res> get chainState {
  
  return $ChainStateCopyWith<$Res>(_self.chainState, (value) {
    return _then(_self.copyWith(chainState: value));
  });
}
}

// dart format on
