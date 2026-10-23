// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Room {

 String get id; String get name; String get description; String get ownerId; RoomMode get mode; RoomStatus get status; DateTime get createdAt; DateTime? get endedAt; int get revision; List<PlayerInGame> get participants; List<String> get activePlayerIds; List<String> get playerOrder; Map<String, int> get scores; List<RuleConfig> get ruleVersions; int get currentRuleVersion; List<GameSession> get games; String? get currentGameId; EndConditions get endConditions; Set<PendingEndReason> get pendingEndReasons; List<RoomEvent> get events;
/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomCopyWith<Room> get copyWith => _$RoomCopyWithImpl<Room>(this as Room, _$identity);

  /// Serializes this Room to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Room;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Room&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.ownerId, _this.ownerId) || other.ownerId == _this.ownerId)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.endedAt, _this.endedAt) || other.endedAt == _this.endedAt)&&(identical(other.revision, _this.revision) || other.revision == _this.revision)&&const DeepCollectionEquality().equals(other.participants, _this.participants)&&const DeepCollectionEquality().equals(other.activePlayerIds, _this.activePlayerIds)&&const DeepCollectionEquality().equals(other.playerOrder, _this.playerOrder)&&const DeepCollectionEquality().equals(other.scores, _this.scores)&&const DeepCollectionEquality().equals(other.ruleVersions, _this.ruleVersions)&&(identical(other.currentRuleVersion, _this.currentRuleVersion) || other.currentRuleVersion == _this.currentRuleVersion)&&const DeepCollectionEquality().equals(other.games, _this.games)&&(identical(other.currentGameId, _this.currentGameId) || other.currentGameId == _this.currentGameId)&&(identical(other.endConditions, _this.endConditions) || other.endConditions == _this.endConditions)&&const DeepCollectionEquality().equals(other.pendingEndReasons, _this.pendingEndReasons)&&const DeepCollectionEquality().equals(other.events, _this.events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Room;
  return Object.hashAll([runtimeType,_this.id,_this.name,_this.description,_this.ownerId,_this.mode,_this.status,_this.createdAt,_this.endedAt,_this.revision,const DeepCollectionEquality().hash(_this.participants),const DeepCollectionEquality().hash(_this.activePlayerIds),const DeepCollectionEquality().hash(_this.playerOrder),const DeepCollectionEquality().hash(_this.scores),const DeepCollectionEquality().hash(_this.ruleVersions),_this.currentRuleVersion,const DeepCollectionEquality().hash(_this.games),_this.currentGameId,_this.endConditions,const DeepCollectionEquality().hash(_this.pendingEndReasons),const DeepCollectionEquality().hash(_this.events)]);
}

@override
String toString() {
  final _this = this as Room;
  return 'Room(id: ${_this.id}, name: ${_this.name}, description: ${_this.description}, ownerId: ${_this.ownerId}, mode: ${_this.mode}, status: ${_this.status}, createdAt: ${_this.createdAt}, endedAt: ${_this.endedAt}, revision: ${_this.revision}, participants: ${_this.participants}, activePlayerIds: ${_this.activePlayerIds}, playerOrder: ${_this.playerOrder}, scores: ${_this.scores}, ruleVersions: ${_this.ruleVersions}, currentRuleVersion: ${_this.currentRuleVersion}, games: ${_this.games}, currentGameId: ${_this.currentGameId}, endConditions: ${_this.endConditions}, pendingEndReasons: ${_this.pendingEndReasons}, events: ${_this.events})';
}


}

/// @nodoc
abstract mixin class $RoomCopyWith<$Res>  {
  factory $RoomCopyWith(Room value, $Res Function(Room) _then) = _$RoomCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String ownerId, RoomMode mode, RoomStatus status, DateTime createdAt, DateTime? endedAt, int revision, List<PlayerInGame> participants, List<String> activePlayerIds, List<String> playerOrder, Map<String, int> scores, List<RuleConfig> ruleVersions, int currentRuleVersion, List<GameSession> games, String? currentGameId, EndConditions endConditions, Set<PendingEndReason> pendingEndReasons, List<RoomEvent> events
});


$EndConditionsCopyWith<$Res> get endConditions;

}
/// @nodoc
class _$RoomCopyWithImpl<$Res>
    implements $RoomCopyWith<$Res> {
  _$RoomCopyWithImpl(this._self, this._then);

  final Room _self;
  final $Res Function(Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? ownerId = null,Object? mode = null,Object? status = null,Object? createdAt = null,Object? endedAt = freezed,Object? revision = null,Object? participants = null,Object? activePlayerIds = null,Object? playerOrder = null,Object? scores = null,Object? ruleVersions = null,Object? currentRuleVersion = null,Object? games = null,Object? currentGameId = freezed,Object? endConditions = null,Object? pendingEndReasons = null,Object? events = null,}) {
  return _then(Room(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as RoomMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<PlayerInGame>,activePlayerIds: null == activePlayerIds ? _self.activePlayerIds : activePlayerIds // ignore: cast_nullable_to_non_nullable
as List<String>,playerOrder: null == playerOrder ? _self.playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,scores: null == scores ? _self.scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, int>,ruleVersions: null == ruleVersions ? _self.ruleVersions : ruleVersions // ignore: cast_nullable_to_non_nullable
as List<RuleConfig>,currentRuleVersion: null == currentRuleVersion ? _self.currentRuleVersion : currentRuleVersion // ignore: cast_nullable_to_non_nullable
as int,games: null == games ? _self.games : games // ignore: cast_nullable_to_non_nullable
as List<GameSession>,currentGameId: freezed == currentGameId ? _self.currentGameId : currentGameId // ignore: cast_nullable_to_non_nullable
as String?,endConditions: null == endConditions ? _self.endConditions : endConditions // ignore: cast_nullable_to_non_nullable
as EndConditions,pendingEndReasons: null == pendingEndReasons ? _self.pendingEndReasons : pendingEndReasons // ignore: cast_nullable_to_non_nullable
as Set<PendingEndReason>,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<RoomEvent>,
  ));
}
/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EndConditionsCopyWith<$Res> get endConditions {
  
  return $EndConditionsCopyWith<$Res>(_self.endConditions, (value) {
    return _then(_self.copyWith(endConditions: value));
  });
}
}


/// Adds pattern-matching-related methods to [Room].
extension RoomPatterns on Room {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Room value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Room() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Room value)  $default,){
final _that = this;
switch (_that) {
case _Room():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Room value)?  $default,){
final _that = this;
switch (_that) {
case _Room() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String ownerId,  RoomMode mode,  RoomStatus status,  DateTime createdAt,  DateTime? endedAt,  int revision,  List<PlayerInGame> participants,  List<String> activePlayerIds,  List<String> playerOrder,  Map<String, int> scores,  List<RuleConfig> ruleVersions,  int currentRuleVersion,  List<GameSession> games,  String? currentGameId,  EndConditions endConditions,  Set<PendingEndReason> pendingEndReasons,  List<RoomEvent> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.ownerId,_that.mode,_that.status,_that.createdAt,_that.endedAt,_that.revision,_that.participants,_that.activePlayerIds,_that.playerOrder,_that.scores,_that.ruleVersions,_that.currentRuleVersion,_that.games,_that.currentGameId,_that.endConditions,_that.pendingEndReasons,_that.events);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String ownerId,  RoomMode mode,  RoomStatus status,  DateTime createdAt,  DateTime? endedAt,  int revision,  List<PlayerInGame> participants,  List<String> activePlayerIds,  List<String> playerOrder,  Map<String, int> scores,  List<RuleConfig> ruleVersions,  int currentRuleVersion,  List<GameSession> games,  String? currentGameId,  EndConditions endConditions,  Set<PendingEndReason> pendingEndReasons,  List<RoomEvent> events)  $default,) {final _that = this;
switch (_that) {
case _Room():
return $default(_that.id,_that.name,_that.description,_that.ownerId,_that.mode,_that.status,_that.createdAt,_that.endedAt,_that.revision,_that.participants,_that.activePlayerIds,_that.playerOrder,_that.scores,_that.ruleVersions,_that.currentRuleVersion,_that.games,_that.currentGameId,_that.endConditions,_that.pendingEndReasons,_that.events);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String ownerId,  RoomMode mode,  RoomStatus status,  DateTime createdAt,  DateTime? endedAt,  int revision,  List<PlayerInGame> participants,  List<String> activePlayerIds,  List<String> playerOrder,  Map<String, int> scores,  List<RuleConfig> ruleVersions,  int currentRuleVersion,  List<GameSession> games,  String? currentGameId,  EndConditions endConditions,  Set<PendingEndReason> pendingEndReasons,  List<RoomEvent> events)?  $default,) {final _that = this;
switch (_that) {
case _Room() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.ownerId,_that.mode,_that.status,_that.createdAt,_that.endedAt,_that.revision,_that.participants,_that.activePlayerIds,_that.playerOrder,_that.scores,_that.ruleVersions,_that.currentRuleVersion,_that.games,_that.currentGameId,_that.endConditions,_that.pendingEndReasons,_that.events);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _Room implements Room {
  const _Room({required this.id, required this.name, this.description = '', required this.ownerId, required this.mode, required this.status, required this.createdAt, this.endedAt, required this.revision, required  List<PlayerInGame> participants, required  List<String> activePlayerIds, required  List<String> playerOrder, required  Map<String, int> scores, required  List<RuleConfig> ruleVersions, required this.currentRuleVersion, required  List<GameSession> games, this.currentGameId, required this.endConditions, required  Set<PendingEndReason> pendingEndReasons,  List<RoomEvent> events = const []}): _participants = participants,_activePlayerIds = activePlayerIds,_playerOrder = playerOrder,_scores = scores,_ruleVersions = ruleVersions,_games = games,_pendingEndReasons = pendingEndReasons,_events = events;
  factory _Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);

@override final  String id;
@override final  String name;
@override@JsonKey() final  String description;
@override final  String ownerId;
@override final  RoomMode mode;
@override final  RoomStatus status;
@override final  DateTime createdAt;
@override final  DateTime? endedAt;
@override final  int revision;
 final  List<PlayerInGame> _participants;
@override List<PlayerInGame> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
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

 final  Map<String, int> _scores;
@override Map<String, int> get scores {
  if (_scores is EqualUnmodifiableMapView) return _scores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_scores);
}

 final  List<RuleConfig> _ruleVersions;
@override List<RuleConfig> get ruleVersions {
  if (_ruleVersions is EqualUnmodifiableListView) return _ruleVersions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_ruleVersions);
}

@override final  int currentRuleVersion;
 final  List<GameSession> _games;
@override List<GameSession> get games {
  if (_games is EqualUnmodifiableListView) return _games;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_games);
}

@override final  String? currentGameId;
@override final  EndConditions endConditions;
 final  Set<PendingEndReason> _pendingEndReasons;
@override Set<PendingEndReason> get pendingEndReasons {
  if (_pendingEndReasons is EqualUnmodifiableSetView) return _pendingEndReasons;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingEndReasons);
}

 final  List<RoomEvent> _events;
@override@JsonKey() List<RoomEvent> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomCopyWith<_Room> get copyWith => __$RoomCopyWithImpl<_Room>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Room&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.revision, revision) || other.revision == revision)&&const DeepCollectionEquality().equals(other.participants, _participants)&&const DeepCollectionEquality().equals(other.activePlayerIds, _activePlayerIds)&&const DeepCollectionEquality().equals(other.playerOrder, _playerOrder)&&const DeepCollectionEquality().equals(other.scores, _scores)&&const DeepCollectionEquality().equals(other.ruleVersions, _ruleVersions)&&(identical(other.currentRuleVersion, currentRuleVersion) || other.currentRuleVersion == currentRuleVersion)&&const DeepCollectionEquality().equals(other.games, _games)&&(identical(other.currentGameId, currentGameId) || other.currentGameId == currentGameId)&&(identical(other.endConditions, endConditions) || other.endConditions == endConditions)&&const DeepCollectionEquality().equals(other.pendingEndReasons, _pendingEndReasons)&&const DeepCollectionEquality().equals(other.events, _events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,name,description,ownerId,mode,status,createdAt,endedAt,revision,const DeepCollectionEquality().hash(_participants),const DeepCollectionEquality().hash(_activePlayerIds),const DeepCollectionEquality().hash(_playerOrder),const DeepCollectionEquality().hash(_scores),const DeepCollectionEquality().hash(_ruleVersions),currentRuleVersion,const DeepCollectionEquality().hash(_games),currentGameId,endConditions,const DeepCollectionEquality().hash(_pendingEndReasons),const DeepCollectionEquality().hash(_events)]);
}

@override
String toString() {
    return 'Room(id: $id, name: $name, description: $description, ownerId: $ownerId, mode: $mode, status: $status, createdAt: $createdAt, endedAt: $endedAt, revision: $revision, participants: $participants, activePlayerIds: $activePlayerIds, playerOrder: $playerOrder, scores: $scores, ruleVersions: $ruleVersions, currentRuleVersion: $currentRuleVersion, games: $games, currentGameId: $currentGameId, endConditions: $endConditions, pendingEndReasons: $pendingEndReasons, events: $events)';
}


}

/// @nodoc
abstract mixin class _$RoomCopyWith<$Res> implements $RoomCopyWith<$Res> {
  factory _$RoomCopyWith(_Room value, $Res Function(_Room) _then) = __$RoomCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String ownerId, RoomMode mode, RoomStatus status, DateTime createdAt, DateTime? endedAt, int revision, List<PlayerInGame> participants, List<String> activePlayerIds, List<String> playerOrder, Map<String, int> scores, List<RuleConfig> ruleVersions, int currentRuleVersion, List<GameSession> games, String? currentGameId, EndConditions endConditions, Set<PendingEndReason> pendingEndReasons, List<RoomEvent> events
});


@override $EndConditionsCopyWith<$Res> get endConditions;

}
/// @nodoc
class __$RoomCopyWithImpl<$Res>
    implements _$RoomCopyWith<$Res> {
  __$RoomCopyWithImpl(this._self, this._then);

  final _Room _self;
  final $Res Function(_Room) _then;

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? ownerId = null,Object? mode = null,Object? status = null,Object? createdAt = null,Object? endedAt = freezed,Object? revision = null,Object? participants = null,Object? activePlayerIds = null,Object? playerOrder = null,Object? scores = null,Object? ruleVersions = null,Object? currentRuleVersion = null,Object? games = null,Object? currentGameId = freezed,Object? endConditions = null,Object? pendingEndReasons = null,Object? events = null,}) {
  return _then(_Room(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as RoomMode,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RoomStatus,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<PlayerInGame>,activePlayerIds: null == activePlayerIds ? _self._activePlayerIds : activePlayerIds // ignore: cast_nullable_to_non_nullable
as List<String>,playerOrder: null == playerOrder ? _self._playerOrder : playerOrder // ignore: cast_nullable_to_non_nullable
as List<String>,scores: null == scores ? _self._scores : scores // ignore: cast_nullable_to_non_nullable
as Map<String, int>,ruleVersions: null == ruleVersions ? _self._ruleVersions : ruleVersions // ignore: cast_nullable_to_non_nullable
as List<RuleConfig>,currentRuleVersion: null == currentRuleVersion ? _self.currentRuleVersion : currentRuleVersion // ignore: cast_nullable_to_non_nullable
as int,games: null == games ? _self._games : games // ignore: cast_nullable_to_non_nullable
as List<GameSession>,currentGameId: freezed == currentGameId ? _self.currentGameId : currentGameId // ignore: cast_nullable_to_non_nullable
as String?,endConditions: null == endConditions ? _self.endConditions : endConditions // ignore: cast_nullable_to_non_nullable
as EndConditions,pendingEndReasons: null == pendingEndReasons ? _self._pendingEndReasons : pendingEndReasons // ignore: cast_nullable_to_non_nullable
as Set<PendingEndReason>,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<RoomEvent>,
  ));
}

/// Create a copy of Room
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$EndConditionsCopyWith<$Res> get endConditions {
  
  return $EndConditionsCopyWith<$Res>(_self.endConditions, (value) {
    return _then(_self.copyWith(endConditions: value));
  });
}
}

// dart format on
