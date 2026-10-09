// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_api.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SignedObject {

 String? get path; String? get error;/// Dạng "/object/sign/media/…?token=…" (tương đối với /storage/v1).
@JsonKey(name: 'signedURL') String? get signedUrl;
/// Create a copy of SignedObject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignedObjectCopyWith<SignedObject> get copyWith => _$SignedObjectCopyWithImpl<SignedObject>(this as SignedObject, _$identity);

  /// Serializes this SignedObject to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SignedObject;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignedObject&&(identical(other.path, _this.path) || other.path == _this.path)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.signedUrl, _this.signedUrl) || other.signedUrl == _this.signedUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SignedObject;
  return Object.hash(runtimeType,_this.path,_this.error,_this.signedUrl);
}

@override
String toString() {
  final _this = this as SignedObject;
  return 'SignedObject(path: ${_this.path}, error: ${_this.error}, signedUrl: ${_this.signedUrl})';
}


}

/// @nodoc
abstract mixin class $SignedObjectCopyWith<$Res>  {
  factory $SignedObjectCopyWith(SignedObject value, $Res Function(SignedObject) _then) = _$SignedObjectCopyWithImpl;
@useResult
$Res call({
 String? path, String? error,@JsonKey(name: 'signedURL') String? signedUrl
});




}
/// @nodoc
class _$SignedObjectCopyWithImpl<$Res>
    implements $SignedObjectCopyWith<$Res> {
  _$SignedObjectCopyWithImpl(this._self, this._then);

  final SignedObject _self;
  final $Res Function(SignedObject) _then;

/// Create a copy of SignedObject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = freezed,Object? error = freezed,Object? signedUrl = freezed,}) {
  return _then(SignedObject(
path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,signedUrl: freezed == signedUrl ? _self.signedUrl : signedUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SignedObject].
extension SignedObjectPatterns on SignedObject {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SignedObject value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SignedObject() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SignedObject value)  $default,){
final _that = this;
switch (_that) {
case _SignedObject():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SignedObject value)?  $default,){
final _that = this;
switch (_that) {
case _SignedObject() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? path,  String? error, @JsonKey(name: 'signedURL')  String? signedUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SignedObject() when $default != null:
return $default(_that.path,_that.error,_that.signedUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? path,  String? error, @JsonKey(name: 'signedURL')  String? signedUrl)  $default,) {final _that = this;
switch (_that) {
case _SignedObject():
return $default(_that.path,_that.error,_that.signedUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? path,  String? error, @JsonKey(name: 'signedURL')  String? signedUrl)?  $default,) {final _that = this;
switch (_that) {
case _SignedObject() when $default != null:
return $default(_that.path,_that.error,_that.signedUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SignedObject implements SignedObject {
  const _SignedObject({this.path, this.error, @JsonKey(name: 'signedURL') this.signedUrl});
  factory _SignedObject.fromJson(Map<String, dynamic> json) => _$SignedObjectFromJson(json);

@override final  String? path;
@override final  String? error;
/// Dạng "/object/sign/media/…?token=…" (tương đối với /storage/v1).
@override@JsonKey(name: 'signedURL') final  String? signedUrl;

/// Create a copy of SignedObject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignedObjectCopyWith<_SignedObject> get copyWith => __$SignedObjectCopyWithImpl<_SignedObject>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SignedObjectToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignedObject&&(identical(other.path, path) || other.path == path)&&(identical(other.error, error) || other.error == error)&&(identical(other.signedUrl, signedUrl) || other.signedUrl == signedUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,path,error,signedUrl);
}

@override
String toString() {
    return 'SignedObject(path: $path, error: $error, signedUrl: $signedUrl)';
}


}

/// @nodoc
abstract mixin class _$SignedObjectCopyWith<$Res> implements $SignedObjectCopyWith<$Res> {
  factory _$SignedObjectCopyWith(_SignedObject value, $Res Function(_SignedObject) _then) = __$SignedObjectCopyWithImpl;
@override @useResult
$Res call({
 String? path, String? error,@JsonKey(name: 'signedURL') String? signedUrl
});




}
/// @nodoc
class __$SignedObjectCopyWithImpl<$Res>
    implements _$SignedObjectCopyWith<$Res> {
  __$SignedObjectCopyWithImpl(this._self, this._then);

  final _SignedObject _self;
  final $Res Function(_SignedObject) _then;

/// Create a copy of SignedObject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = freezed,Object? error = freezed,Object? signedUrl = freezed,}) {
  return _then(_SignedObject(
path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,signedUrl: freezed == signedUrl ? _self.signedUrl : signedUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
