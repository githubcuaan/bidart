// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'turn_state_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TurnStateSnapshot {

 String get roomId; String get gameId; Map<String, int> get scores; List<String> get activePlayerIds; List<String> get playerOrder; String get currentPlayerId; String? get previousPlayerId; String get payerId; ChainState get chainState; Set<int> get remainingBalls; RoomStatus get roomStatus; GameStatus get gameStatus; DateTime get roomCreatedAt; DateTime? get roomEndedAt; DateTime get gameStartedAt; DateTime? get gameEndedAt; String? get winnerId; String? get finalPayerId; bool get isBreakClear; Set<PendingEndReason> get pendingEndReasons;
/// Create a copy of TurnStateSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TurnStateSnapshotCopyWith<TurnStateSnapshot> get copyWith => _$TurnStateSnapshotCopyWithImpl<TurnStateSnapshot>(this as TurnStateSnapshot, _$identity);

  /// Serializes this TurnStateSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TurnStateSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TurnStateSnapshot&&(identical(other.roomId, _this.roomId) || other.roomId == _this.roomId)&&(identical(other.gameId, _this.gameId) || other.gameId == _this.gameId)&&const DeepCollectionEquality().equals(other.scores, _this.scores)&&const DeepCollectionEquality().equals(other.activePlayerIds, _this.activePlayerIds)&&const DeepCollectionEquality().equals(other.playerOrder, _this.playerOrder)&&(identical(other.currentPlayerId, _this.currentPlayerId) || other.currentPlayerId == _this.currentPlayerId)&&(identical(other.previousPlayerId, _this.previousPlayerId) || other.previousPlayerId == _this.previousPlayerId)&&(identical(other.payerId, _this.payerId) || other.payerId == _this.payerId)&&(identical(other.chainState, _this.chainState) || other.chainState == _this.chainState)&&const DeepCollectionEquality().equals(other.remainingBalls, _this.remainingBalls)&&(identical(other.roomStatus, _this.roomStatus) || other.roomStatus == _this.roomStatus)&&(identical(other.gameStatus, _this.gameStatus) || other.gameStatus == _this.gameStatus)&&(identical(other.roomCreatedAt, _this.roomCreatedAt) || other.roomCreatedAt == _this.roomCreatedAt)&&(identical(other.roomEndedAt, _this.roomEndedAt) || other.roomEndedAt == _this.roomEndedAt)&&(identical(other.gameStartedAt, _this.gameStartedAt) || other.gameStartedAt == _this.gameStartedAt)&&(identical(other.gameEndedAt, _this.gameEndedAt) || other.gameEndedAt == _this.gameEndedAt)&&(identical(other.winnerId, _this.winnerId) || other.winnerId == _this.winnerId)&&(identical(other.finalPayerId, _this.finalPayerId) || other.finalPayerId == _this.finalPayerId)&&(identical(other.isBreakClear, _this.isBreakClear) || other.isBreakClear == _this.isBreakClear)&&const DeepCollectionEquality().equals(other.pendingEndReasons, _this.pendingEndReasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TurnStateSnapshot;
  return Object.hashAll([runtimeType,_this.roomId,_this.gameId,const DeepCollectionEquality().hash(_this.scores),const DeepCollectionEquality().hash(_this.activePlayerIds),const DeepCollectionEquality().hash(_this.playerOrder),_this.currentPlayerId,_this.previousPlayerId,_this.payerId,_this.chainState,const DeepCollectionEquality().hash(_this.remainingBalls),_this.roomStatus,_this.gameStatus,_this.roomCreatedAt,_this.roomEndedAt,_this.gameStartedAt,_this.gameEndedAt,_this.winnerId,_this.finalPayerId,_this.isBreakClear,const DeepCollectionEquality().hash(_this.pendingEndReasons)]);
}

@override
String toString() {
  final _this = this as TurnStateSnapshot;
  return 'TurnStateSnapshot(roomId: ${_this.roomId}, gameId: ${_this.gameId}, scores: ${_this.scores}, activePlayerIds: ${_this.activePlayerIds}, playerOrder: ${_this.playerOrder}, currentPlayerId: ${_this.currentPlayerId}, previousPlayerId: ${_this.previousPlayerId}, payerId: ${_this.payerId}, chainState: ${_this.chainState}, remainingBalls: ${_this.remainingBalls}, roomStatus: ${_this.roomStatus}, gameStatus: ${_this.gameStatus}, roomCreatedAt: ${_this.roomCreatedAt}, roomEndedAt: ${_this.roomEndedAt}, gameStartedAt: ${_this.gameStartedAt}, gameEndedAt: ${_this.gameEndedAt}, winnerId: ${_this.winnerId}, finalPayerId: ${_this.finalPayerId}, isBreakClear: ${_this.isBreakClear}, pendingEndReasons: ${_this.pendingEndReasons})';
}


}

/// @nodoc
abstract mixin class $TurnStateSnapshotCopyWith<$Res>  {
  factory $TurnStateSnapshotCopyWith(TurnStateSnapshot value, $Res Function(TurnStateSnapshot) _then) = _$TurnStateSnapshotCopyWithImpl;
@useResult
$Res call({
 String roomId, String gameId, Map<String, int> scores, List<String> activePlayerIds, List<String> playerOrder, String currentPlayerId, String? previousPlayerId, String payerId, ChainState chainState, Set<int> remainingBalls, RoomStatus roomStatus, GameStatus gameStatus, DateTime roomCreatedAt, DateTime? roomEndedAt, DateTime gameStartedAt, DateTime? gameEndedAt, String? winnerId, String? finalPayerId, bool isBreakClear, Set<PendingEndReason> pendingEndReasons
});


$ChainStateCopyWith<$Res> get chainState;

}
/// @nodoc
class _$TurnStateSnapshotCopyWithImpl<$Res>
    implements $TurnStateSnapshotCopyWith<$Res> {
  _$TurnStateSnapshotCopyWithImpl(this._self, this._then);

  final TurnStateSnapshot _self;
  final $Res Function(TurnStateSnapshot) _then;

/// Create a copy of TurnStateSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomId = null,Object? gameId = null,Object? scores = null,Object? activePlayerIds = null,Object? playerOrder = null,Object? currentPlayerId = null,Object? previousPlayerId = freezed,Object? payerId = null,Object? chainState = null,Object? remainingBalls = null,Object? roomStatus = null,Object? gameStatus = null,Object? roomCreatedAt = null,Object? roomEndedAt = freezed,Object? gameStartedAt = null,Object? gameEndedAt = freezed,Object? winnerId = freezed,Object? finalPayerId = freezed,Object? isBreakClear = null,Object? pendingEndReasons = null,}) {
  return _then(TurnStateSnapshot(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,scores: null == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, int>,activePlayerIds: null == activePlayerIds ? _self.activePlayerIds : activePlayerIds // ignore: cast_nullable_to_non_nullable
as List<String>,playerOrder: null == playerOrder ? _self.playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,currentPlayerId: null == currentPlayerId ? _self.currentPlayerId : currentPlayerId // ignore: cast_nullable_to_non_nullable
as String,previousPlayerId: freezed == previousPlayerId ? _self.previousPlayerId : previousPlayerId // ignore: cast_nullable_to_non_nullable
as String?,payerId: null == payerId ? _self.payerId : payerId // ignore: cast_nullable_to_non_nullable
as String,chainState: null == chainState ? _self.chainState : chainState // ignore: cast_nullable_to_non_nullable
as ChainState,remainingBalls: null == remainingBalls ? _self.remainingBalls : remainingBalls // ignore: cast_nullable_to_non_nullable
as Set<int>,roomStatus: null == roomStatus ? _self.roomStatus : roomStatus // ignore: cast_nullable_to_non_nullable
as RoomStatus,gameStatus: null == gameStatus ? _self.gameStatus : gameStatus // ignore: cast_nullable_to_non_nullable
as GameStatus,roomCreatedAt: null == roomCreatedAt ? _self.roomCreatedAt : roomCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,roomEndedAt: freezed == roomEndedAt ? _self.roomEndedAt : roomEndedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,gameStartedAt: null == gameStartedAt ? _self.gameStartedAt : gameStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime,gameEndedAt: freezed == gameEndedAt ? _self.gameEndedAt : gameEndedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,finalPayerId: freezed == finalPayerId ? _self.finalPayerId : finalPayerId // ignore: cast_nullable_to_non_nullable
as String?,isBreakClear: null == isBreakClear ? _self.isBreakClear : isBreakClear // ignore: cast_nullable_to_non_nullable
as bool,pendingEndReasons: null == pendingEndReasons ? _self.pendingEndReasons : pendingEndReasons // ignore: cast_nullable_to_non_nullable
as Set<PendingEndReason>,
  ));
}
/// Create a copy of TurnStateSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ChainStateCopyWith<$Res> get chainState {
  
  return $ChainStateCopyWith<$Res>(_self.chainState, (value) {
    return _then(_self.copyWith(chainState: value));
  });
}
}


/// Adds pattern-matching-related methods to [TurnStateSnapshot].
extension TurnStateSnapshotPatterns on TurnStateSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TurnStateSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TurnStateSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TurnStateSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _TurnStateSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TurnStateSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _TurnStateSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String roomId,  String gameId,  Map<String, int> scores,  List<String> activePlayerIds,  List<String> playerOrder,  String currentPlayerId,  String? previousPlayerId,  String payerId,  ChainState chainState,  Set<int> remainingBalls,  RoomStatus roomStatus,  GameStatus gameStatus,  DateTime roomCreatedAt,  DateTime? roomEndedAt,  DateTime gameStartedAt,  DateTime? gameEndedAt,  String? winnerId,  String? finalPayerId,  bool isBreakClear,  Set<PendingEndReason> pendingEndReasons)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TurnStateSnapshot() when $default != null:
return $default(_that.roomId,_that.gameId,_that.scores,_that.activePlayerIds,_that.playerOrder,_that.currentPlayerId,_that.previousPlayerId,_that.payerId,_that.chainState,_that.remainingBalls,_that.roomStatus,_that.gameStatus,_that.roomCreatedAt,_that.roomEndedAt,_that.gameStartedAt,_that.gameEndedAt,_that.winnerId,_that.finalPayerId,_that.isBreakClear,_that.pendingEndReasons);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String roomId,  String gameId,  Map<String, int> scores,  List<String> activePlayerIds,  List<String> playerOrder,  String currentPlayerId,  String? previousPlayerId,  String payerId,  ChainState chainState,  Set<int> remainingBalls,  RoomStatus roomStatus,  GameStatus gameStatus,  DateTime roomCreatedAt,  DateTime? roomEndedAt,  DateTime gameStartedAt,  DateTime? gameEndedAt,  String? winnerId,  String? finalPayerId,  bool isBreakClear,  Set<PendingEndReason> pendingEndReasons)  $default,) {final _that = this;
switch (_that) {
case _TurnStateSnapshot():
return $default(_that.roomId,_that.gameId,_that.scores,_that.activePlayerIds,_that.playerOrder,_that.currentPlayerId,_that.previousPlayerId,_that.payerId,_that.chainState,_that.remainingBalls,_that.roomStatus,_that.gameStatus,_that.roomCreatedAt,_that.roomEndedAt,_that.gameStartedAt,_that.gameEndedAt,_that.winnerId,_that.finalPayerId,_that.isBreakClear,_that.pendingEndReasons);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String roomId,  String gameId,  Map<String, int> scores,  List<String> activePlayerIds,  List<String> playerOrder,  String currentPlayerId,  String? previousPlayerId,  String payerId,  ChainState chainState,  Set<int> remainingBalls,  RoomStatus roomStatus,  GameStatus gameStatus,  DateTime roomCreatedAt,  DateTime? roomEndedAt,  DateTime gameStartedAt,  DateTime? gameEndedAt,  String? winnerId,  String? finalPayerId,  bool isBreakClear,  Set<PendingEndReason> pendingEndReasons)?  $default,) {final _that = this;
switch (_that) {
case _TurnStateSnapshot() when $default != null:
return $default(_that.roomId,_that.gameId,_that.scores,_that.activePlayerIds,_that.playerOrder,_that.currentPlayerId,_that.previousPlayerId,_that.payerId,_that.chainState,_that.remainingBalls,_that.roomStatus,_that.gameStatus,_that.roomCreatedAt,_that.roomEndedAt,_that.gameStartedAt,_that.gameEndedAt,_that.winnerId,_that.finalPayerId,_that.isBreakClear,_that.pendingEndReasons);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _TurnStateSnapshot implements TurnStateSnapshot {
  const _TurnStateSnapshot({required this.roomId, required this.gameId, required  Map<String, int> scores, required  List<String> activePlayerIds, required  List<String> playerOrder, required this.currentPlayerId, this.previousPlayerId, required this.payerId, required this.chainState, required  Set<int> remainingBalls, required this.roomStatus, required this.gameStatus, required this.roomCreatedAt, this.roomEndedAt, required this.gameStartedAt, this.gameEndedAt, this.winnerId, this.finalPayerId, required this.isBreakClear, required  Set<PendingEndReason> pendingEndReasons}): _scores = scores,_activePlayerIds = activePlayerIds,_playerOrder = playerOrder,_remainingBalls = remainingBalls,_pendingEndReasons = pendingEndReasons;
  factory _TurnStateSnapshot.fromJson(Map<String, dynamic> json) => _$TurnStateSnapshotFromJson(json);

@override final  String roomId;
@override final  String gameId;
 final  Map<String, int> _scores;
@override Map<String, int> get scores {
  if (_scores is EqualUnmodifiableMapView) return _scores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_scores);
}

 final  List<String> _activePlayerIds;
@override List<String> get activePlayerIds {
  if (_activePlayerIds is EqualUnmodifiableListView) return _activePlayerIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_activePlayerIds);
}

 final  List<String> _playerOrder;
@override List<String> get playerOrder {
  if (_playerOrder is EqualUnmodifiableListView) return _playerOrder;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_playerOrder);
}

@override final  String currentPlayerId;
@override final  String? previousPlayerId;
@override final  String payerId;
@override final  ChainState chainState;
 final  Set<int> _remainingBalls;
@override Set<int> get remainingBalls {
  if (_remainingBalls is EqualUnmodifiableSetView) return _remainingBalls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_remainingBalls);
}

@override final  RoomStatus roomStatus;
@override final  GameStatus gameStatus;
@override final  DateTime roomCreatedAt;
@override final  DateTime? roomEndedAt;
@override final  DateTime gameStartedAt;
@override final  DateTime? gameEndedAt;
@override final  String? winnerId;
@override final  String? finalPayerId;
@override final  bool isBreakClear;
 final  Set<PendingEndReason> _pendingEndReasons;
@override Set<PendingEndReason> get pendingEndReasons {
  if (_pendingEndReasons is EqualUnmodifiableSetView) return _pendingEndReasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingEndReasons);
}


/// Create a copy of TurnStateSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TurnStateSnapshotCopyWith<_TurnStateSnapshot> get copyWith => __$TurnStateSnapshotCopyWithImpl<_TurnStateSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TurnStateSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TurnStateSnapshot&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.gameId, gameId) || other.gameId == gameId)&&const DeepCollectionEquality().equals(other.scores, _scores)&&const DeepCollectionEquality().equals(other.activePlayerIds, _activePlayerIds)&&const DeepCollectionEquality().equals(other.playerOrder, _playerOrder)&&(identical(other.currentPlayerId, currentPlayerId) || other.currentPlayerId == currentPlayerId)&&(identical(other.previousPlayerId, previousPlayerId) || other.previousPlayerId == previousPlayerId)&&(identical(other.payerId, payerId) || other.payerId == payerId)&&(identical(other.chainState, chainState) || other.chainState == chainState)&&const DeepCollectionEquality().equals(other.remainingBalls, _remainingBalls)&&(identical(other.roomStatus, roomStatus) || other.roomStatus == roomStatus)&&(identical(other.gameStatus, gameStatus) || other.gameStatus == gameStatus)&&(identical(other.roomCreatedAt, roomCreatedAt) || other.roomCreatedAt == roomCreatedAt)&&(identical(other.roomEndedAt, roomEndedAt) || other.roomEndedAt == roomEndedAt)&&(identical(other.gameStartedAt, gameStartedAt) || other.gameStartedAt == gameStartedAt)&&(identical(other.gameEndedAt, gameEndedAt) || other.gameEndedAt == gameEndedAt)&&(identical(other.winnerId, winnerId) || other.winnerId == winnerId)&&(identical(other.finalPayerId, finalPayerId) || other.finalPayerId == finalPayerId)&&(identical(other.isBreakClear, isBreakClear) || other.isBreakClear == isBreakClear)&&const DeepCollectionEquality().equals(other.pendingEndReasons, _pendingEndReasons));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,roomId,gameId,const DeepCollectionEquality().hash(_scores),const DeepCollectionEquality().hash(_activePlayerIds),const DeepCollectionEquality().hash(_playerOrder),currentPlayerId,previousPlayerId,payerId,chainState,const DeepCollectionEquality().hash(_remainingBalls),roomStatus,gameStatus,roomCreatedAt,roomEndedAt,gameStartedAt,gameEndedAt,winnerId,finalPayerId,isBreakClear,const DeepCollectionEquality().hash(_pendingEndReasons)]);
}

@override
String toString() {
    return 'TurnStateSnapshot(roomId: $roomId, gameId: $gameId, scores: $scores, activePlayerIds: $activePlayerIds, playerOrder: $playerOrder, currentPlayerId: $currentPlayerId, previousPlayerId: $previousPlayerId, payerId: $payerId, chainState: $chainState, remainingBalls: $remainingBalls, roomStatus: $roomStatus, gameStatus: $gameStatus, roomCreatedAt: $roomCreatedAt, roomEndedAt: $roomEndedAt, gameStartedAt: $gameStartedAt, gameEndedAt: $gameEndedAt, winnerId: $winnerId, finalPayerId: $finalPayerId, isBreakClear: $isBreakClear, pendingEndReasons: $pendingEndReasons)';
}


}

/// @nodoc
abstract mixin class _$TurnStateSnapshotCopyWith<$Res> implements $TurnStateSnapshotCopyWith<$Res> {
  factory _$TurnStateSnapshotCopyWith(_TurnStateSnapshot value, $Res Function(_TurnStateSnapshot) _then) = __$TurnStateSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String roomId, String gameId, Map<String, int> scores, List<String> activePlayerIds, List<String> playerOrder, String currentPlayerId, String? previousPlayerId, String payerId, ChainState chainState, Set<int> remainingBalls, RoomStatus roomStatus, GameStatus gameStatus, DateTime roomCreatedAt, DateTime? roomEndedAt, DateTime gameStartedAt, DateTime? gameEndedAt, String? winnerId, String? finalPayerId, bool isBreakClear, Set<PendingEndReason> pendingEndReasons
});


@override $ChainStateCopyWith<$Res> get chainState;

}
/// @nodoc
class __$TurnStateSnapshotCopyWithImpl<$Res>
    implements _$TurnStateSnapshotCopyWith<$Res> {
  __$TurnStateSnapshotCopyWithImpl(this._self, this._then);

  final _TurnStateSnapshot _self;
  final $Res Function(_TurnStateSnapshot) _then;

/// Create a copy of TurnStateSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomId = null,Object? gameId = null,Object? scores = null,Object? activePlayerIds = null,Object? playerOrder = null,Object? currentPlayerId = null,Object? previousPlayerId = freezed,Object? payerId = null,Object? chainState = null,Object? remainingBalls = null,Object? roomStatus = null,Object? gameStatus = null,Object? roomCreatedAt = null,Object? roomEndedAt = freezed,Object? gameStartedAt = null,Object? gameEndedAt = freezed,Object? winnerId = freezed,Object? finalPayerId = freezed,Object? isBreakClear = null,Object? pendingEndReasons = null,}) {
  return _then(_TurnStateSnapshot(
roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,scores: null == scores ? _self._scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, int>,activePlayerIds: null == activePlayerIds ? _self._activePlayerIds : activePlayerIds // ignore: cast_nullable_to_non_nullable
as List<String>,playerOrder: null == playerOrder ? _self._playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,currentPlayerId: null == currentPlayerId ? _self.currentPlayerId : currentPlayerId // ignore: cast_nullable_to_non_nullable
as String,previousPlayerId: freezed == previousPlayerId ? _self.previousPlayerId : previousPlayerId // ignore: cast_nullable_to_non_nullable
as String?,payerId: null == payerId ? _self.payerId : payerId // ignore: cast_nullable_to_non_nullable
as String,chainState: null == chainState ? _self.chainState : chainState // ignore: cast_nullable_to_non_nullable
as ChainState,remainingBalls: null == remainingBalls ? _self._remainingBalls : remainingBalls // ignore: cast_nullable_to_non_nullable
as Set<int>,roomStatus: null == roomStatus ? _self.roomStatus : roomStatus // ignore: cast_nullable_to_non_nullable
as RoomStatus,gameStatus: null == gameStatus ? _self.gameStatus : gameStatus // ignore: cast_nullable_to_non_nullable
as GameStatus,roomCreatedAt: null == roomCreatedAt ? _self.roomCreatedAt : roomCreatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,roomEndedAt: freezed == roomEndedAt ? _self.roomEndedAt : roomEndedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,gameStartedAt: null == gameStartedAt ? _self.gameStartedAt : gameStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime,gameEndedAt: freezed == gameEndedAt ? _self.gameEndedAt : gameEndedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,winnerId: freezed == winnerId ? _self.winnerId : winnerId // ignore: cast_nullable_to_non_nullable
as String?,finalPayerId: freezed == finalPayerId ? _self.finalPayerId : finalPayerId // ignore: cast_nullable_to_non_nullable
as String?,isBreakClear: null == isBreakClear ? _self.isBreakClear : isBreakClear // ignore: cast_nullable_to_non_nullable
as bool,pendingEndReasons: null == pendingEndReasons ? _self._pendingEndReasons : pendingEndReasons // ignore: cast_nullable_to_non_nullable
as Set<PendingEndReason>,
  ));
}

/// Create a copy of TurnStateSnapshot
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
