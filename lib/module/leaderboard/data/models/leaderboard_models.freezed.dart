// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaderboardEntry {

/// null = chưa đủ dữ liệu để xếp hạng (chỉ xảy ra với dòng của chính mình).
 int? get rank; String get userId; String get displayName; bool get isMe; int? get bestScore; int? get bestListening; int? get bestReading; int get fullTests; int get weekQuestions; int get weekCorrect;
/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardEntryCopyWith<LeaderboardEntry> get copyWith => _$LeaderboardEntryCopyWithImpl<LeaderboardEntry>(this as LeaderboardEntry, _$identity);

  /// Serializes this LeaderboardEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaderboardEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardEntry&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.isMe, _this.isMe) || other.isMe == _this.isMe)&&(identical(other.bestScore, _this.bestScore) || other.bestScore == _this.bestScore)&&(identical(other.bestListening, _this.bestListening) || other.bestListening == _this.bestListening)&&(identical(other.bestReading, _this.bestReading) || other.bestReading == _this.bestReading)&&(identical(other.fullTests, _this.fullTests) || other.fullTests == _this.fullTests)&&(identical(other.weekQuestions, _this.weekQuestions) || other.weekQuestions == _this.weekQuestions)&&(identical(other.weekCorrect, _this.weekCorrect) || other.weekCorrect == _this.weekCorrect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaderboardEntry;
  return Object.hash(runtimeType,_this.rank,_this.userId,_this.displayName,_this.isMe,_this.bestScore,_this.bestListening,_this.bestReading,_this.fullTests,_this.weekQuestions,_this.weekCorrect);
}

@override
String toString() {
  final _this = this as LeaderboardEntry;
  return 'LeaderboardEntry(rank: ${_this.rank}, userId: ${_this.userId}, displayName: ${_this.displayName}, isMe: ${_this.isMe}, bestScore: ${_this.bestScore}, bestListening: ${_this.bestListening}, bestReading: ${_this.bestReading}, fullTests: ${_this.fullTests}, weekQuestions: ${_this.weekQuestions}, weekCorrect: ${_this.weekCorrect})';
}


}

/// @nodoc
abstract mixin class $LeaderboardEntryCopyWith<$Res>  {
  factory $LeaderboardEntryCopyWith(LeaderboardEntry value, $Res Function(LeaderboardEntry) _then) = _$LeaderboardEntryCopyWithImpl;
@useResult
$Res call({
 int? rank, String userId, String displayName, bool isMe, int? bestScore, int? bestListening, int? bestReading, int fullTests, int weekQuestions, int weekCorrect
});




}
/// @nodoc
class _$LeaderboardEntryCopyWithImpl<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  _$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final LeaderboardEntry _self;
  final $Res Function(LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = freezed,Object? userId = null,Object? displayName = null,Object? isMe = null,Object? bestScore = freezed,Object? bestListening = freezed,Object? bestReading = freezed,Object? fullTests = null,Object? weekQuestions = null,Object? weekCorrect = null,}) {
  return _then(LeaderboardEntry(
rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,bestScore: freezed == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as int?,bestListening: freezed == bestListening ? _self.bestListening : bestListening // ignore: cast_nullable_to_non_nullable
as int?,bestReading: freezed == bestReading ? _self.bestReading : bestReading // ignore: cast_nullable_to_non_nullable
as int?,fullTests: null == fullTests ? _self.fullTests : fullTests // ignore: cast_nullable_to_non_nullable
as int,weekQuestions: null == weekQuestions ? _self.weekQuestions : weekQuestions // ignore: cast_nullable_to_non_nullable
as int,weekCorrect: null == weekCorrect ? _self.weekCorrect : weekCorrect // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardEntry].
extension LeaderboardEntryPatterns on LeaderboardEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardEntry value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardEntry value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? rank,  String userId,  String displayName,  bool isMe,  int? bestScore,  int? bestListening,  int? bestReading,  int fullTests,  int weekQuestions,  int weekCorrect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
return $default(_that.rank,_that.userId,_that.displayName,_that.isMe,_that.bestScore,_that.bestListening,_that.bestReading,_that.fullTests,_that.weekQuestions,_that.weekCorrect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? rank,  String userId,  String displayName,  bool isMe,  int? bestScore,  int? bestListening,  int? bestReading,  int fullTests,  int weekQuestions,  int weekCorrect)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntry():
return $default(_that.rank,_that.userId,_that.displayName,_that.isMe,_that.bestScore,_that.bestListening,_that.bestReading,_that.fullTests,_that.weekQuestions,_that.weekCorrect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? rank,  String userId,  String displayName,  bool isMe,  int? bestScore,  int? bestListening,  int? bestReading,  int fullTests,  int weekQuestions,  int weekCorrect)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
return $default(_that.rank,_that.userId,_that.displayName,_that.isMe,_that.bestScore,_that.bestListening,_that.bestReading,_that.fullTests,_that.weekQuestions,_that.weekCorrect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardEntry extends LeaderboardEntry {
  const _LeaderboardEntry({this.rank, required this.userId, required this.displayName, this.isMe = false, this.bestScore, this.bestListening, this.bestReading, this.fullTests = 0, this.weekQuestions = 0, this.weekCorrect = 0}): super._();
  factory _LeaderboardEntry.fromJson(Map<String, dynamic> json) => _$LeaderboardEntryFromJson(json);

/// null = chưa đủ dữ liệu để xếp hạng (chỉ xảy ra với dòng của chính mình).
@override final  int? rank;
@override final  String userId;
@override final  String displayName;
@override@JsonKey() final  bool isMe;
@override final  int? bestScore;
@override final  int? bestListening;
@override final  int? bestReading;
@override@JsonKey() final  int fullTests;
@override@JsonKey() final  int weekQuestions;
@override@JsonKey() final  int weekCorrect;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardEntryCopyWith<_LeaderboardEntry> get copyWith => __$LeaderboardEntryCopyWithImpl<_LeaderboardEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardEntry&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.bestScore, bestScore) || other.bestScore == bestScore)&&(identical(other.bestListening, bestListening) || other.bestListening == bestListening)&&(identical(other.bestReading, bestReading) || other.bestReading == bestReading)&&(identical(other.fullTests, fullTests) || other.fullTests == fullTests)&&(identical(other.weekQuestions, weekQuestions) || other.weekQuestions == weekQuestions)&&(identical(other.weekCorrect, weekCorrect) || other.weekCorrect == weekCorrect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rank,userId,displayName,isMe,bestScore,bestListening,bestReading,fullTests,weekQuestions,weekCorrect);
}

@override
String toString() {
    return 'LeaderboardEntry(rank: $rank, userId: $userId, displayName: $displayName, isMe: $isMe, bestScore: $bestScore, bestListening: $bestListening, bestReading: $bestReading, fullTests: $fullTests, weekQuestions: $weekQuestions, weekCorrect: $weekCorrect)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardEntryCopyWith<$Res> implements $LeaderboardEntryCopyWith<$Res> {
  factory _$LeaderboardEntryCopyWith(_LeaderboardEntry value, $Res Function(_LeaderboardEntry) _then) = __$LeaderboardEntryCopyWithImpl;
@override @useResult
$Res call({
 int? rank, String userId, String displayName, bool isMe, int? bestScore, int? bestListening, int? bestReading, int fullTests, int weekQuestions, int weekCorrect
});




}
/// @nodoc
class __$LeaderboardEntryCopyWithImpl<$Res>
    implements _$LeaderboardEntryCopyWith<$Res> {
  __$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final _LeaderboardEntry _self;
  final $Res Function(_LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = freezed,Object? userId = null,Object? displayName = null,Object? isMe = null,Object? bestScore = freezed,Object? bestListening = freezed,Object? bestReading = freezed,Object? fullTests = null,Object? weekQuestions = null,Object? weekCorrect = null,}) {
  return _then(_LeaderboardEntry(
rank: freezed == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int?,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,bestScore: freezed == bestScore ? _self.bestScore : bestScore // ignore: cast_nullable_to_non_nullable
as int?,bestListening: freezed == bestListening ? _self.bestListening : bestListening // ignore: cast_nullable_to_non_nullable
as int?,bestReading: freezed == bestReading ? _self.bestReading : bestReading // ignore: cast_nullable_to_non_nullable
as int?,fullTests: null == fullTests ? _self.fullTests : fullTests // ignore: cast_nullable_to_non_nullable
as int,weekQuestions: null == weekQuestions ? _self.weekQuestions : weekQuestions // ignore: cast_nullable_to_non_nullable
as int,weekCorrect: null == weekCorrect ? _self.weekCorrect : weekCorrect // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LeaderboardProfile {

 String? get displayName; bool get showOnLeaderboard;
/// Create a copy of LeaderboardProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardProfileCopyWith<LeaderboardProfile> get copyWith => _$LeaderboardProfileCopyWithImpl<LeaderboardProfile>(this as LeaderboardProfile, _$identity);

  /// Serializes this LeaderboardProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LeaderboardProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardProfile&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.showOnLeaderboard, _this.showOnLeaderboard) || other.showOnLeaderboard == _this.showOnLeaderboard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LeaderboardProfile;
  return Object.hash(runtimeType,_this.displayName,_this.showOnLeaderboard);
}

@override
String toString() {
  final _this = this as LeaderboardProfile;
  return 'LeaderboardProfile(displayName: ${_this.displayName}, showOnLeaderboard: ${_this.showOnLeaderboard})';
}


}

/// @nodoc
abstract mixin class $LeaderboardProfileCopyWith<$Res>  {
  factory $LeaderboardProfileCopyWith(LeaderboardProfile value, $Res Function(LeaderboardProfile) _then) = _$LeaderboardProfileCopyWithImpl;
@useResult
$Res call({
 String? displayName, bool showOnLeaderboard
});




}
/// @nodoc
class _$LeaderboardProfileCopyWithImpl<$Res>
    implements $LeaderboardProfileCopyWith<$Res> {
  _$LeaderboardProfileCopyWithImpl(this._self, this._then);

  final LeaderboardProfile _self;
  final $Res Function(LeaderboardProfile) _then;

/// Create a copy of LeaderboardProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? displayName = freezed,Object? showOnLeaderboard = null,}) {
  return _then(LeaderboardProfile(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,showOnLeaderboard: null == showOnLeaderboard ? _self.showOnLeaderboard : showOnLeaderboard // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardProfile].
extension LeaderboardProfilePatterns on LeaderboardProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardProfile value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardProfile value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? displayName,  bool showOnLeaderboard)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardProfile() when $default != null:
return $default(_that.displayName,_that.showOnLeaderboard);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? displayName,  bool showOnLeaderboard)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardProfile():
return $default(_that.displayName,_that.showOnLeaderboard);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? displayName,  bool showOnLeaderboard)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardProfile() when $default != null:
return $default(_that.displayName,_that.showOnLeaderboard);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardProfile implements LeaderboardProfile {
  const _LeaderboardProfile({this.displayName, this.showOnLeaderboard = true});
  factory _LeaderboardProfile.fromJson(Map<String, dynamic> json) => _$LeaderboardProfileFromJson(json);

@override final  String? displayName;
@override@JsonKey() final  bool showOnLeaderboard;

/// Create a copy of LeaderboardProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardProfileCopyWith<_LeaderboardProfile> get copyWith => __$LeaderboardProfileCopyWithImpl<_LeaderboardProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardProfile&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.showOnLeaderboard, showOnLeaderboard) || other.showOnLeaderboard == showOnLeaderboard));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,displayName,showOnLeaderboard);
}

@override
String toString() {
    return 'LeaderboardProfile(displayName: $displayName, showOnLeaderboard: $showOnLeaderboard)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardProfileCopyWith<$Res> implements $LeaderboardProfileCopyWith<$Res> {
  factory _$LeaderboardProfileCopyWith(_LeaderboardProfile value, $Res Function(_LeaderboardProfile) _then) = __$LeaderboardProfileCopyWithImpl;
@override @useResult
$Res call({
 String? displayName, bool showOnLeaderboard
});




}
/// @nodoc
class __$LeaderboardProfileCopyWithImpl<$Res>
    implements _$LeaderboardProfileCopyWith<$Res> {
  __$LeaderboardProfileCopyWithImpl(this._self, this._then);

  final _LeaderboardProfile _self;
  final $Res Function(_LeaderboardProfile) _then;

/// Create a copy of LeaderboardProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? displayName = freezed,Object? showOnLeaderboard = null,}) {
  return _then(_LeaderboardProfile(
displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,showOnLeaderboard: null == showOnLeaderboard ? _self.showOnLeaderboard : showOnLeaderboard // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
