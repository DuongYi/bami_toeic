// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'plan_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MyPlan {

 bool get isPro; bool get isAdmin; DateTime? get proUntil;
/// Create a copy of MyPlan
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MyPlanCopyWith<MyPlan> get copyWith => _$MyPlanCopyWithImpl<MyPlan>(this as MyPlan, _$identity);

  /// Serializes this MyPlan to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MyPlan;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MyPlan&&(identical(other.isPro, _this.isPro) || other.isPro == _this.isPro)&&(identical(other.isAdmin, _this.isAdmin) || other.isAdmin == _this.isAdmin)&&(identical(other.proUntil, _this.proUntil) || other.proUntil == _this.proUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MyPlan;
  return Object.hash(runtimeType,_this.isPro,_this.isAdmin,_this.proUntil);
}

@override
String toString() {
  final _this = this as MyPlan;
  return 'MyPlan(isPro: ${_this.isPro}, isAdmin: ${_this.isAdmin}, proUntil: ${_this.proUntil})';
}


}

/// @nodoc
abstract mixin class $MyPlanCopyWith<$Res>  {
  factory $MyPlanCopyWith(MyPlan value, $Res Function(MyPlan) _then) = _$MyPlanCopyWithImpl;
@useResult
$Res call({
 bool isPro, bool isAdmin, DateTime? proUntil
});




}
/// @nodoc
class _$MyPlanCopyWithImpl<$Res>
    implements $MyPlanCopyWith<$Res> {
  _$MyPlanCopyWithImpl(this._self, this._then);

  final MyPlan _self;
  final $Res Function(MyPlan) _then;

/// Create a copy of MyPlan
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isPro = null,Object? isAdmin = null,Object? proUntil = freezed,}) {
  return _then(MyPlan(
isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,proUntil: freezed == proUntil ? _self.proUntil : proUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [MyPlan].
extension MyPlanPatterns on MyPlan {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MyPlan value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MyPlan() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MyPlan value)  $default,){
final _that = this;
switch (_that) {
case _MyPlan():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MyPlan value)?  $default,){
final _that = this;
switch (_that) {
case _MyPlan() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isPro,  bool isAdmin,  DateTime? proUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MyPlan() when $default != null:
return $default(_that.isPro,_that.isAdmin,_that.proUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isPro,  bool isAdmin,  DateTime? proUntil)  $default,) {final _that = this;
switch (_that) {
case _MyPlan():
return $default(_that.isPro,_that.isAdmin,_that.proUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isPro,  bool isAdmin,  DateTime? proUntil)?  $default,) {final _that = this;
switch (_that) {
case _MyPlan() when $default != null:
return $default(_that.isPro,_that.isAdmin,_that.proUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MyPlan implements MyPlan {
  const _MyPlan({this.isPro = false, this.isAdmin = false, this.proUntil});
  factory _MyPlan.fromJson(Map<String, dynamic> json) => _$MyPlanFromJson(json);

@override@JsonKey() final  bool isPro;
@override@JsonKey() final  bool isAdmin;
@override final  DateTime? proUntil;

/// Create a copy of MyPlan
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MyPlanCopyWith<_MyPlan> get copyWith => __$MyPlanCopyWithImpl<_MyPlan>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MyPlanToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MyPlan&&(identical(other.isPro, isPro) || other.isPro == isPro)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.proUntil, proUntil) || other.proUntil == proUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,isPro,isAdmin,proUntil);
}

@override
String toString() {
    return 'MyPlan(isPro: $isPro, isAdmin: $isAdmin, proUntil: $proUntil)';
}


}

/// @nodoc
abstract mixin class _$MyPlanCopyWith<$Res> implements $MyPlanCopyWith<$Res> {
  factory _$MyPlanCopyWith(_MyPlan value, $Res Function(_MyPlan) _then) = __$MyPlanCopyWithImpl;
@override @useResult
$Res call({
 bool isPro, bool isAdmin, DateTime? proUntil
});




}
/// @nodoc
class __$MyPlanCopyWithImpl<$Res>
    implements _$MyPlanCopyWith<$Res> {
  __$MyPlanCopyWithImpl(this._self, this._then);

  final _MyPlan _self;
  final $Res Function(_MyPlan) _then;

/// Create a copy of MyPlan
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isPro = null,Object? isAdmin = null,Object? proUntil = freezed,}) {
  return _then(_MyPlan(
isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,proUntil: freezed == proUntil ? _self.proUntil : proUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AdminUser {

 String get userId; String? get email; DateTime get createdAt; DateTime? get lastSignInAt; bool get isAdmin; DateTime? get proUntil;
/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminUserCopyWith<AdminUser> get copyWith => _$AdminUserCopyWithImpl<AdminUser>(this as AdminUser, _$identity);

  /// Serializes this AdminUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdminUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminUser&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.lastSignInAt, _this.lastSignInAt) || other.lastSignInAt == _this.lastSignInAt)&&(identical(other.isAdmin, _this.isAdmin) || other.isAdmin == _this.isAdmin)&&(identical(other.proUntil, _this.proUntil) || other.proUntil == _this.proUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdminUser;
  return Object.hash(runtimeType,_this.userId,_this.email,_this.createdAt,_this.lastSignInAt,_this.isAdmin,_this.proUntil);
}

@override
String toString() {
  final _this = this as AdminUser;
  return 'AdminUser(userId: ${_this.userId}, email: ${_this.email}, createdAt: ${_this.createdAt}, lastSignInAt: ${_this.lastSignInAt}, isAdmin: ${_this.isAdmin}, proUntil: ${_this.proUntil})';
}


}

/// @nodoc
abstract mixin class $AdminUserCopyWith<$Res>  {
  factory $AdminUserCopyWith(AdminUser value, $Res Function(AdminUser) _then) = _$AdminUserCopyWithImpl;
@useResult
$Res call({
 String userId, String? email, DateTime createdAt, DateTime? lastSignInAt, bool isAdmin, DateTime? proUntil
});




}
/// @nodoc
class _$AdminUserCopyWithImpl<$Res>
    implements $AdminUserCopyWith<$Res> {
  _$AdminUserCopyWithImpl(this._self, this._then);

  final AdminUser _self;
  final $Res Function(AdminUser) _then;

/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? email = freezed,Object? createdAt = null,Object? lastSignInAt = freezed,Object? isAdmin = null,Object? proUntil = freezed,}) {
  return _then(AdminUser(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSignInAt: freezed == lastSignInAt ? _self.lastSignInAt : lastSignInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,proUntil: freezed == proUntil ? _self.proUntil : proUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminUser].
extension AdminUserPatterns on AdminUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminUser value)  $default,){
final _that = this;
switch (_that) {
case _AdminUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminUser value)?  $default,){
final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId,  String? email,  DateTime createdAt,  DateTime? lastSignInAt,  bool isAdmin,  DateTime? proUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
return $default(_that.userId,_that.email,_that.createdAt,_that.lastSignInAt,_that.isAdmin,_that.proUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId,  String? email,  DateTime createdAt,  DateTime? lastSignInAt,  bool isAdmin,  DateTime? proUntil)  $default,) {final _that = this;
switch (_that) {
case _AdminUser():
return $default(_that.userId,_that.email,_that.createdAt,_that.lastSignInAt,_that.isAdmin,_that.proUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId,  String? email,  DateTime createdAt,  DateTime? lastSignInAt,  bool isAdmin,  DateTime? proUntil)?  $default,) {final _that = this;
switch (_that) {
case _AdminUser() when $default != null:
return $default(_that.userId,_that.email,_that.createdAt,_that.lastSignInAt,_that.isAdmin,_that.proUntil);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminUser extends AdminUser {
  const _AdminUser({required this.userId, this.email, required this.createdAt, this.lastSignInAt, this.isAdmin = false, this.proUntil}): super._();
  factory _AdminUser.fromJson(Map<String, dynamic> json) => _$AdminUserFromJson(json);

@override final  String userId;
@override final  String? email;
@override final  DateTime createdAt;
@override final  DateTime? lastSignInAt;
@override@JsonKey() final  bool isAdmin;
@override final  DateTime? proUntil;

/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminUserCopyWith<_AdminUser> get copyWith => __$AdminUserCopyWithImpl<_AdminUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminUser&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.email, email) || other.email == email)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.lastSignInAt, lastSignInAt) || other.lastSignInAt == lastSignInAt)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&(identical(other.proUntil, proUntil) || other.proUntil == proUntil));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,userId,email,createdAt,lastSignInAt,isAdmin,proUntil);
}

@override
String toString() {
    return 'AdminUser(userId: $userId, email: $email, createdAt: $createdAt, lastSignInAt: $lastSignInAt, isAdmin: $isAdmin, proUntil: $proUntil)';
}


}

/// @nodoc
abstract mixin class _$AdminUserCopyWith<$Res> implements $AdminUserCopyWith<$Res> {
  factory _$AdminUserCopyWith(_AdminUser value, $Res Function(_AdminUser) _then) = __$AdminUserCopyWithImpl;
@override @useResult
$Res call({
 String userId, String? email, DateTime createdAt, DateTime? lastSignInAt, bool isAdmin, DateTime? proUntil
});




}
/// @nodoc
class __$AdminUserCopyWithImpl<$Res>
    implements _$AdminUserCopyWith<$Res> {
  __$AdminUserCopyWithImpl(this._self, this._then);

  final _AdminUser _self;
  final $Res Function(_AdminUser) _then;

/// Create a copy of AdminUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? email = freezed,Object? createdAt = null,Object? lastSignInAt = freezed,Object? isAdmin = null,Object? proUntil = freezed,}) {
  return _then(_AdminUser(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastSignInAt: freezed == lastSignInAt ? _self.lastSignInAt : lastSignInAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isAdmin: null == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool,proUntil: freezed == proUntil ? _self.proUntil : proUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
