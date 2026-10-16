// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'turn.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Turn {

 String get id; String get commandId; String get roomId; String get gameId; int get turnNumber; String get actorId; List<String> get payerIds; String get ruleConfigId; int get ruleVersion; List<PottedBall> get pottedBalls; FoulClassification get foulClassification; List<ScoreTransaction> get transactions; List<ScoreLog> get logs; TurnStateSnapshot get beforeSnapshot; TurnStateSnapshot get afterSnapshot; DateTime get createdAt; int get revision; bool get isUndone;
/// Create a copy of Turn
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TurnCopyWith<Turn> get copyWith => _$TurnCopyWithImpl<Turn>(this as Turn, _$identity);

  /// Serializes this Turn to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Turn;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Turn&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.commandId, _this.commandId) || other.commandId == _this.commandId)&&(identical(other.roomId, _this.roomId) || other.roomId == _this.roomId)&&(identical(other.gameId, _this.gameId) || other.gameId == _this.gameId)&&(identical(other.turnNumber, _this.turnNumber) || other.turnNumber == _this.turnNumber)&&(identical(other.actorId, _this.actorId) || other.actorId == _this.actorId)&&const DeepCollectionEquality().equals(other.payerIds, _this.payerIds)&&(identical(other.ruleConfigId, _this.ruleConfigId) || other.ruleConfigId == _this.ruleConfigId)&&(identical(other.ruleVersion, _this.ruleVersion) || other.ruleVersion == _this.ruleVersion)&&const DeepCollectionEquality().equals(other.pottedBalls, _this.pottedBalls)&&(identical(other.foulClassification, _this.foulClassification) || other.foulClassification == _this.foulClassification)&&const DeepCollectionEquality().equals(other.transactions, _this.transactions)&&const DeepCollectionEquality().equals(other.logs, _this.logs)&&(identical(other.beforeSnapshot, _this.beforeSnapshot) || other.beforeSnapshot == _this.beforeSnapshot)&&(identical(other.afterSnapshot, _this.afterSnapshot) || other.afterSnapshot == _this.afterSnapshot)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.revision, _this.revision) || other.revision == _this.revision)&&(identical(other.isUndone, _this.isUndone) || other.isUndone == _this.isUndone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Turn;
  return Object.hash(runtimeType,_this.id,_this.commandId,_this.roomId,_this.gameId,_this.turnNumber,_this.actorId,const DeepCollectionEquality().hash(_this.payerIds),_this.ruleConfigId,_this.ruleVersion,const DeepCollectionEquality().hash(_this.pottedBalls),_this.foulClassification,const DeepCollectionEquality().hash(_this.transactions),const DeepCollectionEquality().hash(_this.logs),_this.beforeSnapshot,_this.afterSnapshot,_this.createdAt,_this.revision,_this.isUndone);
}

@override
String toString() {
  final _this = this as Turn;
  return 'Turn(id: ${_this.id}, commandId: ${_this.commandId}, roomId: ${_this.roomId}, gameId: ${_this.gameId}, turnNumber: ${_this.turnNumber}, actorId: ${_this.actorId}, payerIds: ${_this.payerIds}, ruleConfigId: ${_this.ruleConfigId}, ruleVersion: ${_this.ruleVersion}, pottedBalls: ${_this.pottedBalls}, foulClassification: ${_this.foulClassification}, transactions: ${_this.transactions}, logs: ${_this.logs}, beforeSnapshot: ${_this.beforeSnapshot}, afterSnapshot: ${_this.afterSnapshot}, createdAt: ${_this.createdAt}, revision: ${_this.revision}, isUndone: ${_this.isUndone})';
}


}

/// @nodoc
abstract mixin class $TurnCopyWith<$Res>  {
  factory $TurnCopyWith(Turn value, $Res Function(Turn) _then) = _$TurnCopyWithImpl;
@useResult
$Res call({
 String id, String commandId, String roomId, String gameId, int turnNumber, String actorId, List<String> payerIds, String ruleConfigId, int ruleVersion, List<PottedBall> pottedBalls, FoulClassification foulClassification, List<ScoreTransaction> transactions, List<ScoreLog> logs, TurnStateSnapshot beforeSnapshot, TurnStateSnapshot afterSnapshot, DateTime createdAt, int revision, bool isUndone
});


$TurnStateSnapshotCopyWith<$Res> get beforeSnapshot;$TurnStateSnapshotCopyWith<$Res> get afterSnapshot;

}
/// @nodoc
class _$TurnCopyWithImpl<$Res>
    implements $TurnCopyWith<$Res> {
  _$TurnCopyWithImpl(this._self, this._then);

  final Turn _self;
  final $Res Function(Turn) _then;

/// Create a copy of Turn
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? commandId = null,Object? roomId = null,Object? gameId = null,Object? turnNumber = null,Object? actorId = null,Object? payerIds = null,Object? ruleConfigId = null,Object? ruleVersion = null,Object? pottedBalls = null,Object? foulClassification = null,Object? transactions = null,Object? logs = null,Object? beforeSnapshot = null,Object? afterSnapshot = null,Object? createdAt = null,Object? revision = null,Object? isUndone = null,}) {
  return _then(Turn(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,commandId: null == commandId ? _self.commandId : commandId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,turnNumber: null == turnNumber ? _self.turnNumber : turnNumber // ignore: cast_nullable_to_non_nullable
as int,actorId: null == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String,payerIds: null == payerIds ? _self.payerIds : payerIds // ignore: cast_nullable_to_non_nullable
as List<String>,ruleConfigId: null == ruleConfigId ? _self.ruleConfigId : ruleConfigId // ignore: cast_nullable_to_non_nullable
as String,ruleVersion: null == ruleVersion ? _self.ruleVersion : ruleVersion // ignore: cast_nullable_to_non_nullable
as int,pottedBalls: null == pottedBalls ? _self.pottedBalls : pottedBalls // ignore: cast_nullable_to_non_nullable
as List<PottedBall>,foulClassification: null == foulClassification ? _self.foulClassification : foulClassification // ignore: cast_nullable_to_non_nullable
as FoulClassification,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<ScoreTransaction>,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as List<ScoreLog>,beforeSnapshot: null == beforeSnapshot ? _self.beforeSnapshot : beforeSnapshot // ignore: cast_nullable_to_non_nullable
as TurnStateSnapshot,afterSnapshot: null == afterSnapshot ? _self.afterSnapshot : afterSnapshot // ignore: cast_nullable_to_non_nullable
as TurnStateSnapshot,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,isUndone: null == isUndone ? _self.isUndone : isUndone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of Turn
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TurnStateSnapshotCopyWith<$Res> get beforeSnapshot {
  
  return $TurnStateSnapshotCopyWith<$Res>(_self.beforeSnapshot, (value) {
    return _then(_self.copyWith(beforeSnapshot: value));
  });
}/// Create a copy of Turn
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TurnStateSnapshotCopyWith<$Res> get afterSnapshot {
  
  return $TurnStateSnapshotCopyWith<$Res>(_self.afterSnapshot, (value) {
    return _then(_self.copyWith(afterSnapshot: value));
  });
}
}


/// Adds pattern-matching-related methods to [Turn].
extension TurnPatterns on Turn {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Turn value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Turn() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Turn value)  $default,){
final _that = this;
switch (_that) {
case _Turn():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Turn value)?  $default,){
final _that = this;
switch (_that) {
case _Turn() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String commandId,  String roomId,  String gameId,  int turnNumber,  String actorId,  List<String> payerIds,  String ruleConfigId,  int ruleVersion,  List<PottedBall> pottedBalls,  FoulClassification foulClassification,  List<ScoreTransaction> transactions,  List<ScoreLog> logs,  TurnStateSnapshot beforeSnapshot,  TurnStateSnapshot afterSnapshot,  DateTime createdAt,  int revision,  bool isUndone)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Turn() when $default != null:
return $default(_that.id,_that.commandId,_that.roomId,_that.gameId,_that.turnNumber,_that.actorId,_that.payerIds,_that.ruleConfigId,_that.ruleVersion,_that.pottedBalls,_that.foulClassification,_that.transactions,_that.logs,_that.beforeSnapshot,_that.afterSnapshot,_that.createdAt,_that.revision,_that.isUndone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String commandId,  String roomId,  String gameId,  int turnNumber,  String actorId,  List<String> payerIds,  String ruleConfigId,  int ruleVersion,  List<PottedBall> pottedBalls,  FoulClassification foulClassification,  List<ScoreTransaction> transactions,  List<ScoreLog> logs,  TurnStateSnapshot beforeSnapshot,  TurnStateSnapshot afterSnapshot,  DateTime createdAt,  int revision,  bool isUndone)  $default,) {final _that = this;
switch (_that) {
case _Turn():
return $default(_that.id,_that.commandId,_that.roomId,_that.gameId,_that.turnNumber,_that.actorId,_that.payerIds,_that.ruleConfigId,_that.ruleVersion,_that.pottedBalls,_that.foulClassification,_that.transactions,_that.logs,_that.beforeSnapshot,_that.afterSnapshot,_that.createdAt,_that.revision,_that.isUndone);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String commandId,  String roomId,  String gameId,  int turnNumber,  String actorId,  List<String> payerIds,  String ruleConfigId,  int ruleVersion,  List<PottedBall> pottedBalls,  FoulClassification foulClassification,  List<ScoreTransaction> transactions,  List<ScoreLog> logs,  TurnStateSnapshot beforeSnapshot,  TurnStateSnapshot afterSnapshot,  DateTime createdAt,  int revision,  bool isUndone)?  $default,) {final _that = this;
switch (_that) {
case _Turn() when $default != null:
return $default(_that.id,_that.commandId,_that.roomId,_that.gameId,_that.turnNumber,_that.actorId,_that.payerIds,_that.ruleConfigId,_that.ruleVersion,_that.pottedBalls,_that.foulClassification,_that.transactions,_that.logs,_that.beforeSnapshot,_that.afterSnapshot,_that.createdAt,_that.revision,_that.isUndone);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Turn implements Turn {
  const _Turn({required this.id, required this.commandId, required this.roomId, required this.gameId, required this.turnNumber, required this.actorId, required  List<String> payerIds, required this.ruleConfigId, required this.ruleVersion, required  List<PottedBall> pottedBalls, required this.foulClassification, required  List<ScoreTransaction> transactions, required  List<ScoreLog> logs, required this.beforeSnapshot, required this.afterSnapshot, required this.createdAt, this.revision = 0, this.isUndone = false}): _payerIds = payerIds,_pottedBalls = pottedBalls,_transactions = transactions,_logs = logs;
  factory _Turn.fromJson(Map<String, dynamic> json) => _$TurnFromJson(json);

@override final  String id;
@override final  String commandId;
@override final  String roomId;
@override final  String gameId;
@override final  int turnNumber;
@override final  String actorId;
 final  List<String> _payerIds;
@override List<String> get payerIds {
  if (_payerIds is EqualUnmodifiableListView) return _payerIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_payerIds);
}

@override final  String ruleConfigId;
@override final  int ruleVersion;
 final  List<PottedBall> _pottedBalls;
@override List<PottedBall> get pottedBalls {
  if (_pottedBalls is EqualUnmodifiableListView) return _pottedBalls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pottedBalls);
}

@override final  FoulClassification foulClassification;
 final  List<ScoreTransaction> _transactions;
@override List<ScoreTransaction> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

 final  List<ScoreLog> _logs;
@override List<ScoreLog> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}

@override final  TurnStateSnapshot beforeSnapshot;
@override final  TurnStateSnapshot afterSnapshot;
@override final  DateTime createdAt;
@override@JsonKey() final  int revision;
@override@JsonKey() final  bool isUndone;

/// Create a copy of Turn
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TurnCopyWith<_Turn> get copyWith => __$TurnCopyWithImpl<_Turn>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TurnToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Turn&&(identical(other.id, id) || other.id == id)&&(identical(other.commandId, commandId) || other.commandId == commandId)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.turnNumber, turnNumber) || other.turnNumber == turnNumber)&&(identical(other.actorId, actorId) || other.actorId == actorId)&&const DeepCollectionEquality().equals(other.payerIds, _payerIds)&&(identical(other.ruleConfigId, ruleConfigId) || other.ruleConfigId == ruleConfigId)&&(identical(other.ruleVersion, ruleVersion) || other.ruleVersion == ruleVersion)&&const DeepCollectionEquality().equals(other.pottedBalls, _pottedBalls)&&(identical(other.foulClassification, foulClassification) || other.foulClassification == foulClassification)&&const DeepCollectionEquality().equals(other.transactions, _transactions)&&const DeepCollectionEquality().equals(other.logs, _logs)&&(identical(other.beforeSnapshot, beforeSnapshot) || other.beforeSnapshot == beforeSnapshot)&&(identical(other.afterSnapshot, afterSnapshot) || other.afterSnapshot == afterSnapshot)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.isUndone, isUndone) || other.isUndone == isUndone));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,commandId,roomId,gameId,turnNumber,actorId,const DeepCollectionEquality().hash(_payerIds),ruleConfigId,ruleVersion,const DeepCollectionEquality().hash(_pottedBalls),foulClassification,const DeepCollectionEquality().hash(_transactions),const DeepCollectionEquality().hash(_logs),beforeSnapshot,afterSnapshot,createdAt,revision,isUndone);
}

@override
String toString() {
    return 'Turn(id: $id, commandId: $commandId, roomId: $roomId, gameId: $gameId, turnNumber: $turnNumber, actorId: $actorId, payerIds: $payerIds, ruleConfigId: $ruleConfigId, ruleVersion: $ruleVersion, pottedBalls: $pottedBalls, foulClassification: $foulClassification, transactions: $transactions, logs: $logs, beforeSnapshot: $beforeSnapshot, afterSnapshot: $afterSnapshot, createdAt: $createdAt, revision: $revision, isUndone: $isUndone)';
}


}

/// @nodoc
abstract mixin class _$TurnCopyWith<$Res> implements $TurnCopyWith<$Res> {
  factory _$TurnCopyWith(_Turn value, $Res Function(_Turn) _then) = __$TurnCopyWithImpl;
@override @useResult
$Res call({
 String id, String commandId, String roomId, String gameId, int turnNumber, String actorId, List<String> payerIds, String ruleConfigId, int ruleVersion, List<PottedBall> pottedBalls, FoulClassification foulClassification, List<ScoreTransaction> transactions, List<ScoreLog> logs, TurnStateSnapshot beforeSnapshot, TurnStateSnapshot afterSnapshot, DateTime createdAt, int revision, bool isUndone
});


@override $TurnStateSnapshotCopyWith<$Res> get beforeSnapshot;@override $TurnStateSnapshotCopyWith<$Res> get afterSnapshot;

}
/// @nodoc
class __$TurnCopyWithImpl<$Res>
    implements _$TurnCopyWith<$Res> {
  __$TurnCopyWithImpl(this._self, this._then);

  final _Turn _self;
  final $Res Function(_Turn) _then;

/// Create a copy of Turn
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? commandId = null,Object? roomId = null,Object? gameId = null,Object? turnNumber = null,Object? actorId = null,Object? payerIds = null,Object? ruleConfigId = null,Object? ruleVersion = null,Object? pottedBalls = null,Object? foulClassification = null,Object? transactions = null,Object? logs = null,Object? beforeSnapshot = null,Object? afterSnapshot = null,Object? createdAt = null,Object? revision = null,Object? isUndone = null,}) {
  return _then(_Turn(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,commandId: null == commandId ? _self.commandId : commandId // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,turnNumber: null == turnNumber ? _self.turnNumber : turnNumber // ignore: cast_nullable_to_non_nullable
as int,actorId: null == actorId ? _self.actorId : actorId // ignore: cast_nullable_to_non_nullable
as String,payerIds: null == payerIds ? _self._payerIds : payerIds // ignore: cast_nullable_to_non_nullable
as List<String>,ruleConfigId: null == ruleConfigId ? _self.ruleConfigId : ruleConfigId // ignore: cast_nullable_to_non_nullable
as String,ruleVersion: null == ruleVersion ? _self.ruleVersion : ruleVersion // ignore: cast_nullable_to_non_nullable
as int,pottedBalls: null == pottedBalls ? _self._pottedBalls : pottedBalls // ignore: cast_nullable_to_non_nullable
as List<PottedBall>,foulClassification: null == foulClassification ? _self.foulClassification : foulClassification // ignore: cast_nullable_to_non_nullable
as FoulClassification,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<ScoreTransaction>,logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<ScoreLog>,beforeSnapshot: null == beforeSnapshot ? _self.beforeSnapshot : beforeSnapshot // ignore: cast_nullable_to_non_nullable
as TurnStateSnapshot,afterSnapshot: null == afterSnapshot ? _self.afterSnapshot : afterSnapshot // ignore: cast_nullable_to_non_nullable
as TurnStateSnapshot,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,isUndone: null == isUndone ? _self.isUndone : isUndone // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of Turn
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TurnStateSnapshotCopyWith<$Res> get beforeSnapshot {
  
  return $TurnStateSnapshotCopyWith<$Res>(_self.beforeSnapshot, (value) {
    return _then(_self.copyWith(beforeSnapshot: value));
  });
}/// Create a copy of Turn
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TurnStateSnapshotCopyWith<$Res> get afterSnapshot {
  
  return $TurnStateSnapshotCopyWith<$Res>(_self.afterSnapshot, (value) {
    return _then(_self.copyWith(afterSnapshot: value));
  });
}
}

// dart format on
