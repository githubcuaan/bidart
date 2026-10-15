// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'room_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RoomEvent {

 String get id; String get roomId; String get commandId; int get revision; RoomEventType get type; TurnStateSnapshot get beforeSnapshot; TurnStateSnapshot get afterSnapshot; DateTime get createdAt; RuleConfig? get beforeRules; RuleConfig? get afterRules; bool get isUndoBarrier;
/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomEventCopyWith<RoomEvent> get copyWith => _$RoomEventCopyWithImpl<RoomEvent>(this as RoomEvent, _$identity);

  /// Serializes this RoomEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RoomEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.roomId, _this.roomId) || other.roomId == _this.roomId)&&(identical(other.commandId, _this.commandId) || other.commandId == _this.commandId)&&(identical(other.revision, _this.revision) || other.revision == _this.revision)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.beforeSnapshot, _this.beforeSnapshot) || other.beforeSnapshot == _this.beforeSnapshot)&&(identical(other.afterSnapshot, _this.afterSnapshot) || other.afterSnapshot == _this.afterSnapshot)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.beforeRules, _this.beforeRules) || other.beforeRules == _this.beforeRules)&&(identical(other.afterRules, _this.afterRules) || other.afterRules == _this.afterRules)&&(identical(other.isUndoBarrier, _this.isUndoBarrier) || other.isUndoBarrier == _this.isUndoBarrier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RoomEvent;
  return Object.hash(runtimeType,_this.id,_this.roomId,_this.commandId,_this.revision,_this.type,_this.beforeSnapshot,_this.afterSnapshot,_this.createdAt,_this.beforeRules,_this.afterRules,_this.isUndoBarrier);
}

@override
String toString() {
  final _this = this as RoomEvent;
  return 'RoomEvent(id: ${_this.id}, roomId: ${_this.roomId}, commandId: ${_this.commandId}, revision: ${_this.revision}, type: ${_this.type}, beforeSnapshot: ${_this.beforeSnapshot}, afterSnapshot: ${_this.afterSnapshot}, createdAt: ${_this.createdAt}, beforeRules: ${_this.beforeRules}, afterRules: ${_this.afterRules}, isUndoBarrier: ${_this.isUndoBarrier})';
}


}

/// @nodoc
abstract mixin class $RoomEventCopyWith<$Res>  {
  factory $RoomEventCopyWith(RoomEvent value, $Res Function(RoomEvent) _then) = _$RoomEventCopyWithImpl;
@useResult
$Res call({
 String id, String roomId, String commandId, int revision, RoomEventType type, TurnStateSnapshot beforeSnapshot, TurnStateSnapshot afterSnapshot, DateTime createdAt, RuleConfig? beforeRules, RuleConfig? afterRules, bool isUndoBarrier
});


$TurnStateSnapshotCopyWith<$Res> get beforeSnapshot;$TurnStateSnapshotCopyWith<$Res> get afterSnapshot;$RuleConfigCopyWith<$Res>? get beforeRules;$RuleConfigCopyWith<$Res>? get afterRules;

}
/// @nodoc
class _$RoomEventCopyWithImpl<$Res>
    implements $RoomEventCopyWith<$Res> {
  _$RoomEventCopyWithImpl(this._self, this._then);

  final RoomEvent _self;
  final $Res Function(RoomEvent) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? roomId = null,Object? commandId = null,Object? revision = null,Object? type = null,Object? beforeSnapshot = null,Object? afterSnapshot = null,Object? createdAt = null,Object? beforeRules = freezed,Object? afterRules = freezed,Object? isUndoBarrier = null,}) {
  return _then(RoomEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,commandId: null == commandId ? _self.commandId : commandId // ignore: cast_nullable_to_non_nullable
as String,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RoomEventType,beforeSnapshot: null == beforeSnapshot ? _self.beforeSnapshot : beforeSnapshot // ignore: cast_nullable_to_non_nullable
as TurnStateSnapshot,afterSnapshot: null == afterSnapshot ? _self.afterSnapshot : afterSnapshot // ignore: cast_nullable_to_non_nullable
as TurnStateSnapshot,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,beforeRules: freezed == beforeRules ? _self.beforeRules : beforeRules // ignore: cast_nullable_to_non_nullable
as RuleConfig?,afterRules: freezed == afterRules ? _self.afterRules : afterRules // ignore: cast_nullable_to_non_nullable
as RuleConfig?,isUndoBarrier: null == isUndoBarrier ? _self.isUndoBarrier : isUndoBarrier // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TurnStateSnapshotCopyWith<$Res> get beforeSnapshot {
  
  return $TurnStateSnapshotCopyWith<$Res>(_self.beforeSnapshot, (value) {
    return _then(_self.copyWith(beforeSnapshot: value));
  });
}/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TurnStateSnapshotCopyWith<$Res> get afterSnapshot {
  
  return $TurnStateSnapshotCopyWith<$Res>(_self.afterSnapshot, (value) {
    return _then(_self.copyWith(afterSnapshot: value));
  });
}/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RuleConfigCopyWith<$Res>? get beforeRules {
    if (_self.beforeRules == null) {
    return null;
  }

  return $RuleConfigCopyWith<$Res>(_self.beforeRules!, (value) {
    return _then(_self.copyWith(beforeRules: value));
  });
}/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RuleConfigCopyWith<$Res>? get afterRules {
    if (_self.afterRules == null) {
    return null;
  }

  return $RuleConfigCopyWith<$Res>(_self.afterRules!, (value) {
    return _then(_self.copyWith(afterRules: value));
  });
}
}


/// Adds pattern-matching-related methods to [RoomEvent].
extension RoomEventPatterns on RoomEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomEvent value)  $default,){
final _that = this;
switch (_that) {
case _RoomEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomEvent value)?  $default,){
final _that = this;
switch (_that) {
case _RoomEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String roomId,  String commandId,  int revision,  RoomEventType type,  TurnStateSnapshot beforeSnapshot,  TurnStateSnapshot afterSnapshot,  DateTime createdAt,  RuleConfig? beforeRules,  RuleConfig? afterRules,  bool isUndoBarrier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomEvent() when $default != null:
return $default(_that.id,_that.roomId,_that.commandId,_that.revision,_that.type,_that.beforeSnapshot,_that.afterSnapshot,_that.createdAt,_that.beforeRules,_that.afterRules,_that.isUndoBarrier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String roomId,  String commandId,  int revision,  RoomEventType type,  TurnStateSnapshot beforeSnapshot,  TurnStateSnapshot afterSnapshot,  DateTime createdAt,  RuleConfig? beforeRules,  RuleConfig? afterRules,  bool isUndoBarrier)  $default,) {final _that = this;
switch (_that) {
case _RoomEvent():
return $default(_that.id,_that.roomId,_that.commandId,_that.revision,_that.type,_that.beforeSnapshot,_that.afterSnapshot,_that.createdAt,_that.beforeRules,_that.afterRules,_that.isUndoBarrier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String roomId,  String commandId,  int revision,  RoomEventType type,  TurnStateSnapshot beforeSnapshot,  TurnStateSnapshot afterSnapshot,  DateTime createdAt,  RuleConfig? beforeRules,  RuleConfig? afterRules,  bool isUndoBarrier)?  $default,) {final _that = this;
switch (_that) {
case _RoomEvent() when $default != null:
return $default(_that.id,_that.roomId,_that.commandId,_that.revision,_that.type,_that.beforeSnapshot,_that.afterSnapshot,_that.createdAt,_that.beforeRules,_that.afterRules,_that.isUndoBarrier);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _RoomEvent implements RoomEvent {
  const _RoomEvent({required this.id, required this.roomId, required this.commandId, required this.revision, required this.type, required this.beforeSnapshot, required this.afterSnapshot, required this.createdAt, this.beforeRules, this.afterRules, this.isUndoBarrier = true});
  factory _RoomEvent.fromJson(Map<String, dynamic> json) => _$RoomEventFromJson(json);

@override final  String id;
@override final  String roomId;
@override final  String commandId;
@override final  int revision;
@override final  RoomEventType type;
@override final  TurnStateSnapshot beforeSnapshot;
@override final  TurnStateSnapshot afterSnapshot;
@override final  DateTime createdAt;
@override final  RuleConfig? beforeRules;
@override final  RuleConfig? afterRules;
@override@JsonKey() final  bool isUndoBarrier;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomEventCopyWith<_RoomEvent> get copyWith => __$RoomEventCopyWithImpl<_RoomEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RoomEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.commandId, commandId) || other.commandId == commandId)&&(identical(other.revision, revision) || other.revision == revision)&&(identical(other.type, type) || other.type == type)&&(identical(other.beforeSnapshot, beforeSnapshot) || other.beforeSnapshot == beforeSnapshot)&&(identical(other.afterSnapshot, afterSnapshot) || other.afterSnapshot == afterSnapshot)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.beforeRules, beforeRules) || other.beforeRules == beforeRules)&&(identical(other.afterRules, afterRules) || other.afterRules == afterRules)&&(identical(other.isUndoBarrier, isUndoBarrier) || other.isUndoBarrier == isUndoBarrier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,roomId,commandId,revision,type,beforeSnapshot,afterSnapshot,createdAt,beforeRules,afterRules,isUndoBarrier);
}

@override
String toString() {
    return 'RoomEvent(id: $id, roomId: $roomId, commandId: $commandId, revision: $revision, type: $type, beforeSnapshot: $beforeSnapshot, afterSnapshot: $afterSnapshot, createdAt: $createdAt, beforeRules: $beforeRules, afterRules: $afterRules, isUndoBarrier: $isUndoBarrier)';
}


}

/// @nodoc
abstract mixin class _$RoomEventCopyWith<$Res> implements $RoomEventCopyWith<$Res> {
  factory _$RoomEventCopyWith(_RoomEvent value, $Res Function(_RoomEvent) _then) = __$RoomEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String roomId, String commandId, int revision, RoomEventType type, TurnStateSnapshot beforeSnapshot, TurnStateSnapshot afterSnapshot, DateTime createdAt, RuleConfig? beforeRules, RuleConfig? afterRules, bool isUndoBarrier
});


@override $TurnStateSnapshotCopyWith<$Res> get beforeSnapshot;@override $TurnStateSnapshotCopyWith<$Res> get afterSnapshot;@override $RuleConfigCopyWith<$Res>? get beforeRules;@override $RuleConfigCopyWith<$Res>? get afterRules;

}
/// @nodoc
class __$RoomEventCopyWithImpl<$Res>
    implements _$RoomEventCopyWith<$Res> {
  __$RoomEventCopyWithImpl(this._self, this._then);

  final _RoomEvent _self;
  final $Res Function(_RoomEvent) _then;

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? roomId = null,Object? commandId = null,Object? revision = null,Object? type = null,Object? beforeSnapshot = null,Object? afterSnapshot = null,Object? createdAt = null,Object? beforeRules = freezed,Object? afterRules = freezed,Object? isUndoBarrier = null,}) {
  return _then(_RoomEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,roomId: null == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String,commandId: null == commandId ? _self.commandId : commandId // ignore: cast_nullable_to_non_nullable
as String,revision: null == revision ? _self.revision : revision // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as RoomEventType,beforeSnapshot: null == beforeSnapshot ? _self.beforeSnapshot : beforeSnapshot // ignore: cast_nullable_to_non_nullable
as TurnStateSnapshot,afterSnapshot: null == afterSnapshot ? _self.afterSnapshot : afterSnapshot // ignore: cast_nullable_to_non_nullable
as TurnStateSnapshot,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,beforeRules: freezed == beforeRules ? _self.beforeRules : beforeRules // ignore: cast_nullable_to_non_nullable
as RuleConfig?,afterRules: freezed == afterRules ? _self.afterRules : afterRules // ignore: cast_nullable_to_non_nullable
as RuleConfig?,isUndoBarrier: null == isUndoBarrier ? _self.isUndoBarrier : isUndoBarrier // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TurnStateSnapshotCopyWith<$Res> get beforeSnapshot {
  
  return $TurnStateSnapshotCopyWith<$Res>(_self.beforeSnapshot, (value) {
    return _then(_self.copyWith(beforeSnapshot: value));
  });
}/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TurnStateSnapshotCopyWith<$Res> get afterSnapshot {
  
  return $TurnStateSnapshotCopyWith<$Res>(_self.afterSnapshot, (value) {
    return _then(_self.copyWith(afterSnapshot: value));
  });
}/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RuleConfigCopyWith<$Res>? get beforeRules {
    if (_self.beforeRules == null) {
    return null;
  }

  return $RuleConfigCopyWith<$Res>(_self.beforeRules!, (value) {
    return _then(_self.copyWith(beforeRules: value));
  });
}/// Create a copy of RoomEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RuleConfigCopyWith<$Res>? get afterRules {
    if (_self.afterRules == null) {
    return null;
  }

  return $RuleConfigCopyWith<$Res>(_self.afterRules!, (value) {
    return _then(_self.copyWith(afterRules: value));
  });
}
}

// dart format on
