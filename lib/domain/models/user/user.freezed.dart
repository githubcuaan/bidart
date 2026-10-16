// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$User {

 String get id; String get name; String get phone; String get email; String? get avatarUrl; int get age; String get gender; String get address; SkillLevel get selfDeclaredLevel; int get totalMatches; double get winRate; int get eloRating; DateTime? get createdAt;
/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserCopyWith<User> get copyWith => _$UserCopyWithImpl<User>(this as User, _$identity);

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as User;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is User&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.avatarUrl, _this.avatarUrl) || other.avatarUrl == _this.avatarUrl)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.address, _this.address) || other.address == _this.address)&&(identical(other.selfDeclaredLevel, _this.selfDeclaredLevel) || other.selfDeclaredLevel == _this.selfDeclaredLevel)&&(identical(other.totalMatches, _this.totalMatches) || other.totalMatches == _this.totalMatches)&&(identical(other.winRate, _this.winRate) || other.winRate == _this.winRate)&&(identical(other.eloRating, _this.eloRating) || other.eloRating == _this.eloRating)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as User;
  return Object.hash(runtimeType,_this.id,_this.name,_this.phone,_this.email,_this.avatarUrl,_this.age,_this.gender,_this.address,_this.selfDeclaredLevel,_this.totalMatches,_this.winRate,_this.eloRating,_this.createdAt);
}

@override
String toString() {
  final _this = this as User;
  return 'User(id: ${_this.id}, name: ${_this.name}, phone: ${_this.phone}, email: ${_this.email}, avatarUrl: ${_this.avatarUrl}, age: ${_this.age}, gender: ${_this.gender}, address: ${_this.address}, selfDeclaredLevel: ${_this.selfDeclaredLevel}, totalMatches: ${_this.totalMatches}, winRate: ${_this.winRate}, eloRating: ${_this.eloRating}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $UserCopyWith<$Res>  {
  factory $UserCopyWith(User value, $Res Function(User) _then) = _$UserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String phone, String email, String? avatarUrl, int age, String gender, String address, SkillLevel selfDeclaredLevel, int totalMatches, double winRate, int eloRating, DateTime? createdAt
});




}
/// @nodoc
class _$UserCopyWithImpl<$Res>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._self, this._then);

  final User _self;
  final $Res Function(User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? email = null,Object? avatarUrl = freezed,Object? age = null,Object? gender = null,Object? address = null,Object? selfDeclaredLevel = null,Object? totalMatches = null,Object? winRate = null,Object? eloRating = null,Object? createdAt = freezed,}) {
  return _then(User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,selfDeclaredLevel: null == selfDeclaredLevel ? _self.selfDeclaredLevel : selfDeclaredLevel // ignore: cast_nullable_to_non_nullable
as SkillLevel,totalMatches: null == totalMatches ? _self.totalMatches : totalMatches // ignore: cast_nullable_to_non_nullable
as int,winRate: null == winRate ? _self.winRate : winRate // ignore: cast_nullable_to_non_nullable
as double,eloRating: null == eloRating ? _self.eloRating : eloRating // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [User].
extension UserPatterns on User {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _User value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _User value)  $default,){
final _that = this;
switch (_that) {
case _User():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _User value)?  $default,){
final _that = this;
switch (_that) {
case _User() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String email,  String? avatarUrl,  int age,  String gender,  String address,  SkillLevel selfDeclaredLevel,  int totalMatches,  double winRate,  int eloRating,  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.avatarUrl,_that.age,_that.gender,_that.address,_that.selfDeclaredLevel,_that.totalMatches,_that.winRate,_that.eloRating,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String phone,  String email,  String? avatarUrl,  int age,  String gender,  String address,  SkillLevel selfDeclaredLevel,  int totalMatches,  double winRate,  int eloRating,  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _User():
return $default(_that.id,_that.name,_that.phone,_that.email,_that.avatarUrl,_that.age,_that.gender,_that.address,_that.selfDeclaredLevel,_that.totalMatches,_that.winRate,_that.eloRating,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String phone,  String email,  String? avatarUrl,  int age,  String gender,  String address,  SkillLevel selfDeclaredLevel,  int totalMatches,  double winRate,  int eloRating,  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _User() when $default != null:
return $default(_that.id,_that.name,_that.phone,_that.email,_that.avatarUrl,_that.age,_that.gender,_that.address,_that.selfDeclaredLevel,_that.totalMatches,_that.winRate,_that.eloRating,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _User implements User {
  const _User({required this.id, required this.name, required this.phone, this.email = '', this.avatarUrl, this.age = 25, this.gender = 'Nam', this.address = '', this.selfDeclaredLevel = SkillLevel.kI, this.totalMatches = 0, this.winRate = 0.0, this.eloRating = 1500, this.createdAt});
  factory _User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

@override final  String id;
@override final  String name;
@override final  String phone;
@override@JsonKey() final  String email;
@override final  String? avatarUrl;
@override@JsonKey() final  int age;
@override@JsonKey() final  String gender;
@override@JsonKey() final  String address;
@override@JsonKey() final  SkillLevel selfDeclaredLevel;
@override@JsonKey() final  int totalMatches;
@override@JsonKey() final  double winRate;
@override@JsonKey() final  int eloRating;
@override final  DateTime? createdAt;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserCopyWith<_User> get copyWith => __$UserCopyWithImpl<_User>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _User&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.email, email) || other.email == email)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.address, address) || other.address == address)&&(identical(other.selfDeclaredLevel, selfDeclaredLevel) || other.selfDeclaredLevel == selfDeclaredLevel)&&(identical(other.totalMatches, totalMatches) || other.totalMatches == totalMatches)&&(identical(other.winRate, winRate) || other.winRate == winRate)&&(identical(other.eloRating, eloRating) || other.eloRating == eloRating)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,phone,email,avatarUrl,age,gender,address,selfDeclaredLevel,totalMatches,winRate,eloRating,createdAt);
}

@override
String toString() {
    return 'User(id: $id, name: $name, phone: $phone, email: $email, avatarUrl: $avatarUrl, age: $age, gender: $gender, address: $address, selfDeclaredLevel: $selfDeclaredLevel, totalMatches: $totalMatches, winRate: $winRate, eloRating: $eloRating, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) _then) = __$UserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String phone, String email, String? avatarUrl, int age, String gender, String address, SkillLevel selfDeclaredLevel, int totalMatches, double winRate, int eloRating, DateTime? createdAt
});




}
/// @nodoc
class __$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(this._self, this._then);

  final _User _self;
  final $Res Function(_User) _then;

/// Create a copy of User
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? phone = null,Object? email = null,Object? avatarUrl = freezed,Object? age = null,Object? gender = null,Object? address = null,Object? selfDeclaredLevel = null,Object? totalMatches = null,Object? winRate = null,Object? eloRating = null,Object? createdAt = freezed,}) {
  return _then(_User(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,selfDeclaredLevel: null == selfDeclaredLevel ? _self.selfDeclaredLevel : selfDeclaredLevel // ignore: cast_nullable_to_non_nullable
as SkillLevel,totalMatches: null == totalMatches ? _self.totalMatches : totalMatches // ignore: cast_nullable_to_non_nullable
as int,winRate: null == winRate ? _self.winRate : winRate // ignore: cast_nullable_to_non_nullable
as double,eloRating: null == eloRating ? _self.eloRating : eloRating // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
