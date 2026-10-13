// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'score_transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScoreTransaction {

 String get id; String get gameId; String get turnId; String get fromPlayerId; String get toPlayerId; int get amount; TransactionType get type; String? get transactionGroupId;
/// Create a copy of ScoreTransaction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScoreTransactionCopyWith<ScoreTransaction> get copyWith => _$ScoreTransactionCopyWithImpl<ScoreTransaction>(this as ScoreTransaction, _$identity);

  /// Serializes this ScoreTransaction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ScoreTransaction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScoreTransaction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.gameId, _this.gameId) || other.gameId == _this.gameId)&&(identical(other.turnId, _this.turnId) || other.turnId == _this.turnId)&&(identical(other.fromPlayerId, _this.fromPlayerId) || other.fromPlayerId == _this.fromPlayerId)&&(identical(other.toPlayerId, _this.toPlayerId) || other.toPlayerId == _this.toPlayerId)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.transactionGroupId, _this.transactionGroupId) || other.transactionGroupId == _this.transactionGroupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ScoreTransaction;
  return Object.hash(runtimeType,_this.id,_this.gameId,_this.turnId,_this.fromPlayerId,_this.toPlayerId,_this.amount,_this.type,_this.transactionGroupId);
}

@override
String toString() {
  final _this = this as ScoreTransaction;
  return 'ScoreTransaction(id: ${_this.id}, gameId: ${_this.gameId}, turnId: ${_this.turnId}, fromPlayerId: ${_this.fromPlayerId}, toPlayerId: ${_this.toPlayerId}, amount: ${_this.amount}, type: ${_this.type}, transactionGroupId: ${_this.transactionGroupId})';
}


}

/// @nodoc
abstract mixin class $ScoreTransactionCopyWith<$Res>  {
  factory $ScoreTransactionCopyWith(ScoreTransaction value, $Res Function(ScoreTransaction) _then) = _$ScoreTransactionCopyWithImpl;
@useResult
$Res call({
 String id, String gameId, String turnId, String fromPlayerId, String toPlayerId, int amount, TransactionType type, String? transactionGroupId
});




}
/// @nodoc
class _$ScoreTransactionCopyWithImpl<$Res>
    implements $ScoreTransactionCopyWith<$Res> {
  _$ScoreTransactionCopyWithImpl(this._self, this._then);

  final ScoreTransaction _self;
  final $Res Function(ScoreTransaction) _then;

/// Create a copy of ScoreTransaction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? gameId = null,Object? turnId = null,Object? fromPlayerId = null,Object? toPlayerId = null,Object? amount = null,Object? type = null,Object? transactionGroupId = freezed,}) {
  return _then(ScoreTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,turnId: null == turnId ? _self.turnId : turnId // ignore: cast_nullable_to_non_nullable
as String,fromPlayerId: null == fromPlayerId ? _self.fromPlayerId : fromPlayerId // ignore: cast_nullable_to_non_nullable
as String,toPlayerId: null == toPlayerId ? _self.toPlayerId : toPlayerId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,transactionGroupId: freezed == transactionGroupId ? _self.transactionGroupId : transactionGroupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScoreTransaction].
extension ScoreTransactionPatterns on ScoreTransaction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScoreTransaction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScoreTransaction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScoreTransaction value)  $default,){
final _that = this;
switch (_that) {
case _ScoreTransaction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScoreTransaction value)?  $default,){
final _that = this;
switch (_that) {
case _ScoreTransaction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String gameId,  String turnId,  String fromPlayerId,  String toPlayerId,  int amount,  TransactionType type,  String? transactionGroupId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScoreTransaction() when $default != null:
return $default(_that.id,_that.gameId,_that.turnId,_that.fromPlayerId,_that.toPlayerId,_that.amount,_that.type,_that.transactionGroupId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String gameId,  String turnId,  String fromPlayerId,  String toPlayerId,  int amount,  TransactionType type,  String? transactionGroupId)  $default,) {final _that = this;
switch (_that) {
case _ScoreTransaction():
return $default(_that.id,_that.gameId,_that.turnId,_that.fromPlayerId,_that.toPlayerId,_that.amount,_that.type,_that.transactionGroupId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String gameId,  String turnId,  String fromPlayerId,  String toPlayerId,  int amount,  TransactionType type,  String? transactionGroupId)?  $default,) {final _that = this;
switch (_that) {
case _ScoreTransaction() when $default != null:
return $default(_that.id,_that.gameId,_that.turnId,_that.fromPlayerId,_that.toPlayerId,_that.amount,_that.type,_that.transactionGroupId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScoreTransaction implements ScoreTransaction {
  const _ScoreTransaction({required this.id, required this.gameId, required this.turnId, required this.fromPlayerId, required this.toPlayerId, required this.amount, required this.type, this.transactionGroupId}): assert(fromPlayerId != toPlayerId, 'transaction needs distinct parties'),assert(amount > 0, 'amount must be positive');
  factory _ScoreTransaction.fromJson(Map<String, dynamic> json) => _$ScoreTransactionFromJson(json);

@override final  String id;
@override final  String gameId;
@override final  String turnId;
@override final  String fromPlayerId;
@override final  String toPlayerId;
@override final  int amount;
@override final  TransactionType type;
@override final  String? transactionGroupId;

/// Create a copy of ScoreTransaction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScoreTransactionCopyWith<_ScoreTransaction> get copyWith => __$ScoreTransactionCopyWithImpl<_ScoreTransaction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScoreTransactionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScoreTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.gameId, gameId) || other.gameId == gameId)&&(identical(other.turnId, turnId) || other.turnId == turnId)&&(identical(other.fromPlayerId, fromPlayerId) || other.fromPlayerId == fromPlayerId)&&(identical(other.toPlayerId, toPlayerId) || other.toPlayerId == toPlayerId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.type, type) || other.type == type)&&(identical(other.transactionGroupId, transactionGroupId) || other.transactionGroupId == transactionGroupId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,gameId,turnId,fromPlayerId,toPlayerId,amount,type,transactionGroupId);
}

@override
String toString() {
    return 'ScoreTransaction(id: $id, gameId: $gameId, turnId: $turnId, fromPlayerId: $fromPlayerId, toPlayerId: $toPlayerId, amount: $amount, type: $type, transactionGroupId: $transactionGroupId)';
}


}

/// @nodoc
abstract mixin class _$ScoreTransactionCopyWith<$Res> implements $ScoreTransactionCopyWith<$Res> {
  factory _$ScoreTransactionCopyWith(_ScoreTransaction value, $Res Function(_ScoreTransaction) _then) = __$ScoreTransactionCopyWithImpl;
@override @useResult
$Res call({
 String id, String gameId, String turnId, String fromPlayerId, String toPlayerId, int amount, TransactionType type, String? transactionGroupId
});




}
/// @nodoc
class __$ScoreTransactionCopyWithImpl<$Res>
    implements _$ScoreTransactionCopyWith<$Res> {
  __$ScoreTransactionCopyWithImpl(this._self, this._then);

  final _ScoreTransaction _self;
  final $Res Function(_ScoreTransaction) _then;

/// Create a copy of ScoreTransaction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? gameId = null,Object? turnId = null,Object? fromPlayerId = null,Object? toPlayerId = null,Object? amount = null,Object? type = null,Object? transactionGroupId = freezed,}) {
  return _then(_ScoreTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,gameId: null == gameId ? _self.gameId : gameId // ignore: cast_nullable_to_non_nullable
as String,turnId: null == turnId ? _self.turnId : turnId // ignore: cast_nullable_to_non_nullable
as String,fromPlayerId: null == fromPlayerId ? _self.fromPlayerId : fromPlayerId // ignore: cast_nullable_to_non_nullable
as String,toPlayerId: null == toPlayerId ? _self.toPlayerId : toPlayerId // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as TransactionType,transactionGroupId: freezed == transactionGroupId ? _self.transactionGroupId : transactionGroupId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
