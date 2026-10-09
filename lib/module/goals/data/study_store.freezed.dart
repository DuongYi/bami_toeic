// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'study_store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DayLog {

/// Số câu đề đã làm (kể cả luyện sổ câu sai)
 int get questions;/// Số câu sổ câu sai đã luyện lại
 int get mistakes;/// Số lượt ôn flashcard
 int get words;/// Số đoạn chép chính tả đã chấm
 int get dictations;
/// Create a copy of DayLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayLogCopyWith<DayLog> get copyWith => _$DayLogCopyWithImpl<DayLog>(this as DayLog, _$identity);

  /// Serializes this DayLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DayLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayLog&&(identical(other.questions, _this.questions) || other.questions == _this.questions)&&(identical(other.mistakes, _this.mistakes) || other.mistakes == _this.mistakes)&&(identical(other.words, _this.words) || other.words == _this.words)&&(identical(other.dictations, _this.dictations) || other.dictations == _this.dictations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DayLog;
  return Object.hash(runtimeType,_this.questions,_this.mistakes,_this.words,_this.dictations);
}

@override
String toString() {
  final _this = this as DayLog;
  return 'DayLog(questions: ${_this.questions}, mistakes: ${_this.mistakes}, words: ${_this.words}, dictations: ${_this.dictations})';
}


}

/// @nodoc
abstract mixin class $DayLogCopyWith<$Res>  {
  factory $DayLogCopyWith(DayLog value, $Res Function(DayLog) _then) = _$DayLogCopyWithImpl;
@useResult
$Res call({
 int questions, int mistakes, int words, int dictations
});




}
/// @nodoc
class _$DayLogCopyWithImpl<$Res>
    implements $DayLogCopyWith<$Res> {
  _$DayLogCopyWithImpl(this._self, this._then);

  final DayLog _self;
  final $Res Function(DayLog) _then;

/// Create a copy of DayLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questions = null,Object? mistakes = null,Object? words = null,Object? dictations = null,}) {
  return _then(DayLog(
questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as int,mistakes: null == mistakes ? _self.mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as int,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as int,dictations: null == dictations ? _self.dictations : dictations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DayLog].
extension DayLogPatterns on DayLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayLog value)  $default,){
final _that = this;
switch (_that) {
case _DayLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayLog value)?  $default,){
final _that = this;
switch (_that) {
case _DayLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int questions,  int mistakes,  int words,  int dictations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayLog() when $default != null:
return $default(_that.questions,_that.mistakes,_that.words,_that.dictations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int questions,  int mistakes,  int words,  int dictations)  $default,) {final _that = this;
switch (_that) {
case _DayLog():
return $default(_that.questions,_that.mistakes,_that.words,_that.dictations);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int questions,  int mistakes,  int words,  int dictations)?  $default,) {final _that = this;
switch (_that) {
case _DayLog() when $default != null:
return $default(_that.questions,_that.mistakes,_that.words,_that.dictations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DayLog extends DayLog {
  const _DayLog({this.questions = 0, this.mistakes = 0, this.words = 0, this.dictations = 0}): super._();
  factory _DayLog.fromJson(Map<String, dynamic> json) => _$DayLogFromJson(json);

/// Số câu đề đã làm (kể cả luyện sổ câu sai)
@override@JsonKey() final  int questions;
/// Số câu sổ câu sai đã luyện lại
@override@JsonKey() final  int mistakes;
/// Số lượt ôn flashcard
@override@JsonKey() final  int words;
/// Số đoạn chép chính tả đã chấm
@override@JsonKey() final  int dictations;

/// Create a copy of DayLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayLogCopyWith<_DayLog> get copyWith => __$DayLogCopyWithImpl<_DayLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DayLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayLog&&(identical(other.questions, questions) || other.questions == questions)&&(identical(other.mistakes, mistakes) || other.mistakes == mistakes)&&(identical(other.words, words) || other.words == words)&&(identical(other.dictations, dictations) || other.dictations == dictations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,questions,mistakes,words,dictations);
}

@override
String toString() {
    return 'DayLog(questions: $questions, mistakes: $mistakes, words: $words, dictations: $dictations)';
}


}

/// @nodoc
abstract mixin class _$DayLogCopyWith<$Res> implements $DayLogCopyWith<$Res> {
  factory _$DayLogCopyWith(_DayLog value, $Res Function(_DayLog) _then) = __$DayLogCopyWithImpl;
@override @useResult
$Res call({
 int questions, int mistakes, int words, int dictations
});




}
/// @nodoc
class __$DayLogCopyWithImpl<$Res>
    implements _$DayLogCopyWith<$Res> {
  __$DayLogCopyWithImpl(this._self, this._then);

  final _DayLog _self;
  final $Res Function(_DayLog) _then;

/// Create a copy of DayLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questions = null,Object? mistakes = null,Object? words = null,Object? dictations = null,}) {
  return _then(_DayLog(
questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as int,mistakes: null == mistakes ? _self.mistakes : mistakes // ignore: cast_nullable_to_non_nullable
as int,words: null == words ? _self.words : words // ignore: cast_nullable_to_non_nullable
as int,dictations: null == dictations ? _self.dictations : dictations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$GoalSettings {

 int? get targetScore; DateTime? get examDate; int get dailyQuestions; int get dailyWords; int get dailyDictations;/// Giờ nhắc học, dạng phút trong ngày (null = tắt nhắc)
 int? get reminderMinutes;
/// Create a copy of GoalSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GoalSettingsCopyWith<GoalSettings> get copyWith => _$GoalSettingsCopyWithImpl<GoalSettings>(this as GoalSettings, _$identity);

  /// Serializes this GoalSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GoalSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoalSettings&&(identical(other.targetScore, _this.targetScore) || other.targetScore == _this.targetScore)&&(identical(other.examDate, _this.examDate) || other.examDate == _this.examDate)&&(identical(other.dailyQuestions, _this.dailyQuestions) || other.dailyQuestions == _this.dailyQuestions)&&(identical(other.dailyWords, _this.dailyWords) || other.dailyWords == _this.dailyWords)&&(identical(other.dailyDictations, _this.dailyDictations) || other.dailyDictations == _this.dailyDictations)&&(identical(other.reminderMinutes, _this.reminderMinutes) || other.reminderMinutes == _this.reminderMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GoalSettings;
  return Object.hash(runtimeType,_this.targetScore,_this.examDate,_this.dailyQuestions,_this.dailyWords,_this.dailyDictations,_this.reminderMinutes);
}

@override
String toString() {
  final _this = this as GoalSettings;
  return 'GoalSettings(targetScore: ${_this.targetScore}, examDate: ${_this.examDate}, dailyQuestions: ${_this.dailyQuestions}, dailyWords: ${_this.dailyWords}, dailyDictations: ${_this.dailyDictations}, reminderMinutes: ${_this.reminderMinutes})';
}


}

/// @nodoc
abstract mixin class $GoalSettingsCopyWith<$Res>  {
  factory $GoalSettingsCopyWith(GoalSettings value, $Res Function(GoalSettings) _then) = _$GoalSettingsCopyWithImpl;
@useResult
$Res call({
 int? targetScore, DateTime? examDate, int dailyQuestions, int dailyWords, int dailyDictations, int? reminderMinutes
});




}
/// @nodoc
class _$GoalSettingsCopyWithImpl<$Res>
    implements $GoalSettingsCopyWith<$Res> {
  _$GoalSettingsCopyWithImpl(this._self, this._then);

  final GoalSettings _self;
  final $Res Function(GoalSettings) _then;

/// Create a copy of GoalSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? targetScore = freezed,Object? examDate = freezed,Object? dailyQuestions = null,Object? dailyWords = null,Object? dailyDictations = null,Object? reminderMinutes = freezed,}) {
  return _then(GoalSettings(
targetScore: freezed == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int?,examDate: freezed == examDate ? _self.examDate : examDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dailyQuestions: null == dailyQuestions ? _self.dailyQuestions : dailyQuestions // ignore: cast_nullable_to_non_nullable
as int,dailyWords: null == dailyWords ? _self.dailyWords : dailyWords // ignore: cast_nullable_to_non_nullable
as int,dailyDictations: null == dailyDictations ? _self.dailyDictations : dailyDictations // ignore: cast_nullable_to_non_nullable
as int,reminderMinutes: freezed == reminderMinutes ? _self.reminderMinutes : reminderMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GoalSettings].
extension GoalSettingsPatterns on GoalSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GoalSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GoalSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GoalSettings value)  $default,){
final _that = this;
switch (_that) {
case _GoalSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GoalSettings value)?  $default,){
final _that = this;
switch (_that) {
case _GoalSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? targetScore,  DateTime? examDate,  int dailyQuestions,  int dailyWords,  int dailyDictations,  int? reminderMinutes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GoalSettings() when $default != null:
return $default(_that.targetScore,_that.examDate,_that.dailyQuestions,_that.dailyWords,_that.dailyDictations,_that.reminderMinutes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? targetScore,  DateTime? examDate,  int dailyQuestions,  int dailyWords,  int dailyDictations,  int? reminderMinutes)  $default,) {final _that = this;
switch (_that) {
case _GoalSettings():
return $default(_that.targetScore,_that.examDate,_that.dailyQuestions,_that.dailyWords,_that.dailyDictations,_that.reminderMinutes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? targetScore,  DateTime? examDate,  int dailyQuestions,  int dailyWords,  int dailyDictations,  int? reminderMinutes)?  $default,) {final _that = this;
switch (_that) {
case _GoalSettings() when $default != null:
return $default(_that.targetScore,_that.examDate,_that.dailyQuestions,_that.dailyWords,_that.dailyDictations,_that.reminderMinutes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GoalSettings extends GoalSettings {
  const _GoalSettings({this.targetScore, this.examDate, this.dailyQuestions = 20, this.dailyWords = 15, this.dailyDictations = 3, this.reminderMinutes}): super._();
  factory _GoalSettings.fromJson(Map<String, dynamic> json) => _$GoalSettingsFromJson(json);

@override final  int? targetScore;
@override final  DateTime? examDate;
@override@JsonKey() final  int dailyQuestions;
@override@JsonKey() final  int dailyWords;
@override@JsonKey() final  int dailyDictations;
/// Giờ nhắc học, dạng phút trong ngày (null = tắt nhắc)
@override final  int? reminderMinutes;

/// Create a copy of GoalSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GoalSettingsCopyWith<_GoalSettings> get copyWith => __$GoalSettingsCopyWithImpl<_GoalSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GoalSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoalSettings&&(identical(other.targetScore, targetScore) || other.targetScore == targetScore)&&(identical(other.examDate, examDate) || other.examDate == examDate)&&(identical(other.dailyQuestions, dailyQuestions) || other.dailyQuestions == dailyQuestions)&&(identical(other.dailyWords, dailyWords) || other.dailyWords == dailyWords)&&(identical(other.dailyDictations, dailyDictations) || other.dailyDictations == dailyDictations)&&(identical(other.reminderMinutes, reminderMinutes) || other.reminderMinutes == reminderMinutes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,targetScore,examDate,dailyQuestions,dailyWords,dailyDictations,reminderMinutes);
}

@override
String toString() {
    return 'GoalSettings(targetScore: $targetScore, examDate: $examDate, dailyQuestions: $dailyQuestions, dailyWords: $dailyWords, dailyDictations: $dailyDictations, reminderMinutes: $reminderMinutes)';
}


}

/// @nodoc
abstract mixin class _$GoalSettingsCopyWith<$Res> implements $GoalSettingsCopyWith<$Res> {
  factory _$GoalSettingsCopyWith(_GoalSettings value, $Res Function(_GoalSettings) _then) = __$GoalSettingsCopyWithImpl;
@override @useResult
$Res call({
 int? targetScore, DateTime? examDate, int dailyQuestions, int dailyWords, int dailyDictations, int? reminderMinutes
});




}
/// @nodoc
class __$GoalSettingsCopyWithImpl<$Res>
    implements _$GoalSettingsCopyWith<$Res> {
  __$GoalSettingsCopyWithImpl(this._self, this._then);

  final _GoalSettings _self;
  final $Res Function(_GoalSettings) _then;

/// Create a copy of GoalSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? targetScore = freezed,Object? examDate = freezed,Object? dailyQuestions = null,Object? dailyWords = null,Object? dailyDictations = null,Object? reminderMinutes = freezed,}) {
  return _then(_GoalSettings(
targetScore: freezed == targetScore ? _self.targetScore : targetScore // ignore: cast_nullable_to_non_nullable
as int?,examDate: freezed == examDate ? _self.examDate : examDate // ignore: cast_nullable_to_non_nullable
as DateTime?,dailyQuestions: null == dailyQuestions ? _self.dailyQuestions : dailyQuestions // ignore: cast_nullable_to_non_nullable
as int,dailyWords: null == dailyWords ? _self.dailyWords : dailyWords // ignore: cast_nullable_to_non_nullable
as int,dailyDictations: null == dailyDictations ? _self.dailyDictations : dailyDictations // ignore: cast_nullable_to_non_nullable
as int,reminderMinutes: freezed == reminderMinutes ? _self.reminderMinutes : reminderMinutes // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
