// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'duel_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DuelPlay {

 DuelState get match;/// Lệch giờ máy so với server (giờ server ≈ now + offset).
 Duration get offset; List<DuelQuestion> get questions;/// Câu đang làm (0-based); = số câu khi đã làm xong.
 int get index; String? get chosen; DuelAnswerResult? get feedback; DateTime? get questionStartedAt; bool get answering;
/// Create a copy of DuelPlay
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuelPlayCopyWith<DuelPlay> get copyWith => _$DuelPlayCopyWithImpl<DuelPlay>(this as DuelPlay, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as DuelPlay;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuelPlay&&(identical(other.match, _this.match) || other.match == _this.match)&&(identical(other.offset, _this.offset) || other.offset == _this.offset)&&const DeepCollectionEquality().equals(other.questions, _this.questions)&&(identical(other.index, _this.index) || other.index == _this.index)&&(identical(other.chosen, _this.chosen) || other.chosen == _this.chosen)&&(identical(other.feedback, _this.feedback) || other.feedback == _this.feedback)&&(identical(other.questionStartedAt, _this.questionStartedAt) || other.questionStartedAt == _this.questionStartedAt)&&(identical(other.answering, _this.answering) || other.answering == _this.answering));
}


@override
int get hashCode {
  final _this = this as DuelPlay;
  return Object.hash(runtimeType,_this.match,_this.offset,const DeepCollectionEquality().hash(_this.questions),_this.index,_this.chosen,_this.feedback,_this.questionStartedAt,_this.answering);
}

@override
String toString() {
  final _this = this as DuelPlay;
  return 'DuelPlay(match: ${_this.match}, offset: ${_this.offset}, questions: ${_this.questions}, index: ${_this.index}, chosen: ${_this.chosen}, feedback: ${_this.feedback}, questionStartedAt: ${_this.questionStartedAt}, answering: ${_this.answering})';
}


}

/// @nodoc
abstract mixin class $DuelPlayCopyWith<$Res>  {
  factory $DuelPlayCopyWith(DuelPlay value, $Res Function(DuelPlay) _then) = _$DuelPlayCopyWithImpl;
@useResult
$Res call({
 DuelState match, Duration offset, List<DuelQuestion> questions, int index, String? chosen, DuelAnswerResult? feedback, DateTime? questionStartedAt, bool answering
});


$DuelStateCopyWith<$Res> get match;$DuelAnswerResultCopyWith<$Res>? get feedback;

}
/// @nodoc
class _$DuelPlayCopyWithImpl<$Res>
    implements $DuelPlayCopyWith<$Res> {
  _$DuelPlayCopyWithImpl(this._self, this._then);

  final DuelPlay _self;
  final $Res Function(DuelPlay) _then;

/// Create a copy of DuelPlay
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? match = null,Object? offset = null,Object? questions = null,Object? index = null,Object? chosen = freezed,Object? feedback = freezed,Object? questionStartedAt = freezed,Object? answering = null,}) {
  return _then(DuelPlay(
match: null == match ? _self.match : match // ignore: cast_nullable_to_non_nullable
as DuelState,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as Duration,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<DuelQuestion>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,chosen: freezed == chosen ? _self.chosen : chosen // ignore: cast_nullable_to_non_nullable
as String?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as DuelAnswerResult?,questionStartedAt: freezed == questionStartedAt ? _self.questionStartedAt : questionStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,answering: null == answering ? _self.answering : answering // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of DuelPlay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuelStateCopyWith<$Res> get match {
  
  return $DuelStateCopyWith<$Res>(_self.match, (value) {
    return _then(_self.copyWith(match: value));
  });
}/// Create a copy of DuelPlay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuelAnswerResultCopyWith<$Res>? get feedback {
    if (_self.feedback == null) {
    return null;
  }

  return $DuelAnswerResultCopyWith<$Res>(_self.feedback!, (value) {
    return _then(_self.copyWith(feedback: value));
  });
}
}


/// Adds pattern-matching-related methods to [DuelPlay].
extension DuelPlayPatterns on DuelPlay {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuelPlay value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuelPlay() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuelPlay value)  $default,){
final _that = this;
switch (_that) {
case _DuelPlay():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuelPlay value)?  $default,){
final _that = this;
switch (_that) {
case _DuelPlay() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DuelState match,  Duration offset,  List<DuelQuestion> questions,  int index,  String? chosen,  DuelAnswerResult? feedback,  DateTime? questionStartedAt,  bool answering)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DuelPlay() when $default != null:
return $default(_that.match,_that.offset,_that.questions,_that.index,_that.chosen,_that.feedback,_that.questionStartedAt,_that.answering);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DuelState match,  Duration offset,  List<DuelQuestion> questions,  int index,  String? chosen,  DuelAnswerResult? feedback,  DateTime? questionStartedAt,  bool answering)  $default,) {final _that = this;
switch (_that) {
case _DuelPlay():
return $default(_that.match,_that.offset,_that.questions,_that.index,_that.chosen,_that.feedback,_that.questionStartedAt,_that.answering);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DuelState match,  Duration offset,  List<DuelQuestion> questions,  int index,  String? chosen,  DuelAnswerResult? feedback,  DateTime? questionStartedAt,  bool answering)?  $default,) {final _that = this;
switch (_that) {
case _DuelPlay() when $default != null:
return $default(_that.match,_that.offset,_that.questions,_that.index,_that.chosen,_that.feedback,_that.questionStartedAt,_that.answering);case _:
  return null;

}
}

}

/// @nodoc


class _DuelPlay extends DuelPlay {
  const _DuelPlay({required this.match, required this.offset,  List<DuelQuestion> questions = const <DuelQuestion>[], this.index = 0, this.chosen, this.feedback, this.questionStartedAt, this.answering = false}): _questions = questions,super._();
  

@override final  DuelState match;
/// Lệch giờ máy so với server (giờ server ≈ now + offset).
@override final  Duration offset;
 final  List<DuelQuestion> _questions;
@override@JsonKey() List<DuelQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

/// Câu đang làm (0-based); = số câu khi đã làm xong.
@override@JsonKey() final  int index;
@override final  String? chosen;
@override final  DuelAnswerResult? feedback;
@override final  DateTime? questionStartedAt;
@override@JsonKey() final  bool answering;

/// Create a copy of DuelPlay
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuelPlayCopyWith<_DuelPlay> get copyWith => __$DuelPlayCopyWithImpl<_DuelPlay>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuelPlay&&(identical(other.match, match) || other.match == match)&&(identical(other.offset, offset) || other.offset == offset)&&const DeepCollectionEquality().equals(other.questions, _questions)&&(identical(other.index, index) || other.index == index)&&(identical(other.chosen, chosen) || other.chosen == chosen)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.questionStartedAt, questionStartedAt) || other.questionStartedAt == questionStartedAt)&&(identical(other.answering, answering) || other.answering == answering));
}


@override
int get hashCode {
    return Object.hash(runtimeType,match,offset,const DeepCollectionEquality().hash(_questions),index,chosen,feedback,questionStartedAt,answering);
}

@override
String toString() {
    return 'DuelPlay(match: $match, offset: $offset, questions: $questions, index: $index, chosen: $chosen, feedback: $feedback, questionStartedAt: $questionStartedAt, answering: $answering)';
}


}

/// @nodoc
abstract mixin class _$DuelPlayCopyWith<$Res> implements $DuelPlayCopyWith<$Res> {
  factory _$DuelPlayCopyWith(_DuelPlay value, $Res Function(_DuelPlay) _then) = __$DuelPlayCopyWithImpl;
@override @useResult
$Res call({
 DuelState match, Duration offset, List<DuelQuestion> questions, int index, String? chosen, DuelAnswerResult? feedback, DateTime? questionStartedAt, bool answering
});


@override $DuelStateCopyWith<$Res> get match;@override $DuelAnswerResultCopyWith<$Res>? get feedback;

}
/// @nodoc
class __$DuelPlayCopyWithImpl<$Res>
    implements _$DuelPlayCopyWith<$Res> {
  __$DuelPlayCopyWithImpl(this._self, this._then);

  final _DuelPlay _self;
  final $Res Function(_DuelPlay) _then;

/// Create a copy of DuelPlay
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? match = null,Object? offset = null,Object? questions = null,Object? index = null,Object? chosen = freezed,Object? feedback = freezed,Object? questionStartedAt = freezed,Object? answering = null,}) {
  return _then(_DuelPlay(
match: null == match ? _self.match : match // ignore: cast_nullable_to_non_nullable
as DuelState,offset: null == offset ? _self.offset : offset // ignore: cast_nullable_to_non_nullable
as Duration,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<DuelQuestion>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,chosen: freezed == chosen ? _self.chosen : chosen // ignore: cast_nullable_to_non_nullable
as String?,feedback: freezed == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as DuelAnswerResult?,questionStartedAt: freezed == questionStartedAt ? _self.questionStartedAt : questionStartedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,answering: null == answering ? _self.answering : answering // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of DuelPlay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuelStateCopyWith<$Res> get match {
  
  return $DuelStateCopyWith<$Res>(_self.match, (value) {
    return _then(_self.copyWith(match: value));
  });
}/// Create a copy of DuelPlay
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuelAnswerResultCopyWith<$Res>? get feedback {
    if (_self.feedback == null) {
    return null;
  }

  return $DuelAnswerResultCopyWith<$Res>(_self.feedback!, (value) {
    return _then(_self.copyWith(feedback: value));
  });
}
}

// dart format on
