// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_taking_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TakingState {

 String get mode; List<int> get parts; List<QuestionGroup> get groups; DateTime get startedAt;/// Thi thử: thời gian còn lại. Luyện tập: thời gian đã làm.
 Duration get clock; Map<String, String> get answers;/// Câu đã hiện đáp án (chế độ luyện tập)
 Set<String> get revealed;/// Câu đánh dấu để xem lại trước khi nộp
 Set<String> get flagged; int get index; bool get submitting; bool get isMistakeSession;/// Khôi phục từ bài làm dở
 bool get resumed; Attempt? get submitted;/// Kết quả phiên sổ câu sai: (đúng, tổng)
 (int, int,)? get mistakeResult; Object? get submitError;
/// Create a copy of TakingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TakingStateCopyWith<TakingState> get copyWith => _$TakingStateCopyWithImpl<TakingState>(this as TakingState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TakingState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TakingState&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&const DeepCollectionEquality().equals(other.parts, _this.parts)&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.clock, _this.clock) || other.clock == _this.clock)&&const DeepCollectionEquality().equals(other.answers, _this.answers)&&const DeepCollectionEquality().equals(other.revealed, _this.revealed)&&const DeepCollectionEquality().equals(other.flagged, _this.flagged)&&(identical(other.index, _this.index) || other.index == _this.index)&&(identical(other.submitting, _this.submitting) || other.submitting == _this.submitting)&&(identical(other.isMistakeSession, _this.isMistakeSession) || other.isMistakeSession == _this.isMistakeSession)&&(identical(other.resumed, _this.resumed) || other.resumed == _this.resumed)&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.mistakeResult, _this.mistakeResult) || other.mistakeResult == _this.mistakeResult)&&const DeepCollectionEquality().equals(other.submitError, _this.submitError));
}


@override
int get hashCode {
  final _this = this as TakingState;
  return Object.hash(runtimeType,_this.mode,const DeepCollectionEquality().hash(_this.parts),const DeepCollectionEquality().hash(_this.groups),_this.startedAt,_this.clock,const DeepCollectionEquality().hash(_this.answers),const DeepCollectionEquality().hash(_this.revealed),const DeepCollectionEquality().hash(_this.flagged),_this.index,_this.submitting,_this.isMistakeSession,_this.resumed,_this.submitted,_this.mistakeResult,const DeepCollectionEquality().hash(_this.submitError));
}

@override
String toString() {
  final _this = this as TakingState;
  return 'TakingState(mode: ${_this.mode}, parts: ${_this.parts}, groups: ${_this.groups}, startedAt: ${_this.startedAt}, clock: ${_this.clock}, answers: ${_this.answers}, revealed: ${_this.revealed}, flagged: ${_this.flagged}, index: ${_this.index}, submitting: ${_this.submitting}, isMistakeSession: ${_this.isMistakeSession}, resumed: ${_this.resumed}, submitted: ${_this.submitted}, mistakeResult: ${_this.mistakeResult}, submitError: ${_this.submitError})';
}


}

/// @nodoc
abstract mixin class $TakingStateCopyWith<$Res>  {
  factory $TakingStateCopyWith(TakingState value, $Res Function(TakingState) _then) = _$TakingStateCopyWithImpl;
@useResult
$Res call({
 String mode, List<int> parts, List<QuestionGroup> groups, DateTime startedAt, Duration clock, Map<String, String> answers, Set<String> revealed, Set<String> flagged, int index, bool submitting, bool isMistakeSession, bool resumed, Attempt? submitted, (int, int,)? mistakeResult, Object? submitError
});


$AttemptCopyWith<$Res>? get submitted;

}
/// @nodoc
class _$TakingStateCopyWithImpl<$Res>
    implements $TakingStateCopyWith<$Res> {
  _$TakingStateCopyWithImpl(this._self, this._then);

  final TakingState _self;
  final $Res Function(TakingState) _then;

/// Create a copy of TakingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? parts = null,Object? groups = null,Object? startedAt = null,Object? clock = null,Object? answers = null,Object? revealed = null,Object? flagged = null,Object? index = null,Object? submitting = null,Object? isMistakeSession = null,Object? resumed = null,Object? submitted = freezed,Object? mistakeResult = freezed,Object? submitError = freezed,}) {
  return _then(TakingState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<QuestionGroup>,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,clock: null == clock ? _self.clock : clock // ignore: cast_nullable_to_non_nullable
as Duration,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,revealed: null == revealed ? _self.revealed : revealed // ignore: cast_nullable_to_non_nullable
as Set<String>,flagged: null == flagged ? _self.flagged : flagged // ignore: cast_nullable_to_non_nullable
as Set<String>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,isMistakeSession: null == isMistakeSession ? _self.isMistakeSession : isMistakeSession // ignore: cast_nullable_to_non_nullable
as bool,resumed: null == resumed ? _self.resumed : resumed // ignore: cast_nullable_to_non_nullable
as bool,submitted: freezed == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as Attempt?,mistakeResult: freezed == mistakeResult ? _self.mistakeResult : mistakeResult // ignore: cast_nullable_to_non_nullable
as (int, int,)?,submitError: freezed == submitError ? _self.submitError : submitError ,
  ));
}
/// Create a copy of TakingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttemptCopyWith<$Res>? get submitted {
    if (_self.submitted == null) {
    return null;
  }

  return $AttemptCopyWith<$Res>(_self.submitted!, (value) {
    return _then(_self.copyWith(submitted: value));
  });
}
}


/// Adds pattern-matching-related methods to [TakingState].
extension TakingStatePatterns on TakingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TakingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TakingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TakingState value)  $default,){
final _that = this;
switch (_that) {
case _TakingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TakingState value)?  $default,){
final _that = this;
switch (_that) {
case _TakingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mode,  List<int> parts,  List<QuestionGroup> groups,  DateTime startedAt,  Duration clock,  Map<String, String> answers,  Set<String> revealed,  Set<String> flagged,  int index,  bool submitting,  bool isMistakeSession,  bool resumed,  Attempt? submitted,  (int, int,)? mistakeResult,  Object? submitError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TakingState() when $default != null:
return $default(_that.mode,_that.parts,_that.groups,_that.startedAt,_that.clock,_that.answers,_that.revealed,_that.flagged,_that.index,_that.submitting,_that.isMistakeSession,_that.resumed,_that.submitted,_that.mistakeResult,_that.submitError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mode,  List<int> parts,  List<QuestionGroup> groups,  DateTime startedAt,  Duration clock,  Map<String, String> answers,  Set<String> revealed,  Set<String> flagged,  int index,  bool submitting,  bool isMistakeSession,  bool resumed,  Attempt? submitted,  (int, int,)? mistakeResult,  Object? submitError)  $default,) {final _that = this;
switch (_that) {
case _TakingState():
return $default(_that.mode,_that.parts,_that.groups,_that.startedAt,_that.clock,_that.answers,_that.revealed,_that.flagged,_that.index,_that.submitting,_that.isMistakeSession,_that.resumed,_that.submitted,_that.mistakeResult,_that.submitError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mode,  List<int> parts,  List<QuestionGroup> groups,  DateTime startedAt,  Duration clock,  Map<String, String> answers,  Set<String> revealed,  Set<String> flagged,  int index,  bool submitting,  bool isMistakeSession,  bool resumed,  Attempt? submitted,  (int, int,)? mistakeResult,  Object? submitError)?  $default,) {final _that = this;
switch (_that) {
case _TakingState() when $default != null:
return $default(_that.mode,_that.parts,_that.groups,_that.startedAt,_that.clock,_that.answers,_that.revealed,_that.flagged,_that.index,_that.submitting,_that.isMistakeSession,_that.resumed,_that.submitted,_that.mistakeResult,_that.submitError);case _:
  return null;

}
}

}

/// @nodoc


class _TakingState extends TakingState {
  const _TakingState({required this.mode, required  List<int> parts, required  List<QuestionGroup> groups, required this.startedAt, required this.clock,  Map<String, String> answers = const <String, String>{},  Set<String> revealed = const <String>{},  Set<String> flagged = const <String>{}, this.index = 0, this.submitting = false, this.isMistakeSession = false, this.resumed = false, this.submitted, this.mistakeResult, this.submitError}): _parts = parts,_groups = groups,_answers = answers,_revealed = revealed,_flagged = flagged,super._();
  

@override final  String mode;
 final  List<int> _parts;
@override List<int> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

 final  List<QuestionGroup> _groups;
@override List<QuestionGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

@override final  DateTime startedAt;
/// Thi thử: thời gian còn lại. Luyện tập: thời gian đã làm.
@override final  Duration clock;
 final  Map<String, String> _answers;
@override@JsonKey() Map<String, String> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}

/// Câu đã hiện đáp án (chế độ luyện tập)
 final  Set<String> _revealed;
/// Câu đã hiện đáp án (chế độ luyện tập)
@override@JsonKey() Set<String> get revealed {
  if (_revealed is EqualUnmodifiableSetView) return _revealed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_revealed);
}

/// Câu đánh dấu để xem lại trước khi nộp
 final  Set<String> _flagged;
/// Câu đánh dấu để xem lại trước khi nộp
@override@JsonKey() Set<String> get flagged {
  if (_flagged is EqualUnmodifiableSetView) return _flagged;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_flagged);
}

@override@JsonKey() final  int index;
@override@JsonKey() final  bool submitting;
@override@JsonKey() final  bool isMistakeSession;
/// Khôi phục từ bài làm dở
@override@JsonKey() final  bool resumed;
@override final  Attempt? submitted;
/// Kết quả phiên sổ câu sai: (đúng, tổng)
@override final  (int, int,)? mistakeResult;
@override final  Object? submitError;

/// Create a copy of TakingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TakingStateCopyWith<_TakingState> get copyWith => __$TakingStateCopyWithImpl<_TakingState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TakingState&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.parts, _parts)&&const DeepCollectionEquality().equals(other.groups, _groups)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.clock, clock) || other.clock == clock)&&const DeepCollectionEquality().equals(other.answers, _answers)&&const DeepCollectionEquality().equals(other.revealed, _revealed)&&const DeepCollectionEquality().equals(other.flagged, _flagged)&&(identical(other.index, index) || other.index == index)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.isMistakeSession, isMistakeSession) || other.isMistakeSession == isMistakeSession)&&(identical(other.resumed, resumed) || other.resumed == resumed)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.mistakeResult, mistakeResult) || other.mistakeResult == mistakeResult)&&const DeepCollectionEquality().equals(other.submitError, submitError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,mode,const DeepCollectionEquality().hash(_parts),const DeepCollectionEquality().hash(_groups),startedAt,clock,const DeepCollectionEquality().hash(_answers),const DeepCollectionEquality().hash(_revealed),const DeepCollectionEquality().hash(_flagged),index,submitting,isMistakeSession,resumed,submitted,mistakeResult,const DeepCollectionEquality().hash(submitError));
}

@override
String toString() {
    return 'TakingState(mode: $mode, parts: $parts, groups: $groups, startedAt: $startedAt, clock: $clock, answers: $answers, revealed: $revealed, flagged: $flagged, index: $index, submitting: $submitting, isMistakeSession: $isMistakeSession, resumed: $resumed, submitted: $submitted, mistakeResult: $mistakeResult, submitError: $submitError)';
}


}

/// @nodoc
abstract mixin class _$TakingStateCopyWith<$Res> implements $TakingStateCopyWith<$Res> {
  factory _$TakingStateCopyWith(_TakingState value, $Res Function(_TakingState) _then) = __$TakingStateCopyWithImpl;
@override @useResult
$Res call({
 String mode, List<int> parts, List<QuestionGroup> groups, DateTime startedAt, Duration clock, Map<String, String> answers, Set<String> revealed, Set<String> flagged, int index, bool submitting, bool isMistakeSession, bool resumed, Attempt? submitted, (int, int,)? mistakeResult, Object? submitError
});


@override $AttemptCopyWith<$Res>? get submitted;

}
/// @nodoc
class __$TakingStateCopyWithImpl<$Res>
    implements _$TakingStateCopyWith<$Res> {
  __$TakingStateCopyWithImpl(this._self, this._then);

  final _TakingState _self;
  final $Res Function(_TakingState) _then;

/// Create a copy of TakingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? parts = null,Object? groups = null,Object? startedAt = null,Object? clock = null,Object? answers = null,Object? revealed = null,Object? flagged = null,Object? index = null,Object? submitting = null,Object? isMistakeSession = null,Object? resumed = null,Object? submitted = freezed,Object? mistakeResult = freezed,Object? submitError = freezed,}) {
  return _then(_TakingState(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<QuestionGroup>,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,clock: null == clock ? _self.clock : clock // ignore: cast_nullable_to_non_nullable
as Duration,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,revealed: null == revealed ? _self._revealed : revealed // ignore: cast_nullable_to_non_nullable
as Set<String>,flagged: null == flagged ? _self._flagged : flagged // ignore: cast_nullable_to_non_nullable
as Set<String>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,isMistakeSession: null == isMistakeSession ? _self.isMistakeSession : isMistakeSession // ignore: cast_nullable_to_non_nullable
as bool,resumed: null == resumed ? _self.resumed : resumed // ignore: cast_nullable_to_non_nullable
as bool,submitted: freezed == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as Attempt?,mistakeResult: freezed == mistakeResult ? _self.mistakeResult : mistakeResult // ignore: cast_nullable_to_non_nullable
as (int, int,)?,submitError: freezed == submitError ? _self.submitError : submitError ,
  ));
}

/// Create a copy of TakingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttemptCopyWith<$Res>? get submitted {
    if (_self.submitted == null) {
    return null;
  }

  return $AttemptCopyWith<$Res>(_self.submitted!, (value) {
    return _then(_self.copyWith(submitted: value));
  });
}
}

// dart format on
