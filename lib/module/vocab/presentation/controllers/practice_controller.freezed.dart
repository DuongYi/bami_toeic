// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'practice_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PracticeState {

 List<PracticeQuestion> get questions; int get index;/// Đáp án đã chọn của câu hiện tại (null = chưa trả lời). Dạng gõ từ: 0 đúng / -1 sai.
 int? get picked;/// Chữ đã gõ (dạng gõ từ).
 String? get typed; int get correct; List<PracticeQuestion> get wrong;
/// Create a copy of PracticeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PracticeStateCopyWith<PracticeState> get copyWith => _$PracticeStateCopyWithImpl<PracticeState>(this as PracticeState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PracticeState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PracticeState&&const DeepCollectionEquality().equals(other.questions, _this.questions)&&(identical(other.index, _this.index) || other.index == _this.index)&&(identical(other.picked, _this.picked) || other.picked == _this.picked)&&(identical(other.typed, _this.typed) || other.typed == _this.typed)&&(identical(other.correct, _this.correct) || other.correct == _this.correct)&&const DeepCollectionEquality().equals(other.wrong, _this.wrong));
}


@override
int get hashCode {
  final _this = this as PracticeState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.questions),_this.index,_this.picked,_this.typed,_this.correct,const DeepCollectionEquality().hash(_this.wrong));
}

@override
String toString() {
  final _this = this as PracticeState;
  return 'PracticeState(questions: ${_this.questions}, index: ${_this.index}, picked: ${_this.picked}, typed: ${_this.typed}, correct: ${_this.correct}, wrong: ${_this.wrong})';
}


}

/// @nodoc
abstract mixin class $PracticeStateCopyWith<$Res>  {
  factory $PracticeStateCopyWith(PracticeState value, $Res Function(PracticeState) _then) = _$PracticeStateCopyWithImpl;
@useResult
$Res call({
 List<PracticeQuestion> questions, int index, int? picked, String? typed, int correct, List<PracticeQuestion> wrong
});




}
/// @nodoc
class _$PracticeStateCopyWithImpl<$Res>
    implements $PracticeStateCopyWith<$Res> {
  _$PracticeStateCopyWithImpl(this._self, this._then);

  final PracticeState _self;
  final $Res Function(PracticeState) _then;

/// Create a copy of PracticeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questions = null,Object? index = null,Object? picked = freezed,Object? typed = freezed,Object? correct = null,Object? wrong = null,}) {
  return _then(PracticeState(
questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<PracticeQuestion>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,picked: freezed == picked ? _self.picked : picked // ignore: cast_nullable_to_non_nullable
as int?,typed: freezed == typed ? _self.typed : typed // ignore: cast_nullable_to_non_nullable
as String?,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,wrong: null == wrong ? _self.wrong : wrong // ignore: cast_nullable_to_non_nullable
as List<PracticeQuestion>,
  ));
}

}


/// Adds pattern-matching-related methods to [PracticeState].
extension PracticeStatePatterns on PracticeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PracticeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PracticeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PracticeState value)  $default,){
final _that = this;
switch (_that) {
case _PracticeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PracticeState value)?  $default,){
final _that = this;
switch (_that) {
case _PracticeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<PracticeQuestion> questions,  int index,  int? picked,  String? typed,  int correct,  List<PracticeQuestion> wrong)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PracticeState() when $default != null:
return $default(_that.questions,_that.index,_that.picked,_that.typed,_that.correct,_that.wrong);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<PracticeQuestion> questions,  int index,  int? picked,  String? typed,  int correct,  List<PracticeQuestion> wrong)  $default,) {final _that = this;
switch (_that) {
case _PracticeState():
return $default(_that.questions,_that.index,_that.picked,_that.typed,_that.correct,_that.wrong);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<PracticeQuestion> questions,  int index,  int? picked,  String? typed,  int correct,  List<PracticeQuestion> wrong)?  $default,) {final _that = this;
switch (_that) {
case _PracticeState() when $default != null:
return $default(_that.questions,_that.index,_that.picked,_that.typed,_that.correct,_that.wrong);case _:
  return null;

}
}

}

/// @nodoc


class _PracticeState extends PracticeState {
  const _PracticeState({required  List<PracticeQuestion> questions, this.index = 0, this.picked, this.typed, this.correct = 0,  List<PracticeQuestion> wrong = const <PracticeQuestion>[]}): _questions = questions,_wrong = wrong,super._();
  

 final  List<PracticeQuestion> _questions;
@override List<PracticeQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}

@override@JsonKey() final  int index;
/// Đáp án đã chọn của câu hiện tại (null = chưa trả lời). Dạng gõ từ: 0 đúng / -1 sai.
@override final  int? picked;
/// Chữ đã gõ (dạng gõ từ).
@override final  String? typed;
@override@JsonKey() final  int correct;
 final  List<PracticeQuestion> _wrong;
@override@JsonKey() List<PracticeQuestion> get wrong {
  if (_wrong is EqualUnmodifiableListView) return _wrong;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wrong);
}


/// Create a copy of PracticeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PracticeStateCopyWith<_PracticeState> get copyWith => __$PracticeStateCopyWithImpl<_PracticeState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PracticeState&&const DeepCollectionEquality().equals(other.questions, _questions)&&(identical(other.index, index) || other.index == index)&&(identical(other.picked, picked) || other.picked == picked)&&(identical(other.typed, typed) || other.typed == typed)&&(identical(other.correct, correct) || other.correct == correct)&&const DeepCollectionEquality().equals(other.wrong, _wrong));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_questions),index,picked,typed,correct,const DeepCollectionEquality().hash(_wrong));
}

@override
String toString() {
    return 'PracticeState(questions: $questions, index: $index, picked: $picked, typed: $typed, correct: $correct, wrong: $wrong)';
}


}

/// @nodoc
abstract mixin class _$PracticeStateCopyWith<$Res> implements $PracticeStateCopyWith<$Res> {
  factory _$PracticeStateCopyWith(_PracticeState value, $Res Function(_PracticeState) _then) = __$PracticeStateCopyWithImpl;
@override @useResult
$Res call({
 List<PracticeQuestion> questions, int index, int? picked, String? typed, int correct, List<PracticeQuestion> wrong
});




}
/// @nodoc
class __$PracticeStateCopyWithImpl<$Res>
    implements _$PracticeStateCopyWith<$Res> {
  __$PracticeStateCopyWithImpl(this._self, this._then);

  final _PracticeState _self;
  final $Res Function(_PracticeState) _then;

/// Create a copy of PracticeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questions = null,Object? index = null,Object? picked = freezed,Object? typed = freezed,Object? correct = null,Object? wrong = null,}) {
  return _then(_PracticeState(
questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<PracticeQuestion>,index: null == index ? _self.index : index // ignore: cast_nullable_to_non_nullable
as int,picked: freezed == picked ? _self.picked : picked // ignore: cast_nullable_to_non_nullable
as int?,typed: freezed == typed ? _self.typed : typed // ignore: cast_nullable_to_non_nullable
as String?,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,wrong: null == wrong ? _self._wrong : wrong // ignore: cast_nullable_to_non_nullable
as List<PracticeQuestion>,
  ));
}


}

// dart format on
