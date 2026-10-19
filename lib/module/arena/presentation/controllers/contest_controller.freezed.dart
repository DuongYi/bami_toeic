// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'contest_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ContestSession {

 String get contestId; String get title; List<QuestionGroup> get groups;/// Giờ kết thúc theo đồng hồ máy (đã trừ lệch giờ server).
 DateTime get deadline; Map<String, String> get answers; Map<String, Set<String>> get eliminated; Set<String> get flagged; int get index; bool get submitting; ContestResult? get result; Object? get submitError;
/// Create a copy of ContestSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestSessionCopyWith<ContestSession> get copyWith => _$ContestSessionCopyWithImpl<ContestSession>(this as ContestSession, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as ContestSession;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestSession&&(identical(other.contestId, _this.contestId) || other.contestId == _this.contestId)&&(identical(other.title, _this.title) || other.title == _this.title)&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&(identical(other.deadline, _this.deadline) || other.deadline == _this.deadline)&&const DeepCollectionEquality().equals(other.answers, _this.answers)&&const DeepCollectionEquality().equals(other.eliminated, _this.eliminated)&&const DeepCollectionEquality().equals(other.flagged, _this.flagged)&&(identical(other.index, _this.index) || other.index == _this.index)&&(identical(other.submitting, _this.submitting) || other.submitting == _this.submitting)&&(identical(other.result, _this.result) || other.result == _this.result)&&const DeepCollectionEquality().equals(other.submitError, _this.submitError));
}


@override
int get hashCode {
  final _this = this as ContestSession;
  return Object.hash(runtimeType,_this.contestId,_this.title,const DeepCollectionEquality().hash(_this.groups),_this.deadline,const DeepCollectionEquality().hash(_this.answers),const DeepCollectionEquality().hash(_this.eliminated),const DeepCollectionEquality().hash(_this.flagged),_this.index,_this.submitting,_this.result,const DeepCollectionEquality().hash(_this.submitError));
}

@override
String toString() {
  final _this = this as ContestSession;
  return 'ContestSession(contestId: ${_this.contestId}, title: ${_this.title}, groups: ${_this.groups}, deadline: ${_this.deadline}, answers: ${_this.answers}, eliminated: ${_this.eliminated}, flagged: ${_this.flagged}, index: ${_this.index}, submitting: ${_this.submitting}, result: ${_this.result}, submitError: ${_this.submitError})';
}


}

/// @nodoc
abstract mixin class $ContestSessionCopyWith<$Res>  {
  factory $ContestSessionCopyWith(ContestSession value, $Res Function(ContestSession) _then) = _$ContestSessionCopyWithImpl;
@useResult
$Res call({
 String contestId, String title, List<QuestionGroup> groups, DateTime deadline, Map<String, String> answers, Map<String, Set<String>> eliminated, Set<String> flagged, int index, bool submitting, ContestResult? result, Object? submitError
});


$ContestResultCopyWith<$Res>? get result;

}
/// @nodoc
class _$ContestSessionCopyWithImpl<$Res>
    implements $ContestSessionCopyWith<$Res> {
  _$ContestSessionCopyWithImpl(this._self, this._then);

  final ContestSession _self;
  final $Res Function(ContestSession) _then;

/// Create a copy of ContestSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contestId = null,Object? title = null,Object? groups = null,Object? deadline = null,Object? answers = null,Object? eliminated = null,Object? flagged = null,Object? index = null,Object? submitting = null,Object? result = freezed,Object? submitError = freezed,}) {
  return _then(ContestSession(
contestId: null == contestId ? _self.contestId : contestId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<QuestionGroup>,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,eliminated: null == eliminated ? _self.eliminated : eliminated // ignore: cast_nullable_to_non_nullable
as Map<String, Set<String>>,flagged: null == flagged ? _self.flagged : flagged // ignore: cast_nullable_to_non_nullable
as Set<String>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ContestResult?,submitError: freezed == submitError ? _self.submitError : submitError ,
  ));
}
/// Create a copy of ContestSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContestResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $ContestResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContestSession].
extension ContestSessionPatterns on ContestSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestSession value)  $default,){
final _that = this;
switch (_that) {
case _ContestSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestSession value)?  $default,){
final _that = this;
switch (_that) {
case _ContestSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contestId,  String title,  List<QuestionGroup> groups,  DateTime deadline,  Map<String, String> answers,  Map<String, Set<String>> eliminated,  Set<String> flagged,  int index,  bool submitting,  ContestResult? result,  Object? submitError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestSession() when $default != null:
return $default(_that.contestId,_that.title,_that.groups,_that.deadline,_that.answers,_that.eliminated,_that.flagged,_that.index,_that.submitting,_that.result,_that.submitError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contestId,  String title,  List<QuestionGroup> groups,  DateTime deadline,  Map<String, String> answers,  Map<String, Set<String>> eliminated,  Set<String> flagged,  int index,  bool submitting,  ContestResult? result,  Object? submitError)  $default,) {final _that = this;
switch (_that) {
case _ContestSession():
return $default(_that.contestId,_that.title,_that.groups,_that.deadline,_that.answers,_that.eliminated,_that.flagged,_that.index,_that.submitting,_that.result,_that.submitError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contestId,  String title,  List<QuestionGroup> groups,  DateTime deadline,  Map<String, String> answers,  Map<String, Set<String>> eliminated,  Set<String> flagged,  int index,  bool submitting,  ContestResult? result,  Object? submitError)?  $default,) {final _that = this;
switch (_that) {
case _ContestSession() when $default != null:
return $default(_that.contestId,_that.title,_that.groups,_that.deadline,_that.answers,_that.eliminated,_that.flagged,_that.index,_that.submitting,_that.result,_that.submitError);case _:
  return null;

}
}

}

/// @nodoc


class _ContestSession extends ContestSession {
  const _ContestSession({required this.contestId, required this.title, required  List<QuestionGroup> groups, required this.deadline,  Map<String, String> answers = const <String, String>{},  Map<String, Set<String>> eliminated = const <String, Set<String>>{},  Set<String> flagged = const <String>{}, this.index = 0, this.submitting = false, this.result, this.submitError}): _groups = groups,_answers = answers,_eliminated = eliminated,_flagged = flagged,super._();
  

@override final  String contestId;
@override final  String title;
 final  List<QuestionGroup> _groups;
@override List<QuestionGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

/// Giờ kết thúc theo đồng hồ máy (đã trừ lệch giờ server).
@override final  DateTime deadline;
 final  Map<String, String> _answers;
@override@JsonKey() Map<String, String> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}

 final  Map<String, Set<String>> _eliminated;
@override@JsonKey() Map<String, Set<String>> get eliminated {
  if (_eliminated is EqualUnmodifiableMapView) return _eliminated;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_eliminated);
}

 final  Set<String> _flagged;
@override@JsonKey() Set<String> get flagged {
  if (_flagged is EqualUnmodifiableSetView) return _flagged;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_flagged);
}

@override@JsonKey() final  int index;
@override@JsonKey() final  bool submitting;
@override final  ContestResult? result;
@override final  Object? submitError;

/// Create a copy of ContestSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestSessionCopyWith<_ContestSession> get copyWith => __$ContestSessionCopyWithImpl<_ContestSession>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestSession&&(identical(other.contestId, contestId) || other.contestId == contestId)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.groups, _groups)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&const DeepCollectionEquality().equals(other.answers, _answers)&&const DeepCollectionEquality().equals(other.eliminated, _eliminated)&&const DeepCollectionEquality().equals(other.flagged, _flagged)&&(identical(other.index, index) || other.index == index)&&(identical(other.submitting, submitting) || other.submitting == submitting)&&(identical(other.result, result) || other.result == result)&&const DeepCollectionEquality().equals(other.submitError, submitError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,contestId,title,const DeepCollectionEquality().hash(_groups),deadline,const DeepCollectionEquality().hash(_answers),const DeepCollectionEquality().hash(_eliminated),const DeepCollectionEquality().hash(_flagged),index,submitting,result,const DeepCollectionEquality().hash(submitError));
}

@override
String toString() {
    return 'ContestSession(contestId: $contestId, title: $title, groups: $groups, deadline: $deadline, answers: $answers, eliminated: $eliminated, flagged: $flagged, index: $index, submitting: $submitting, result: $result, submitError: $submitError)';
}


}

/// @nodoc
abstract mixin class _$ContestSessionCopyWith<$Res> implements $ContestSessionCopyWith<$Res> {
  factory _$ContestSessionCopyWith(_ContestSession value, $Res Function(_ContestSession) _then) = __$ContestSessionCopyWithImpl;
@override @useResult
$Res call({
 String contestId, String title, List<QuestionGroup> groups, DateTime deadline, Map<String, String> answers, Map<String, Set<String>> eliminated, Set<String> flagged, int index, bool submitting, ContestResult? result, Object? submitError
});


@override $ContestResultCopyWith<$Res>? get result;

}
/// @nodoc
class __$ContestSessionCopyWithImpl<$Res>
    implements _$ContestSessionCopyWith<$Res> {
  __$ContestSessionCopyWithImpl(this._self, this._then);

  final _ContestSession _self;
  final $Res Function(_ContestSession) _then;

/// Create a copy of ContestSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contestId = null,Object? title = null,Object? groups = null,Object? deadline = null,Object? answers = null,Object? eliminated = null,Object? flagged = null,Object? index = null,Object? submitting = null,Object? result = freezed,Object? submitError = freezed,}) {
  return _then(_ContestSession(
contestId: null == contestId ? _self.contestId : contestId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<QuestionGroup>,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,eliminated: null == eliminated ? _self._eliminated : eliminated // ignore: cast_nullable_to_non_nullable
as Map<String, Set<String>>,flagged: null == flagged ? _self._flagged : flagged // ignore: cast_nullable_to_non_nullable
as Set<String>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,submitting: null == submitting ? _self.submitting : submitting // ignore: cast_nullable_to_non_nullable
as bool,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as ContestResult?,submitError: freezed == submitError ? _self.submitError : submitError ,
  ));
}

/// Create a copy of ContestSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContestResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $ContestResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}

// dart format on
