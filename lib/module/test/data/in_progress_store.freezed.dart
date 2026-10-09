// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'in_progress_store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TakingSnapshot {

 String get testId; String get mode; List<int> get parts; DateTime get startedAt;/// Thi thử: số giây còn lại. Luyện tập: số giây đã làm.
 int get clockSeconds; int get index; Map<String, String> get answers; List<String> get revealed; List<String> get flagged; int get totalQuestions; DateTime get savedAt;
/// Create a copy of TakingSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TakingSnapshotCopyWith<TakingSnapshot> get copyWith => _$TakingSnapshotCopyWithImpl<TakingSnapshot>(this as TakingSnapshot, _$identity);

  /// Serializes this TakingSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TakingSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TakingSnapshot&&(identical(other.testId, _this.testId) || other.testId == _this.testId)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&const DeepCollectionEquality().equals(other.parts, _this.parts)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.clockSeconds, _this.clockSeconds) || other.clockSeconds == _this.clockSeconds)&&(identical(other.index, _this.index) || other.index == _this.index)&&const DeepCollectionEquality().equals(other.answers, _this.answers)&&const DeepCollectionEquality().equals(other.revealed, _this.revealed)&&const DeepCollectionEquality().equals(other.flagged, _this.flagged)&&(identical(other.totalQuestions, _this.totalQuestions) || other.totalQuestions == _this.totalQuestions)&&(identical(other.savedAt, _this.savedAt) || other.savedAt == _this.savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TakingSnapshot;
  return Object.hash(runtimeType,_this.testId,_this.mode,const DeepCollectionEquality().hash(_this.parts),_this.startedAt,_this.clockSeconds,_this.index,const DeepCollectionEquality().hash(_this.answers),const DeepCollectionEquality().hash(_this.revealed),const DeepCollectionEquality().hash(_this.flagged),_this.totalQuestions,_this.savedAt);
}

@override
String toString() {
  final _this = this as TakingSnapshot;
  return 'TakingSnapshot(testId: ${_this.testId}, mode: ${_this.mode}, parts: ${_this.parts}, startedAt: ${_this.startedAt}, clockSeconds: ${_this.clockSeconds}, index: ${_this.index}, answers: ${_this.answers}, revealed: ${_this.revealed}, flagged: ${_this.flagged}, totalQuestions: ${_this.totalQuestions}, savedAt: ${_this.savedAt})';
}


}

/// @nodoc
abstract mixin class $TakingSnapshotCopyWith<$Res>  {
  factory $TakingSnapshotCopyWith(TakingSnapshot value, $Res Function(TakingSnapshot) _then) = _$TakingSnapshotCopyWithImpl;
@useResult
$Res call({
 String testId, String mode, List<int> parts, DateTime startedAt, int clockSeconds, int index, Map<String, String> answers, List<String> revealed, List<String> flagged, int totalQuestions, DateTime savedAt
});




}
/// @nodoc
class _$TakingSnapshotCopyWithImpl<$Res>
    implements $TakingSnapshotCopyWith<$Res> {
  _$TakingSnapshotCopyWithImpl(this._self, this._then);

  final TakingSnapshot _self;
  final $Res Function(TakingSnapshot) _then;

/// Create a copy of TakingSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? testId = null,Object? mode = null,Object? parts = null,Object? startedAt = null,Object? clockSeconds = null,Object? index = null,Object? answers = null,Object? revealed = null,Object? flagged = null,Object? totalQuestions = null,Object? savedAt = null,}) {
  return _then(TakingSnapshot(
testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,clockSeconds: null == clockSeconds ? _self.clockSeconds : clockSeconds // ignore: cast_nullable_to_non_nullable
as int,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,revealed: null == revealed ? _self.revealed : revealed // ignore: cast_nullable_to_non_nullable
as List<String>,flagged: null == flagged ? _self.flagged : flagged // ignore: cast_nullable_to_non_nullable
as List<String>,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TakingSnapshot].
extension TakingSnapshotPatterns on TakingSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TakingSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TakingSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TakingSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _TakingSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TakingSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _TakingSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String testId,  String mode,  List<int> parts,  DateTime startedAt,  int clockSeconds,  int index,  Map<String, String> answers,  List<String> revealed,  List<String> flagged,  int totalQuestions,  DateTime savedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TakingSnapshot() when $default != null:
return $default(_that.testId,_that.mode,_that.parts,_that.startedAt,_that.clockSeconds,_that.index,_that.answers,_that.revealed,_that.flagged,_that.totalQuestions,_that.savedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String testId,  String mode,  List<int> parts,  DateTime startedAt,  int clockSeconds,  int index,  Map<String, String> answers,  List<String> revealed,  List<String> flagged,  int totalQuestions,  DateTime savedAt)  $default,) {final _that = this;
switch (_that) {
case _TakingSnapshot():
return $default(_that.testId,_that.mode,_that.parts,_that.startedAt,_that.clockSeconds,_that.index,_that.answers,_that.revealed,_that.flagged,_that.totalQuestions,_that.savedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String testId,  String mode,  List<int> parts,  DateTime startedAt,  int clockSeconds,  int index,  Map<String, String> answers,  List<String> revealed,  List<String> flagged,  int totalQuestions,  DateTime savedAt)?  $default,) {final _that = this;
switch (_that) {
case _TakingSnapshot() when $default != null:
return $default(_that.testId,_that.mode,_that.parts,_that.startedAt,_that.clockSeconds,_that.index,_that.answers,_that.revealed,_that.flagged,_that.totalQuestions,_that.savedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TakingSnapshot extends TakingSnapshot {
  const _TakingSnapshot({required this.testId, required this.mode, required  List<int> parts, required this.startedAt, required this.clockSeconds, this.index = 0,  Map<String, String> answers = const <String, String>{},  List<String> revealed = const <String>[],  List<String> flagged = const <String>[], required this.totalQuestions, required this.savedAt}): _parts = parts,_answers = answers,_revealed = revealed,_flagged = flagged,super._();
  factory _TakingSnapshot.fromJson(Map<String, dynamic> json) => _$TakingSnapshotFromJson(json);

@override final  String testId;
@override final  String mode;
 final  List<int> _parts;
@override List<int> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

@override final  DateTime startedAt;
/// Thi thử: số giây còn lại. Luyện tập: số giây đã làm.
@override final  int clockSeconds;
@override@JsonKey() final  int index;
 final  Map<String, String> _answers;
@override@JsonKey() Map<String, String> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}

 final  List<String> _revealed;
@override@JsonKey() List<String> get revealed {
  if (_revealed is EqualUnmodifiableListView) return _revealed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_revealed);
}

 final  List<String> _flagged;
@override@JsonKey() List<String> get flagged {
  if (_flagged is EqualUnmodifiableListView) return _flagged;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_flagged);
}

@override final  int totalQuestions;
@override final  DateTime savedAt;

/// Create a copy of TakingSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TakingSnapshotCopyWith<_TakingSnapshot> get copyWith => __$TakingSnapshotCopyWithImpl<_TakingSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TakingSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TakingSnapshot&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.parts, _parts)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.clockSeconds, clockSeconds) || other.clockSeconds == clockSeconds)&&(identical(other.index, index) || other.index == index)&&const DeepCollectionEquality().equals(other.answers, _answers)&&const DeepCollectionEquality().equals(other.revealed, _revealed)&&const DeepCollectionEquality().equals(other.flagged, _flagged)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,testId,mode,const DeepCollectionEquality().hash(_parts),startedAt,clockSeconds,index,const DeepCollectionEquality().hash(_answers),const DeepCollectionEquality().hash(_revealed),const DeepCollectionEquality().hash(_flagged),totalQuestions,savedAt);
}

@override
String toString() {
    return 'TakingSnapshot(testId: $testId, mode: $mode, parts: $parts, startedAt: $startedAt, clockSeconds: $clockSeconds, index: $index, answers: $answers, revealed: $revealed, flagged: $flagged, totalQuestions: $totalQuestions, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class _$TakingSnapshotCopyWith<$Res> implements $TakingSnapshotCopyWith<$Res> {
  factory _$TakingSnapshotCopyWith(_TakingSnapshot value, $Res Function(_TakingSnapshot) _then) = __$TakingSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String testId, String mode, List<int> parts, DateTime startedAt, int clockSeconds, int index, Map<String, String> answers, List<String> revealed, List<String> flagged, int totalQuestions, DateTime savedAt
});




}
/// @nodoc
class __$TakingSnapshotCopyWithImpl<$Res>
    implements _$TakingSnapshotCopyWith<$Res> {
  __$TakingSnapshotCopyWithImpl(this._self, this._then);

  final _TakingSnapshot _self;
  final $Res Function(_TakingSnapshot) _then;

/// Create a copy of TakingSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? testId = null,Object? mode = null,Object? parts = null,Object? startedAt = null,Object? clockSeconds = null,Object? index = null,Object? answers = null,Object? revealed = null,Object? flagged = null,Object? totalQuestions = null,Object? savedAt = null,}) {
  return _then(_TakingSnapshot(
testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,clockSeconds: null == clockSeconds ? _self.clockSeconds : clockSeconds // ignore: cast_nullable_to_non_nullable
as int,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,revealed: null == revealed ? _self._revealed : revealed // ignore: cast_nullable_to_non_nullable
as List<String>,flagged: null == flagged ? _self._flagged : flagged // ignore: cast_nullable_to_non_nullable
as List<String>,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
