// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'test_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TestSummary {

 String get id; String get title; String? get source; String? get description;/// Từ `questions(count)` → `[{"count": n}]`
@JsonKey(name: 'questions', fromJson: _readCount, includeToJson: false) int get questionCount;
/// Create a copy of TestSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestSummaryCopyWith<TestSummary> get copyWith => _$TestSummaryCopyWithImpl<TestSummary>(this as TestSummary, _$identity);

  /// Serializes this TestSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TestSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.description, _this.description) || other.description == _this.description)&&(identical(other.questionCount, _this.questionCount) || other.questionCount == _this.questionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TestSummary;
  return Object.hash(runtimeType,_this.id,_this.title,_this.source,_this.description,_this.questionCount);
}

@override
String toString() {
  final _this = this as TestSummary;
  return 'TestSummary(id: ${_this.id}, title: ${_this.title}, source: ${_this.source}, description: ${_this.description}, questionCount: ${_this.questionCount})';
}


}

/// @nodoc
abstract mixin class $TestSummaryCopyWith<$Res>  {
  factory $TestSummaryCopyWith(TestSummary value, $Res Function(TestSummary) _then) = _$TestSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? source, String? description,@JsonKey(name: 'questions', fromJson: _readCount, includeToJson: false) int questionCount
});




}
/// @nodoc
class _$TestSummaryCopyWithImpl<$Res>
    implements $TestSummaryCopyWith<$Res> {
  _$TestSummaryCopyWithImpl(this._self, this._then);

  final TestSummary _self;
  final $Res Function(TestSummary) _then;

/// Create a copy of TestSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? source = freezed,Object? description = freezed,Object? questionCount = null,}) {
  return _then(TestSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TestSummary].
extension TestSummaryPatterns on TestSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestSummary value)  $default,){
final _that = this;
switch (_that) {
case _TestSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestSummary value)?  $default,){
final _that = this;
switch (_that) {
case _TestSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? source,  String? description, @JsonKey(name: 'questions', fromJson: _readCount, includeToJson: false)  int questionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestSummary() when $default != null:
return $default(_that.id,_that.title,_that.source,_that.description,_that.questionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? source,  String? description, @JsonKey(name: 'questions', fromJson: _readCount, includeToJson: false)  int questionCount)  $default,) {final _that = this;
switch (_that) {
case _TestSummary():
return $default(_that.id,_that.title,_that.source,_that.description,_that.questionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? source,  String? description, @JsonKey(name: 'questions', fromJson: _readCount, includeToJson: false)  int questionCount)?  $default,) {final _that = this;
switch (_that) {
case _TestSummary() when $default != null:
return $default(_that.id,_that.title,_that.source,_that.description,_that.questionCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TestSummary implements TestSummary {
  const _TestSummary({required this.id, required this.title, this.source, this.description, @JsonKey(name: 'questions', fromJson: _readCount, includeToJson: false) this.questionCount = 0});
  factory _TestSummary.fromJson(Map<String, dynamic> json) => _$TestSummaryFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? source;
@override final  String? description;
/// Từ `questions(count)` → `[{"count": n}]`
@override@JsonKey(name: 'questions', fromJson: _readCount, includeToJson: false) final  int questionCount;

/// Create a copy of TestSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestSummaryCopyWith<_TestSummary> get copyWith => __$TestSummaryCopyWithImpl<_TestSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TestSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.source, source) || other.source == source)&&(identical(other.description, description) || other.description == description)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,source,description,questionCount);
}

@override
String toString() {
    return 'TestSummary(id: $id, title: $title, source: $source, description: $description, questionCount: $questionCount)';
}


}

/// @nodoc
abstract mixin class _$TestSummaryCopyWith<$Res> implements $TestSummaryCopyWith<$Res> {
  factory _$TestSummaryCopyWith(_TestSummary value, $Res Function(_TestSummary) _then) = __$TestSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? source, String? description,@JsonKey(name: 'questions', fromJson: _readCount, includeToJson: false) int questionCount
});




}
/// @nodoc
class __$TestSummaryCopyWithImpl<$Res>
    implements _$TestSummaryCopyWith<$Res> {
  __$TestSummaryCopyWithImpl(this._self, this._then);

  final _TestSummary _self;
  final $Res Function(_TestSummary) _then;

/// Create a copy of TestSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? source = freezed,Object? description = freezed,Object? questionCount = null,}) {
  return _then(_TestSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$Question {

 String get id; int get part; int get number; String? get content; List<String> get options; String get answer; String? get explanation; List<String> get tags;
/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionCopyWith<Question> get copyWith => _$QuestionCopyWithImpl<Question>(this as Question, _$identity);

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Question;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Question&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.part, _this.part) || other.part == _this.part)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.content, _this.content) || other.content == _this.content)&&const DeepCollectionEquality().equals(other.options, _this.options)&&(identical(other.answer, _this.answer) || other.answer == _this.answer)&&(identical(other.explanation, _this.explanation) || other.explanation == _this.explanation)&&const DeepCollectionEquality().equals(other.tags, _this.tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Question;
  return Object.hash(runtimeType,_this.id,_this.part,_this.number,_this.content,const DeepCollectionEquality().hash(_this.options),_this.answer,_this.explanation,const DeepCollectionEquality().hash(_this.tags));
}

@override
String toString() {
  final _this = this as Question;
  return 'Question(id: ${_this.id}, part: ${_this.part}, number: ${_this.number}, content: ${_this.content}, options: ${_this.options}, answer: ${_this.answer}, explanation: ${_this.explanation}, tags: ${_this.tags})';
}


}

/// @nodoc
abstract mixin class $QuestionCopyWith<$Res>  {
  factory $QuestionCopyWith(Question value, $Res Function(Question) _then) = _$QuestionCopyWithImpl;
@useResult
$Res call({
 String id, int part, int number, String? content, List<String> options, String answer, String? explanation, List<String> tags
});




}
/// @nodoc
class _$QuestionCopyWithImpl<$Res>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._self, this._then);

  final Question _self;
  final $Res Function(Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? part = null,Object? number = null,Object? content = freezed,Object? options = null,Object? answer = null,Object? explanation = freezed,Object? tags = null,}) {
  return _then(Question(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Question].
extension QuestionPatterns on Question {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Question value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Question value)  $default,){
final _that = this;
switch (_that) {
case _Question():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Question value)?  $default,){
final _that = this;
switch (_that) {
case _Question() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int part,  int number,  String? content,  List<String> options,  String answer,  String? explanation,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.part,_that.number,_that.content,_that.options,_that.answer,_that.explanation,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int part,  int number,  String? content,  List<String> options,  String answer,  String? explanation,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _Question():
return $default(_that.id,_that.part,_that.number,_that.content,_that.options,_that.answer,_that.explanation,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int part,  int number,  String? content,  List<String> options,  String answer,  String? explanation,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _Question() when $default != null:
return $default(_that.id,_that.part,_that.number,_that.content,_that.options,_that.answer,_that.explanation,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Question extends Question {
  const _Question({required this.id, required this.part, required this.number, this.content,  List<String> options = const <String>[], required this.answer, this.explanation,  List<String> tags = const <String>[]}): _options = options,_tags = tags,super._();
  factory _Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

@override final  String id;
@override final  int part;
@override final  int number;
@override final  String? content;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  String answer;
@override final  String? explanation;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionCopyWith<_Question> get copyWith => __$QuestionCopyWithImpl<_Question>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Question&&(identical(other.id, id) || other.id == id)&&(identical(other.part, part) || other.part == part)&&(identical(other.number, number) || other.number == number)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.options, _options)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&const DeepCollectionEquality().equals(other.tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,part,number,content,const DeepCollectionEquality().hash(_options),answer,explanation,const DeepCollectionEquality().hash(_tags));
}

@override
String toString() {
    return 'Question(id: $id, part: $part, number: $number, content: $content, options: $options, answer: $answer, explanation: $explanation, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$QuestionCopyWith<$Res> implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) _then) = __$QuestionCopyWithImpl;
@override @useResult
$Res call({
 String id, int part, int number, String? content, List<String> options, String answer, String? explanation, List<String> tags
});




}
/// @nodoc
class __$QuestionCopyWithImpl<$Res>
    implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(this._self, this._then);

  final _Question _self;
  final $Res Function(_Question) _then;

/// Create a copy of Question
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? part = null,Object? number = null,Object? content = freezed,Object? options = null,Object? answer = null,Object? explanation = freezed,Object? tags = null,}) {
  return _then(_Question(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$QuestionGroup {

 String get id; String? get testId; int get part; int get orderNo; String? get passage; String? get imageUrl; String? get audioUrl; String? get transcript; List<Question> get questions;
/// Create a copy of QuestionGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionGroupCopyWith<QuestionGroup> get copyWith => _$QuestionGroupCopyWithImpl<QuestionGroup>(this as QuestionGroup, _$identity);

  /// Serializes this QuestionGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as QuestionGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionGroup&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.testId, _this.testId) || other.testId == _this.testId)&&(identical(other.part, _this.part) || other.part == _this.part)&&(identical(other.orderNo, _this.orderNo) || other.orderNo == _this.orderNo)&&(identical(other.passage, _this.passage) || other.passage == _this.passage)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.audioUrl, _this.audioUrl) || other.audioUrl == _this.audioUrl)&&(identical(other.transcript, _this.transcript) || other.transcript == _this.transcript)&&const DeepCollectionEquality().equals(other.questions, _this.questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as QuestionGroup;
  return Object.hash(runtimeType,_this.id,_this.testId,_this.part,_this.orderNo,_this.passage,_this.imageUrl,_this.audioUrl,_this.transcript,const DeepCollectionEquality().hash(_this.questions));
}

@override
String toString() {
  final _this = this as QuestionGroup;
  return 'QuestionGroup(id: ${_this.id}, testId: ${_this.testId}, part: ${_this.part}, orderNo: ${_this.orderNo}, passage: ${_this.passage}, imageUrl: ${_this.imageUrl}, audioUrl: ${_this.audioUrl}, transcript: ${_this.transcript}, questions: ${_this.questions})';
}


}

/// @nodoc
abstract mixin class $QuestionGroupCopyWith<$Res>  {
  factory $QuestionGroupCopyWith(QuestionGroup value, $Res Function(QuestionGroup) _then) = _$QuestionGroupCopyWithImpl;
@useResult
$Res call({
 String id, String? testId, int part, int orderNo, String? passage, String? imageUrl, String? audioUrl, String? transcript, List<Question> questions
});




}
/// @nodoc
class _$QuestionGroupCopyWithImpl<$Res>
    implements $QuestionGroupCopyWith<$Res> {
  _$QuestionGroupCopyWithImpl(this._self, this._then);

  final QuestionGroup _self;
  final $Res Function(QuestionGroup) _then;

/// Create a copy of QuestionGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? testId = freezed,Object? part = null,Object? orderNo = null,Object? passage = freezed,Object? imageUrl = freezed,Object? audioUrl = freezed,Object? transcript = freezed,Object? questions = null,}) {
  return _then(QuestionGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,testId: freezed == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String?,part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,orderNo: null == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as int,passage: freezed == passage ? _self.passage : passage // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,transcript: freezed == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionGroup].
extension QuestionGroupPatterns on QuestionGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionGroup value)  $default,){
final _that = this;
switch (_that) {
case _QuestionGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionGroup value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? testId,  int part,  int orderNo,  String? passage,  String? imageUrl,  String? audioUrl,  String? transcript,  List<Question> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionGroup() when $default != null:
return $default(_that.id,_that.testId,_that.part,_that.orderNo,_that.passage,_that.imageUrl,_that.audioUrl,_that.transcript,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? testId,  int part,  int orderNo,  String? passage,  String? imageUrl,  String? audioUrl,  String? transcript,  List<Question> questions)  $default,) {final _that = this;
switch (_that) {
case _QuestionGroup():
return $default(_that.id,_that.testId,_that.part,_that.orderNo,_that.passage,_that.imageUrl,_that.audioUrl,_that.transcript,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? testId,  int part,  int orderNo,  String? passage,  String? imageUrl,  String? audioUrl,  String? transcript,  List<Question> questions)?  $default,) {final _that = this;
switch (_that) {
case _QuestionGroup() when $default != null:
return $default(_that.id,_that.testId,_that.part,_that.orderNo,_that.passage,_that.imageUrl,_that.audioUrl,_that.transcript,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionGroup implements QuestionGroup {
  const _QuestionGroup({required this.id, this.testId, required this.part, required this.orderNo, this.passage, this.imageUrl, this.audioUrl, this.transcript,  List<Question> questions = const <Question>[]}): _questions = questions;
  factory _QuestionGroup.fromJson(Map<String, dynamic> json) => _$QuestionGroupFromJson(json);

@override final  String id;
@override final  String? testId;
@override final  int part;
@override final  int orderNo;
@override final  String? passage;
@override final  String? imageUrl;
@override final  String? audioUrl;
@override final  String? transcript;
 final  List<Question> _questions;
@override@JsonKey() List<Question> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of QuestionGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionGroupCopyWith<_QuestionGroup> get copyWith => __$QuestionGroupCopyWithImpl<_QuestionGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionGroupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.part, part) || other.part == part)&&(identical(other.orderNo, orderNo) || other.orderNo == orderNo)&&(identical(other.passage, passage) || other.passage == passage)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&const DeepCollectionEquality().equals(other.questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,testId,part,orderNo,passage,imageUrl,audioUrl,transcript,const DeepCollectionEquality().hash(_questions));
}

@override
String toString() {
    return 'QuestionGroup(id: $id, testId: $testId, part: $part, orderNo: $orderNo, passage: $passage, imageUrl: $imageUrl, audioUrl: $audioUrl, transcript: $transcript, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$QuestionGroupCopyWith<$Res> implements $QuestionGroupCopyWith<$Res> {
  factory _$QuestionGroupCopyWith(_QuestionGroup value, $Res Function(_QuestionGroup) _then) = __$QuestionGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String? testId, int part, int orderNo, String? passage, String? imageUrl, String? audioUrl, String? transcript, List<Question> questions
});




}
/// @nodoc
class __$QuestionGroupCopyWithImpl<$Res>
    implements _$QuestionGroupCopyWith<$Res> {
  __$QuestionGroupCopyWithImpl(this._self, this._then);

  final _QuestionGroup _self;
  final $Res Function(_QuestionGroup) _then;

/// Create a copy of QuestionGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? testId = freezed,Object? part = null,Object? orderNo = null,Object? passage = freezed,Object? imageUrl = freezed,Object? audioUrl = freezed,Object? transcript = freezed,Object? questions = null,}) {
  return _then(_QuestionGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,testId: freezed == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String?,part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,orderNo: null == orderNo ? _self.orderNo : orderNo // ignore: cast_nullable_to_non_nullable
as int,passage: freezed == passage ? _self.passage : passage // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,transcript: freezed == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<Question>,
  ));
}


}


/// @nodoc
mixin _$Attempt {

 String get id; String get testId;/// Từ `tests(title)` → `{"title": "..."}`
@JsonKey(name: 'tests', fromJson: _readTitle, includeToJson: false) String get testTitle;/// Từ `tests(score_table)` – bảng quy đổi riêng của đề (nếu có)
@JsonKey(name: 'tests', fromJson: _readScoreTable, includeToJson: false) ScoreTable? get scoreTable; String get mode; List<int> get parts; DateTime get startedAt; DateTime get finishedAt; int get totalQuestions; int get listeningCorrect; int get readingCorrect;/// 'test' = làm đề, 'mistakes' = luyện lại sổ câu sai
 String get source;
/// Create a copy of Attempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttemptCopyWith<Attempt> get copyWith => _$AttemptCopyWithImpl<Attempt>(this as Attempt, _$identity);

  /// Serializes this Attempt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Attempt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Attempt&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.testId, _this.testId) || other.testId == _this.testId)&&(identical(other.testTitle, _this.testTitle) || other.testTitle == _this.testTitle)&&(identical(other.scoreTable, _this.scoreTable) || other.scoreTable == _this.scoreTable)&&(identical(other.mode, _this.mode) || other.mode == _this.mode)&&const DeepCollectionEquality().equals(other.parts, _this.parts)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.finishedAt, _this.finishedAt) || other.finishedAt == _this.finishedAt)&&(identical(other.totalQuestions, _this.totalQuestions) || other.totalQuestions == _this.totalQuestions)&&(identical(other.listeningCorrect, _this.listeningCorrect) || other.listeningCorrect == _this.listeningCorrect)&&(identical(other.readingCorrect, _this.readingCorrect) || other.readingCorrect == _this.readingCorrect)&&(identical(other.source, _this.source) || other.source == _this.source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Attempt;
  return Object.hash(runtimeType,_this.id,_this.testId,_this.testTitle,_this.scoreTable,_this.mode,const DeepCollectionEquality().hash(_this.parts),_this.startedAt,_this.finishedAt,_this.totalQuestions,_this.listeningCorrect,_this.readingCorrect,_this.source);
}

@override
String toString() {
  final _this = this as Attempt;
  return 'Attempt(id: ${_this.id}, testId: ${_this.testId}, testTitle: ${_this.testTitle}, scoreTable: ${_this.scoreTable}, mode: ${_this.mode}, parts: ${_this.parts}, startedAt: ${_this.startedAt}, finishedAt: ${_this.finishedAt}, totalQuestions: ${_this.totalQuestions}, listeningCorrect: ${_this.listeningCorrect}, readingCorrect: ${_this.readingCorrect}, source: ${_this.source})';
}


}

/// @nodoc
abstract mixin class $AttemptCopyWith<$Res>  {
  factory $AttemptCopyWith(Attempt value, $Res Function(Attempt) _then) = _$AttemptCopyWithImpl;
@useResult
$Res call({
 String id, String testId,@JsonKey(name: 'tests', fromJson: _readTitle, includeToJson: false) String testTitle,@JsonKey(name: 'tests', fromJson: _readScoreTable, includeToJson: false) ScoreTable? scoreTable, String mode, List<int> parts, DateTime startedAt, DateTime finishedAt, int totalQuestions, int listeningCorrect, int readingCorrect, String source
});




}
/// @nodoc
class _$AttemptCopyWithImpl<$Res>
    implements $AttemptCopyWith<$Res> {
  _$AttemptCopyWithImpl(this._self, this._then);

  final Attempt _self;
  final $Res Function(Attempt) _then;

/// Create a copy of Attempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? testId = null,Object? testTitle = null,Object? scoreTable = freezed,Object? mode = null,Object? parts = null,Object? startedAt = null,Object? finishedAt = null,Object? totalQuestions = null,Object? listeningCorrect = null,Object? readingCorrect = null,Object? source = null,}) {
  return _then(Attempt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,testTitle: null == testTitle ? _self.testTitle : testTitle // ignore: cast_nullable_to_non_nullable
as String,scoreTable: freezed == scoreTable ? _self.scoreTable : scoreTable // ignore: cast_nullable_to_non_nullable
as ScoreTable?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,listeningCorrect: null == listeningCorrect ? _self.listeningCorrect : listeningCorrect // ignore: cast_nullable_to_non_nullable
as int,readingCorrect: null == readingCorrect ? _self.readingCorrect : readingCorrect // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Attempt].
extension AttemptPatterns on Attempt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Attempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Attempt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Attempt value)  $default,){
final _that = this;
switch (_that) {
case _Attempt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Attempt value)?  $default,){
final _that = this;
switch (_that) {
case _Attempt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String testId, @JsonKey(name: 'tests', fromJson: _readTitle, includeToJson: false)  String testTitle, @JsonKey(name: 'tests', fromJson: _readScoreTable, includeToJson: false)  ScoreTable? scoreTable,  String mode,  List<int> parts,  DateTime startedAt,  DateTime finishedAt,  int totalQuestions,  int listeningCorrect,  int readingCorrect,  String source)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Attempt() when $default != null:
return $default(_that.id,_that.testId,_that.testTitle,_that.scoreTable,_that.mode,_that.parts,_that.startedAt,_that.finishedAt,_that.totalQuestions,_that.listeningCorrect,_that.readingCorrect,_that.source);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String testId, @JsonKey(name: 'tests', fromJson: _readTitle, includeToJson: false)  String testTitle, @JsonKey(name: 'tests', fromJson: _readScoreTable, includeToJson: false)  ScoreTable? scoreTable,  String mode,  List<int> parts,  DateTime startedAt,  DateTime finishedAt,  int totalQuestions,  int listeningCorrect,  int readingCorrect,  String source)  $default,) {final _that = this;
switch (_that) {
case _Attempt():
return $default(_that.id,_that.testId,_that.testTitle,_that.scoreTable,_that.mode,_that.parts,_that.startedAt,_that.finishedAt,_that.totalQuestions,_that.listeningCorrect,_that.readingCorrect,_that.source);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String testId, @JsonKey(name: 'tests', fromJson: _readTitle, includeToJson: false)  String testTitle, @JsonKey(name: 'tests', fromJson: _readScoreTable, includeToJson: false)  ScoreTable? scoreTable,  String mode,  List<int> parts,  DateTime startedAt,  DateTime finishedAt,  int totalQuestions,  int listeningCorrect,  int readingCorrect,  String source)?  $default,) {final _that = this;
switch (_that) {
case _Attempt() when $default != null:
return $default(_that.id,_that.testId,_that.testTitle,_that.scoreTable,_that.mode,_that.parts,_that.startedAt,_that.finishedAt,_that.totalQuestions,_that.listeningCorrect,_that.readingCorrect,_that.source);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Attempt extends Attempt {
  const _Attempt({required this.id, required this.testId, @JsonKey(name: 'tests', fromJson: _readTitle, includeToJson: false) this.testTitle = '', @JsonKey(name: 'tests', fromJson: _readScoreTable, includeToJson: false) this.scoreTable, required this.mode, required  List<int> parts, required this.startedAt, required this.finishedAt, required this.totalQuestions, required this.listeningCorrect, required this.readingCorrect, this.source = 'test'}): _parts = parts,super._();
  factory _Attempt.fromJson(Map<String, dynamic> json) => _$AttemptFromJson(json);

@override final  String id;
@override final  String testId;
/// Từ `tests(title)` → `{"title": "..."}`
@override@JsonKey(name: 'tests', fromJson: _readTitle, includeToJson: false) final  String testTitle;
/// Từ `tests(score_table)` – bảng quy đổi riêng của đề (nếu có)
@override@JsonKey(name: 'tests', fromJson: _readScoreTable, includeToJson: false) final  ScoreTable? scoreTable;
@override final  String mode;
 final  List<int> _parts;
@override List<int> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

@override final  DateTime startedAt;
@override final  DateTime finishedAt;
@override final  int totalQuestions;
@override final  int listeningCorrect;
@override final  int readingCorrect;
/// 'test' = làm đề, 'mistakes' = luyện lại sổ câu sai
@override@JsonKey() final  String source;

/// Create a copy of Attempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttemptCopyWith<_Attempt> get copyWith => __$AttemptCopyWithImpl<_Attempt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttemptToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Attempt&&(identical(other.id, id) || other.id == id)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.testTitle, testTitle) || other.testTitle == testTitle)&&(identical(other.scoreTable, scoreTable) || other.scoreTable == scoreTable)&&(identical(other.mode, mode) || other.mode == mode)&&const DeepCollectionEquality().equals(other.parts, _parts)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&(identical(other.totalQuestions, totalQuestions) || other.totalQuestions == totalQuestions)&&(identical(other.listeningCorrect, listeningCorrect) || other.listeningCorrect == listeningCorrect)&&(identical(other.readingCorrect, readingCorrect) || other.readingCorrect == readingCorrect)&&(identical(other.source, source) || other.source == source));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,testId,testTitle,scoreTable,mode,const DeepCollectionEquality().hash(_parts),startedAt,finishedAt,totalQuestions,listeningCorrect,readingCorrect,source);
}

@override
String toString() {
    return 'Attempt(id: $id, testId: $testId, testTitle: $testTitle, scoreTable: $scoreTable, mode: $mode, parts: $parts, startedAt: $startedAt, finishedAt: $finishedAt, totalQuestions: $totalQuestions, listeningCorrect: $listeningCorrect, readingCorrect: $readingCorrect, source: $source)';
}


}

/// @nodoc
abstract mixin class _$AttemptCopyWith<$Res> implements $AttemptCopyWith<$Res> {
  factory _$AttemptCopyWith(_Attempt value, $Res Function(_Attempt) _then) = __$AttemptCopyWithImpl;
@override @useResult
$Res call({
 String id, String testId,@JsonKey(name: 'tests', fromJson: _readTitle, includeToJson: false) String testTitle,@JsonKey(name: 'tests', fromJson: _readScoreTable, includeToJson: false) ScoreTable? scoreTable, String mode, List<int> parts, DateTime startedAt, DateTime finishedAt, int totalQuestions, int listeningCorrect, int readingCorrect, String source
});




}
/// @nodoc
class __$AttemptCopyWithImpl<$Res>
    implements _$AttemptCopyWith<$Res> {
  __$AttemptCopyWithImpl(this._self, this._then);

  final _Attempt _self;
  final $Res Function(_Attempt) _then;

/// Create a copy of Attempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? testId = null,Object? testTitle = null,Object? scoreTable = freezed,Object? mode = null,Object? parts = null,Object? startedAt = null,Object? finishedAt = null,Object? totalQuestions = null,Object? listeningCorrect = null,Object? readingCorrect = null,Object? source = null,}) {
  return _then(_Attempt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,testTitle: null == testTitle ? _self.testTitle : testTitle // ignore: cast_nullable_to_non_nullable
as String,scoreTable: freezed == scoreTable ? _self.scoreTable : scoreTable // ignore: cast_nullable_to_non_nullable
as ScoreTable?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as String,parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<int>,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalQuestions: null == totalQuestions ? _self.totalQuestions : totalQuestions // ignore: cast_nullable_to_non_nullable
as int,listeningCorrect: null == listeningCorrect ? _self.listeningCorrect : listeningCorrect // ignore: cast_nullable_to_non_nullable
as int,readingCorrect: null == readingCorrect ? _self.readingCorrect : readingCorrect // ignore: cast_nullable_to_non_nullable
as int,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AttemptAnswer {

 String get questionId; String? get chosen;
/// Create a copy of AttemptAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttemptAnswerCopyWith<AttemptAnswer> get copyWith => _$AttemptAnswerCopyWithImpl<AttemptAnswer>(this as AttemptAnswer, _$identity);

  /// Serializes this AttemptAnswer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AttemptAnswer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttemptAnswer&&(identical(other.questionId, _this.questionId) || other.questionId == _this.questionId)&&(identical(other.chosen, _this.chosen) || other.chosen == _this.chosen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AttemptAnswer;
  return Object.hash(runtimeType,_this.questionId,_this.chosen);
}

@override
String toString() {
  final _this = this as AttemptAnswer;
  return 'AttemptAnswer(questionId: ${_this.questionId}, chosen: ${_this.chosen})';
}


}

/// @nodoc
abstract mixin class $AttemptAnswerCopyWith<$Res>  {
  factory $AttemptAnswerCopyWith(AttemptAnswer value, $Res Function(AttemptAnswer) _then) = _$AttemptAnswerCopyWithImpl;
@useResult
$Res call({
 String questionId, String? chosen
});




}
/// @nodoc
class _$AttemptAnswerCopyWithImpl<$Res>
    implements $AttemptAnswerCopyWith<$Res> {
  _$AttemptAnswerCopyWithImpl(this._self, this._then);

  final AttemptAnswer _self;
  final $Res Function(AttemptAnswer) _then;

/// Create a copy of AttemptAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? chosen = freezed,}) {
  return _then(AttemptAnswer(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,chosen: freezed == chosen ? _self.chosen : chosen // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [AttemptAnswer].
extension AttemptAnswerPatterns on AttemptAnswer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttemptAnswer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttemptAnswer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttemptAnswer value)  $default,){
final _that = this;
switch (_that) {
case _AttemptAnswer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttemptAnswer value)?  $default,){
final _that = this;
switch (_that) {
case _AttemptAnswer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String questionId,  String? chosen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttemptAnswer() when $default != null:
return $default(_that.questionId,_that.chosen);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String questionId,  String? chosen)  $default,) {final _that = this;
switch (_that) {
case _AttemptAnswer():
return $default(_that.questionId,_that.chosen);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String questionId,  String? chosen)?  $default,) {final _that = this;
switch (_that) {
case _AttemptAnswer() when $default != null:
return $default(_that.questionId,_that.chosen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttemptAnswer implements AttemptAnswer {
  const _AttemptAnswer({required this.questionId, this.chosen});
  factory _AttemptAnswer.fromJson(Map<String, dynamic> json) => _$AttemptAnswerFromJson(json);

@override final  String questionId;
@override final  String? chosen;

/// Create a copy of AttemptAnswer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttemptAnswerCopyWith<_AttemptAnswer> get copyWith => __$AttemptAnswerCopyWithImpl<_AttemptAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttemptAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttemptAnswer&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.chosen, chosen) || other.chosen == chosen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,questionId,chosen);
}

@override
String toString() {
    return 'AttemptAnswer(questionId: $questionId, chosen: $chosen)';
}


}

/// @nodoc
abstract mixin class _$AttemptAnswerCopyWith<$Res> implements $AttemptAnswerCopyWith<$Res> {
  factory _$AttemptAnswerCopyWith(_AttemptAnswer value, $Res Function(_AttemptAnswer) _then) = __$AttemptAnswerCopyWithImpl;
@override @useResult
$Res call({
 String questionId, String? chosen
});




}
/// @nodoc
class __$AttemptAnswerCopyWithImpl<$Res>
    implements _$AttemptAnswerCopyWith<$Res> {
  __$AttemptAnswerCopyWithImpl(this._self, this._then);

  final _AttemptAnswer _self;
  final $Res Function(_AttemptAnswer) _then;

/// Create a copy of AttemptAnswer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? chosen = freezed,}) {
  return _then(_AttemptAnswer(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,chosen: freezed == chosen ? _self.chosen : chosen // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$PartStat {

 int get part; int get total; int get correct;
/// Create a copy of PartStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartStatCopyWith<PartStat> get copyWith => _$PartStatCopyWithImpl<PartStat>(this as PartStat, _$identity);

  /// Serializes this PartStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PartStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartStat&&(identical(other.part, _this.part) || other.part == _this.part)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.correct, _this.correct) || other.correct == _this.correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PartStat;
  return Object.hash(runtimeType,_this.part,_this.total,_this.correct);
}

@override
String toString() {
  final _this = this as PartStat;
  return 'PartStat(part: ${_this.part}, total: ${_this.total}, correct: ${_this.correct})';
}


}

/// @nodoc
abstract mixin class $PartStatCopyWith<$Res>  {
  factory $PartStatCopyWith(PartStat value, $Res Function(PartStat) _then) = _$PartStatCopyWithImpl;
@useResult
$Res call({
 int part, int total, int correct
});




}
/// @nodoc
class _$PartStatCopyWithImpl<$Res>
    implements $PartStatCopyWith<$Res> {
  _$PartStatCopyWithImpl(this._self, this._then);

  final PartStat _self;
  final $Res Function(PartStat) _then;

/// Create a copy of PartStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? part = null,Object? total = null,Object? correct = null,}) {
  return _then(PartStat(
part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PartStat].
extension PartStatPatterns on PartStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartStat value)  $default,){
final _that = this;
switch (_that) {
case _PartStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartStat value)?  $default,){
final _that = this;
switch (_that) {
case _PartStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int part,  int total,  int correct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartStat() when $default != null:
return $default(_that.part,_that.total,_that.correct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int part,  int total,  int correct)  $default,) {final _that = this;
switch (_that) {
case _PartStat():
return $default(_that.part,_that.total,_that.correct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int part,  int total,  int correct)?  $default,) {final _that = this;
switch (_that) {
case _PartStat() when $default != null:
return $default(_that.part,_that.total,_that.correct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartStat extends PartStat {
  const _PartStat({required this.part, required this.total, required this.correct}): super._();
  factory _PartStat.fromJson(Map<String, dynamic> json) => _$PartStatFromJson(json);

@override final  int part;
@override final  int total;
@override final  int correct;

/// Create a copy of PartStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartStatCopyWith<_PartStat> get copyWith => __$PartStatCopyWithImpl<_PartStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartStatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartStat&&(identical(other.part, part) || other.part == part)&&(identical(other.total, total) || other.total == total)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,part,total,correct);
}

@override
String toString() {
    return 'PartStat(part: $part, total: $total, correct: $correct)';
}


}

/// @nodoc
abstract mixin class _$PartStatCopyWith<$Res> implements $PartStatCopyWith<$Res> {
  factory _$PartStatCopyWith(_PartStat value, $Res Function(_PartStat) _then) = __$PartStatCopyWithImpl;
@override @useResult
$Res call({
 int part, int total, int correct
});




}
/// @nodoc
class __$PartStatCopyWithImpl<$Res>
    implements _$PartStatCopyWith<$Res> {
  __$PartStatCopyWithImpl(this._self, this._then);

  final _PartStat _self;
  final $Res Function(_PartStat) _then;

/// Create a copy of PartStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? part = null,Object? total = null,Object? correct = null,}) {
  return _then(_PartStat(
part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$LatestAnswer {

 String get questionId; String get groupId; String get testId; int get part; int get number; String? get chosen; bool get isCorrect; DateTime get finishedAt; List<String> get tags;
/// Create a copy of LatestAnswer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LatestAnswerCopyWith<LatestAnswer> get copyWith => _$LatestAnswerCopyWithImpl<LatestAnswer>(this as LatestAnswer, _$identity);

  /// Serializes this LatestAnswer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LatestAnswer;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LatestAnswer&&(identical(other.questionId, _this.questionId) || other.questionId == _this.questionId)&&(identical(other.groupId, _this.groupId) || other.groupId == _this.groupId)&&(identical(other.testId, _this.testId) || other.testId == _this.testId)&&(identical(other.part, _this.part) || other.part == _this.part)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.chosen, _this.chosen) || other.chosen == _this.chosen)&&(identical(other.isCorrect, _this.isCorrect) || other.isCorrect == _this.isCorrect)&&(identical(other.finishedAt, _this.finishedAt) || other.finishedAt == _this.finishedAt)&&const DeepCollectionEquality().equals(other.tags, _this.tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LatestAnswer;
  return Object.hash(runtimeType,_this.questionId,_this.groupId,_this.testId,_this.part,_this.number,_this.chosen,_this.isCorrect,_this.finishedAt,const DeepCollectionEquality().hash(_this.tags));
}

@override
String toString() {
  final _this = this as LatestAnswer;
  return 'LatestAnswer(questionId: ${_this.questionId}, groupId: ${_this.groupId}, testId: ${_this.testId}, part: ${_this.part}, number: ${_this.number}, chosen: ${_this.chosen}, isCorrect: ${_this.isCorrect}, finishedAt: ${_this.finishedAt}, tags: ${_this.tags})';
}


}

/// @nodoc
abstract mixin class $LatestAnswerCopyWith<$Res>  {
  factory $LatestAnswerCopyWith(LatestAnswer value, $Res Function(LatestAnswer) _then) = _$LatestAnswerCopyWithImpl;
@useResult
$Res call({
 String questionId, String groupId, String testId, int part, int number, String? chosen, bool isCorrect, DateTime finishedAt, List<String> tags
});




}
/// @nodoc
class _$LatestAnswerCopyWithImpl<$Res>
    implements $LatestAnswerCopyWith<$Res> {
  _$LatestAnswerCopyWithImpl(this._self, this._then);

  final LatestAnswer _self;
  final $Res Function(LatestAnswer) _then;

/// Create a copy of LatestAnswer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questionId = null,Object? groupId = null,Object? testId = null,Object? part = null,Object? number = null,Object? chosen = freezed,Object? isCorrect = null,Object? finishedAt = null,Object? tags = null,}) {
  return _then(LatestAnswer(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,chosen: freezed == chosen ? _self.chosen : chosen // ignore: cast_nullable_to_non_nullable
as String?,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [LatestAnswer].
extension LatestAnswerPatterns on LatestAnswer {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LatestAnswer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LatestAnswer() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LatestAnswer value)  $default,){
final _that = this;
switch (_that) {
case _LatestAnswer():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LatestAnswer value)?  $default,){
final _that = this;
switch (_that) {
case _LatestAnswer() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String questionId,  String groupId,  String testId,  int part,  int number,  String? chosen,  bool isCorrect,  DateTime finishedAt,  List<String> tags)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LatestAnswer() when $default != null:
return $default(_that.questionId,_that.groupId,_that.testId,_that.part,_that.number,_that.chosen,_that.isCorrect,_that.finishedAt,_that.tags);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String questionId,  String groupId,  String testId,  int part,  int number,  String? chosen,  bool isCorrect,  DateTime finishedAt,  List<String> tags)  $default,) {final _that = this;
switch (_that) {
case _LatestAnswer():
return $default(_that.questionId,_that.groupId,_that.testId,_that.part,_that.number,_that.chosen,_that.isCorrect,_that.finishedAt,_that.tags);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String questionId,  String groupId,  String testId,  int part,  int number,  String? chosen,  bool isCorrect,  DateTime finishedAt,  List<String> tags)?  $default,) {final _that = this;
switch (_that) {
case _LatestAnswer() when $default != null:
return $default(_that.questionId,_that.groupId,_that.testId,_that.part,_that.number,_that.chosen,_that.isCorrect,_that.finishedAt,_that.tags);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LatestAnswer implements LatestAnswer {
  const _LatestAnswer({required this.questionId, required this.groupId, required this.testId, required this.part, required this.number, this.chosen, required this.isCorrect, required this.finishedAt,  List<String> tags = const <String>[]}): _tags = tags;
  factory _LatestAnswer.fromJson(Map<String, dynamic> json) => _$LatestAnswerFromJson(json);

@override final  String questionId;
@override final  String groupId;
@override final  String testId;
@override final  int part;
@override final  int number;
@override final  String? chosen;
@override final  bool isCorrect;
@override final  DateTime finishedAt;
 final  List<String> _tags;
@override@JsonKey() List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}


/// Create a copy of LatestAnswer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LatestAnswerCopyWith<_LatestAnswer> get copyWith => __$LatestAnswerCopyWithImpl<_LatestAnswer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LatestAnswerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LatestAnswer&&(identical(other.questionId, questionId) || other.questionId == questionId)&&(identical(other.groupId, groupId) || other.groupId == groupId)&&(identical(other.testId, testId) || other.testId == testId)&&(identical(other.part, part) || other.part == part)&&(identical(other.number, number) || other.number == number)&&(identical(other.chosen, chosen) || other.chosen == chosen)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.finishedAt, finishedAt) || other.finishedAt == finishedAt)&&const DeepCollectionEquality().equals(other.tags, _tags));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,questionId,groupId,testId,part,number,chosen,isCorrect,finishedAt,const DeepCollectionEquality().hash(_tags));
}

@override
String toString() {
    return 'LatestAnswer(questionId: $questionId, groupId: $groupId, testId: $testId, part: $part, number: $number, chosen: $chosen, isCorrect: $isCorrect, finishedAt: $finishedAt, tags: $tags)';
}


}

/// @nodoc
abstract mixin class _$LatestAnswerCopyWith<$Res> implements $LatestAnswerCopyWith<$Res> {
  factory _$LatestAnswerCopyWith(_LatestAnswer value, $Res Function(_LatestAnswer) _then) = __$LatestAnswerCopyWithImpl;
@override @useResult
$Res call({
 String questionId, String groupId, String testId, int part, int number, String? chosen, bool isCorrect, DateTime finishedAt, List<String> tags
});




}
/// @nodoc
class __$LatestAnswerCopyWithImpl<$Res>
    implements _$LatestAnswerCopyWith<$Res> {
  __$LatestAnswerCopyWithImpl(this._self, this._then);

  final _LatestAnswer _self;
  final $Res Function(_LatestAnswer) _then;

/// Create a copy of LatestAnswer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questionId = null,Object? groupId = null,Object? testId = null,Object? part = null,Object? number = null,Object? chosen = freezed,Object? isCorrect = null,Object? finishedAt = null,Object? tags = null,}) {
  return _then(_LatestAnswer(
questionId: null == questionId ? _self.questionId : questionId // ignore: cast_nullable_to_non_nullable
as String,groupId: null == groupId ? _self.groupId : groupId // ignore: cast_nullable_to_non_nullable
as String,testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,chosen: freezed == chosen ? _self.chosen : chosen // ignore: cast_nullable_to_non_nullable
as String?,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,finishedAt: null == finishedAt ? _self.finishedAt : finishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$TagStat {

 String get tag; int get total; int get correct;
/// Create a copy of TagStat
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TagStatCopyWith<TagStat> get copyWith => _$TagStatCopyWithImpl<TagStat>(this as TagStat, _$identity);

  /// Serializes this TagStat to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TagStat;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TagStat&&(identical(other.tag, _this.tag) || other.tag == _this.tag)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.correct, _this.correct) || other.correct == _this.correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TagStat;
  return Object.hash(runtimeType,_this.tag,_this.total,_this.correct);
}

@override
String toString() {
  final _this = this as TagStat;
  return 'TagStat(tag: ${_this.tag}, total: ${_this.total}, correct: ${_this.correct})';
}


}

/// @nodoc
abstract mixin class $TagStatCopyWith<$Res>  {
  factory $TagStatCopyWith(TagStat value, $Res Function(TagStat) _then) = _$TagStatCopyWithImpl;
@useResult
$Res call({
 String tag, int total, int correct
});




}
/// @nodoc
class _$TagStatCopyWithImpl<$Res>
    implements $TagStatCopyWith<$Res> {
  _$TagStatCopyWithImpl(this._self, this._then);

  final TagStat _self;
  final $Res Function(TagStat) _then;

/// Create a copy of TagStat
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? tag = null,Object? total = null,Object? correct = null,}) {
  return _then(TagStat(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TagStat].
extension TagStatPatterns on TagStat {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TagStat value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TagStat() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TagStat value)  $default,){
final _that = this;
switch (_that) {
case _TagStat():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TagStat value)?  $default,){
final _that = this;
switch (_that) {
case _TagStat() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String tag,  int total,  int correct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TagStat() when $default != null:
return $default(_that.tag,_that.total,_that.correct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String tag,  int total,  int correct)  $default,) {final _that = this;
switch (_that) {
case _TagStat():
return $default(_that.tag,_that.total,_that.correct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String tag,  int total,  int correct)?  $default,) {final _that = this;
switch (_that) {
case _TagStat() when $default != null:
return $default(_that.tag,_that.total,_that.correct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TagStat extends TagStat {
  const _TagStat({required this.tag, required this.total, required this.correct}): super._();
  factory _TagStat.fromJson(Map<String, dynamic> json) => _$TagStatFromJson(json);

@override final  String tag;
@override final  int total;
@override final  int correct;

/// Create a copy of TagStat
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TagStatCopyWith<_TagStat> get copyWith => __$TagStatCopyWithImpl<_TagStat>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TagStatToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TagStat&&(identical(other.tag, tag) || other.tag == tag)&&(identical(other.total, total) || other.total == total)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,tag,total,correct);
}

@override
String toString() {
    return 'TagStat(tag: $tag, total: $total, correct: $correct)';
}


}

/// @nodoc
abstract mixin class _$TagStatCopyWith<$Res> implements $TagStatCopyWith<$Res> {
  factory _$TagStatCopyWith(_TagStat value, $Res Function(_TagStat) _then) = __$TagStatCopyWithImpl;
@override @useResult
$Res call({
 String tag, int total, int correct
});




}
/// @nodoc
class __$TagStatCopyWithImpl<$Res>
    implements _$TagStatCopyWith<$Res> {
  __$TagStatCopyWithImpl(this._self, this._then);

  final _TagStat _self;
  final $Res Function(_TagStat) _then;

/// Create a copy of TagStat
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? tag = null,Object? total = null,Object? correct = null,}) {
  return _then(_TagStat(
tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$InProgressRow {

 String get testId; Map<String, dynamic> get snapshot; DateTime get savedAt;
/// Create a copy of InProgressRow
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InProgressRowCopyWith<InProgressRow> get copyWith => _$InProgressRowCopyWithImpl<InProgressRow>(this as InProgressRow, _$identity);

  /// Serializes this InProgressRow to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InProgressRow;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InProgressRow&&(identical(other.testId, _this.testId) || other.testId == _this.testId)&&const DeepCollectionEquality().equals(other.snapshot, _this.snapshot)&&(identical(other.savedAt, _this.savedAt) || other.savedAt == _this.savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InProgressRow;
  return Object.hash(runtimeType,_this.testId,const DeepCollectionEquality().hash(_this.snapshot),_this.savedAt);
}

@override
String toString() {
  final _this = this as InProgressRow;
  return 'InProgressRow(testId: ${_this.testId}, snapshot: ${_this.snapshot}, savedAt: ${_this.savedAt})';
}


}

/// @nodoc
abstract mixin class $InProgressRowCopyWith<$Res>  {
  factory $InProgressRowCopyWith(InProgressRow value, $Res Function(InProgressRow) _then) = _$InProgressRowCopyWithImpl;
@useResult
$Res call({
 String testId, Map<String, dynamic> snapshot, DateTime savedAt
});




}
/// @nodoc
class _$InProgressRowCopyWithImpl<$Res>
    implements $InProgressRowCopyWith<$Res> {
  _$InProgressRowCopyWithImpl(this._self, this._then);

  final InProgressRow _self;
  final $Res Function(InProgressRow) _then;

/// Create a copy of InProgressRow
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? testId = null,Object? snapshot = null,Object? savedAt = null,}) {
  return _then(InProgressRow(
testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,snapshot: null == snapshot ? _self.snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [InProgressRow].
extension InProgressRowPatterns on InProgressRow {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InProgressRow value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InProgressRow() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InProgressRow value)  $default,){
final _that = this;
switch (_that) {
case _InProgressRow():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InProgressRow value)?  $default,){
final _that = this;
switch (_that) {
case _InProgressRow() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String testId,  Map<String, dynamic> snapshot,  DateTime savedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InProgressRow() when $default != null:
return $default(_that.testId,_that.snapshot,_that.savedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String testId,  Map<String, dynamic> snapshot,  DateTime savedAt)  $default,) {final _that = this;
switch (_that) {
case _InProgressRow():
return $default(_that.testId,_that.snapshot,_that.savedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String testId,  Map<String, dynamic> snapshot,  DateTime savedAt)?  $default,) {final _that = this;
switch (_that) {
case _InProgressRow() when $default != null:
return $default(_that.testId,_that.snapshot,_that.savedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InProgressRow implements InProgressRow {
  const _InProgressRow({required this.testId, required  Map<String, dynamic> snapshot, required this.savedAt}): _snapshot = snapshot;
  factory _InProgressRow.fromJson(Map<String, dynamic> json) => _$InProgressRowFromJson(json);

@override final  String testId;
 final  Map<String, dynamic> _snapshot;
@override Map<String, dynamic> get snapshot {
  if (_snapshot is EqualUnmodifiableMapView) return _snapshot;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_snapshot);
}

@override final  DateTime savedAt;

/// Create a copy of InProgressRow
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InProgressRowCopyWith<_InProgressRow> get copyWith => __$InProgressRowCopyWithImpl<_InProgressRow>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InProgressRowToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InProgressRow&&(identical(other.testId, testId) || other.testId == testId)&&const DeepCollectionEquality().equals(other.snapshot, _snapshot)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,testId,const DeepCollectionEquality().hash(_snapshot),savedAt);
}

@override
String toString() {
    return 'InProgressRow(testId: $testId, snapshot: $snapshot, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class _$InProgressRowCopyWith<$Res> implements $InProgressRowCopyWith<$Res> {
  factory _$InProgressRowCopyWith(_InProgressRow value, $Res Function(_InProgressRow) _then) = __$InProgressRowCopyWithImpl;
@override @useResult
$Res call({
 String testId, Map<String, dynamic> snapshot, DateTime savedAt
});




}
/// @nodoc
class __$InProgressRowCopyWithImpl<$Res>
    implements _$InProgressRowCopyWith<$Res> {
  __$InProgressRowCopyWithImpl(this._self, this._then);

  final _InProgressRow _self;
  final $Res Function(_InProgressRow) _then;

/// Create a copy of InProgressRow
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? testId = null,Object? snapshot = null,Object? savedAt = null,}) {
  return _then(_InProgressRow(
testId: null == testId ? _self.testId : testId // ignore: cast_nullable_to_non_nullable
as String,snapshot: null == snapshot ? _self._snapshot : snapshot // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$TestDetail {

 TestSummary get summary; List<QuestionGroup> get groups;
/// Create a copy of TestDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TestDetailCopyWith<TestDetail> get copyWith => _$TestDetailCopyWithImpl<TestDetail>(this as TestDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as TestDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TestDetail&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.groups, _this.groups));
}


@override
int get hashCode {
  final _this = this as TestDetail;
  return Object.hash(runtimeType,_this.summary,const DeepCollectionEquality().hash(_this.groups));
}

@override
String toString() {
  final _this = this as TestDetail;
  return 'TestDetail(summary: ${_this.summary}, groups: ${_this.groups})';
}


}

/// @nodoc
abstract mixin class $TestDetailCopyWith<$Res>  {
  factory $TestDetailCopyWith(TestDetail value, $Res Function(TestDetail) _then) = _$TestDetailCopyWithImpl;
@useResult
$Res call({
 TestSummary summary, List<QuestionGroup> groups
});


$TestSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class _$TestDetailCopyWithImpl<$Res>
    implements $TestDetailCopyWith<$Res> {
  _$TestDetailCopyWithImpl(this._self, this._then);

  final TestDetail _self;
  final $Res Function(TestDetail) _then;

/// Create a copy of TestDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? summary = null,Object? groups = null,}) {
  return _then(TestDetail(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as TestSummary,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<QuestionGroup>,
  ));
}
/// Create a copy of TestDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TestSummaryCopyWith<$Res> get summary {
  
  return $TestSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}


/// Adds pattern-matching-related methods to [TestDetail].
extension TestDetailPatterns on TestDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TestDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TestDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TestDetail value)  $default,){
final _that = this;
switch (_that) {
case _TestDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TestDetail value)?  $default,){
final _that = this;
switch (_that) {
case _TestDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TestSummary summary,  List<QuestionGroup> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TestDetail() when $default != null:
return $default(_that.summary,_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TestSummary summary,  List<QuestionGroup> groups)  $default,) {final _that = this;
switch (_that) {
case _TestDetail():
return $default(_that.summary,_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TestSummary summary,  List<QuestionGroup> groups)?  $default,) {final _that = this;
switch (_that) {
case _TestDetail() when $default != null:
return $default(_that.summary,_that.groups);case _:
  return null;

}
}

}

/// @nodoc


class _TestDetail extends TestDetail {
  const _TestDetail({required this.summary, required  List<QuestionGroup> groups}): _groups = groups,super._();
  

@override final  TestSummary summary;
 final  List<QuestionGroup> _groups;
@override List<QuestionGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of TestDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TestDetailCopyWith<_TestDetail> get copyWith => __$TestDetailCopyWithImpl<_TestDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TestDetail&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.groups, _groups));
}


@override
int get hashCode {
    return Object.hash(runtimeType,summary,const DeepCollectionEquality().hash(_groups));
}

@override
String toString() {
    return 'TestDetail(summary: $summary, groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$TestDetailCopyWith<$Res> implements $TestDetailCopyWith<$Res> {
  factory _$TestDetailCopyWith(_TestDetail value, $Res Function(_TestDetail) _then) = __$TestDetailCopyWithImpl;
@override @useResult
$Res call({
 TestSummary summary, List<QuestionGroup> groups
});


@override $TestSummaryCopyWith<$Res> get summary;

}
/// @nodoc
class __$TestDetailCopyWithImpl<$Res>
    implements _$TestDetailCopyWith<$Res> {
  __$TestDetailCopyWithImpl(this._self, this._then);

  final _TestDetail _self;
  final $Res Function(_TestDetail) _then;

/// Create a copy of TestDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? summary = null,Object? groups = null,}) {
  return _then(_TestDetail(
summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as TestSummary,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<QuestionGroup>,
  ));
}

/// Create a copy of TestDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TestSummaryCopyWith<$Res> get summary {
  
  return $TestSummaryCopyWith<$Res>(_self.summary, (value) {
    return _then(_self.copyWith(summary: value));
  });
}
}

/// @nodoc
mixin _$AttemptResult {

 Attempt get attempt; List<QuestionGroup> get groups;/// question_id → đáp án đã chọn (null = bỏ trống)
 Map<String, String?> get answers;
/// Create a copy of AttemptResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttemptResultCopyWith<AttemptResult> get copyWith => _$AttemptResultCopyWithImpl<AttemptResult>(this as AttemptResult, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as AttemptResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttemptResult&&(identical(other.attempt, _this.attempt) || other.attempt == _this.attempt)&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&const DeepCollectionEquality().equals(other.answers, _this.answers));
}


@override
int get hashCode {
  final _this = this as AttemptResult;
  return Object.hash(runtimeType,_this.attempt,const DeepCollectionEquality().hash(_this.groups),const DeepCollectionEquality().hash(_this.answers));
}

@override
String toString() {
  final _this = this as AttemptResult;
  return 'AttemptResult(attempt: ${_this.attempt}, groups: ${_this.groups}, answers: ${_this.answers})';
}


}

/// @nodoc
abstract mixin class $AttemptResultCopyWith<$Res>  {
  factory $AttemptResultCopyWith(AttemptResult value, $Res Function(AttemptResult) _then) = _$AttemptResultCopyWithImpl;
@useResult
$Res call({
 Attempt attempt, List<QuestionGroup> groups, Map<String, String?> answers
});


$AttemptCopyWith<$Res> get attempt;

}
/// @nodoc
class _$AttemptResultCopyWithImpl<$Res>
    implements $AttemptResultCopyWith<$Res> {
  _$AttemptResultCopyWithImpl(this._self, this._then);

  final AttemptResult _self;
  final $Res Function(AttemptResult) _then;

/// Create a copy of AttemptResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? attempt = null,Object? groups = null,Object? answers = null,}) {
  return _then(AttemptResult(
attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as Attempt,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<QuestionGroup>,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String?>,
  ));
}
/// Create a copy of AttemptResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttemptCopyWith<$Res> get attempt {
  
  return $AttemptCopyWith<$Res>(_self.attempt, (value) {
    return _then(_self.copyWith(attempt: value));
  });
}
}


/// Adds pattern-matching-related methods to [AttemptResult].
extension AttemptResultPatterns on AttemptResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttemptResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttemptResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttemptResult value)  $default,){
final _that = this;
switch (_that) {
case _AttemptResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttemptResult value)?  $default,){
final _that = this;
switch (_that) {
case _AttemptResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Attempt attempt,  List<QuestionGroup> groups,  Map<String, String?> answers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttemptResult() when $default != null:
return $default(_that.attempt,_that.groups,_that.answers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Attempt attempt,  List<QuestionGroup> groups,  Map<String, String?> answers)  $default,) {final _that = this;
switch (_that) {
case _AttemptResult():
return $default(_that.attempt,_that.groups,_that.answers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Attempt attempt,  List<QuestionGroup> groups,  Map<String, String?> answers)?  $default,) {final _that = this;
switch (_that) {
case _AttemptResult() when $default != null:
return $default(_that.attempt,_that.groups,_that.answers);case _:
  return null;

}
}

}

/// @nodoc


class _AttemptResult extends AttemptResult {
  const _AttemptResult({required this.attempt, required  List<QuestionGroup> groups, required  Map<String, String?> answers}): _groups = groups,_answers = answers,super._();
  

@override final  Attempt attempt;
 final  List<QuestionGroup> _groups;
@override List<QuestionGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

/// question_id → đáp án đã chọn (null = bỏ trống)
 final  Map<String, String?> _answers;
/// question_id → đáp án đã chọn (null = bỏ trống)
@override Map<String, String?> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}


/// Create a copy of AttemptResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttemptResultCopyWith<_AttemptResult> get copyWith => __$AttemptResultCopyWithImpl<_AttemptResult>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttemptResult&&(identical(other.attempt, attempt) || other.attempt == attempt)&&const DeepCollectionEquality().equals(other.groups, _groups)&&const DeepCollectionEquality().equals(other.answers, _answers));
}


@override
int get hashCode {
    return Object.hash(runtimeType,attempt,const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_answers));
}

@override
String toString() {
    return 'AttemptResult(attempt: $attempt, groups: $groups, answers: $answers)';
}


}

/// @nodoc
abstract mixin class _$AttemptResultCopyWith<$Res> implements $AttemptResultCopyWith<$Res> {
  factory _$AttemptResultCopyWith(_AttemptResult value, $Res Function(_AttemptResult) _then) = __$AttemptResultCopyWithImpl;
@override @useResult
$Res call({
 Attempt attempt, List<QuestionGroup> groups, Map<String, String?> answers
});


@override $AttemptCopyWith<$Res> get attempt;

}
/// @nodoc
class __$AttemptResultCopyWithImpl<$Res>
    implements _$AttemptResultCopyWith<$Res> {
  __$AttemptResultCopyWithImpl(this._self, this._then);

  final _AttemptResult _self;
  final $Res Function(_AttemptResult) _then;

/// Create a copy of AttemptResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? attempt = null,Object? groups = null,Object? answers = null,}) {
  return _then(_AttemptResult(
attempt: null == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as Attempt,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<QuestionGroup>,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String?>,
  ));
}

/// Create a copy of AttemptResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AttemptCopyWith<$Res> get attempt {
  
  return $AttemptCopyWith<$Res>(_self.attempt, (value) {
    return _then(_self.copyWith(attempt: value));
  });
}
}

// dart format on
