// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arena_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContestInfo {

 String get id; String get title; DateTime get startsAt; DateTime get endsAt; int get questionCount; int get participants; bool get joined; bool get submitted; int? get correct;
/// Create a copy of ContestInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestInfoCopyWith<ContestInfo> get copyWith => _$ContestInfoCopyWithImpl<ContestInfo>(this as ContestInfo, _$identity);

  /// Serializes this ContestInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContestInfo;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestInfo&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.questionCount, _this.questionCount) || other.questionCount == _this.questionCount)&&(identical(other.participants, _this.participants) || other.participants == _this.participants)&&(identical(other.joined, _this.joined) || other.joined == _this.joined)&&(identical(other.submitted, _this.submitted) || other.submitted == _this.submitted)&&(identical(other.correct, _this.correct) || other.correct == _this.correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContestInfo;
  return Object.hash(runtimeType,_this.id,_this.title,_this.startsAt,_this.endsAt,_this.questionCount,_this.participants,_this.joined,_this.submitted,_this.correct);
}

@override
String toString() {
  final _this = this as ContestInfo;
  return 'ContestInfo(id: ${_this.id}, title: ${_this.title}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, questionCount: ${_this.questionCount}, participants: ${_this.participants}, joined: ${_this.joined}, submitted: ${_this.submitted}, correct: ${_this.correct})';
}


}

/// @nodoc
abstract mixin class $ContestInfoCopyWith<$Res>  {
  factory $ContestInfoCopyWith(ContestInfo value, $Res Function(ContestInfo) _then) = _$ContestInfoCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime startsAt, DateTime endsAt, int questionCount, int participants, bool joined, bool submitted, int? correct
});




}
/// @nodoc
class _$ContestInfoCopyWithImpl<$Res>
    implements $ContestInfoCopyWith<$Res> {
  _$ContestInfoCopyWithImpl(this._self, this._then);

  final ContestInfo _self;
  final $Res Function(ContestInfo) _then;

/// Create a copy of ContestInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? startsAt = null,Object? endsAt = null,Object? questionCount = null,Object? participants = null,Object? joined = null,Object? submitted = null,Object? correct = freezed,}) {
  return _then(ContestInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as int,joined: null == joined ? _self.joined : joined // ignore: cast_nullable_to_non_nullable
as bool,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,correct: freezed == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContestInfo].
extension ContestInfoPatterns on ContestInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestInfo value)  $default,){
final _that = this;
switch (_that) {
case _ContestInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestInfo value)?  $default,){
final _that = this;
switch (_that) {
case _ContestInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime startsAt,  DateTime endsAt,  int questionCount,  int participants,  bool joined,  bool submitted,  int? correct)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestInfo() when $default != null:
return $default(_that.id,_that.title,_that.startsAt,_that.endsAt,_that.questionCount,_that.participants,_that.joined,_that.submitted,_that.correct);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime startsAt,  DateTime endsAt,  int questionCount,  int participants,  bool joined,  bool submitted,  int? correct)  $default,) {final _that = this;
switch (_that) {
case _ContestInfo():
return $default(_that.id,_that.title,_that.startsAt,_that.endsAt,_that.questionCount,_that.participants,_that.joined,_that.submitted,_that.correct);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime startsAt,  DateTime endsAt,  int questionCount,  int participants,  bool joined,  bool submitted,  int? correct)?  $default,) {final _that = this;
switch (_that) {
case _ContestInfo() when $default != null:
return $default(_that.id,_that.title,_that.startsAt,_that.endsAt,_that.questionCount,_that.participants,_that.joined,_that.submitted,_that.correct);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestInfo extends ContestInfo {
  const _ContestInfo({required this.id, required this.title, required this.startsAt, required this.endsAt, required this.questionCount, this.participants = 0, this.joined = false, this.submitted = false, this.correct}): super._();
  factory _ContestInfo.fromJson(Map<String, dynamic> json) => _$ContestInfoFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime startsAt;
@override final  DateTime endsAt;
@override final  int questionCount;
@override@JsonKey() final  int participants;
@override@JsonKey() final  bool joined;
@override@JsonKey() final  bool submitted;
@override final  int? correct;

/// Create a copy of ContestInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestInfoCopyWith<_ContestInfo> get copyWith => __$ContestInfoCopyWithImpl<_ContestInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestInfoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.participants, participants) || other.participants == participants)&&(identical(other.joined, joined) || other.joined == joined)&&(identical(other.submitted, submitted) || other.submitted == submitted)&&(identical(other.correct, correct) || other.correct == correct));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,startsAt,endsAt,questionCount,participants,joined,submitted,correct);
}

@override
String toString() {
    return 'ContestInfo(id: $id, title: $title, startsAt: $startsAt, endsAt: $endsAt, questionCount: $questionCount, participants: $participants, joined: $joined, submitted: $submitted, correct: $correct)';
}


}

/// @nodoc
abstract mixin class _$ContestInfoCopyWith<$Res> implements $ContestInfoCopyWith<$Res> {
  factory _$ContestInfoCopyWith(_ContestInfo value, $Res Function(_ContestInfo) _then) = __$ContestInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime startsAt, DateTime endsAt, int questionCount, int participants, bool joined, bool submitted, int? correct
});




}
/// @nodoc
class __$ContestInfoCopyWithImpl<$Res>
    implements _$ContestInfoCopyWith<$Res> {
  __$ContestInfoCopyWithImpl(this._self, this._then);

  final _ContestInfo _self;
  final $Res Function(_ContestInfo) _then;

/// Create a copy of ContestInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? startsAt = null,Object? endsAt = null,Object? questionCount = null,Object? participants = null,Object? joined = null,Object? submitted = null,Object? correct = freezed,}) {
  return _then(_ContestInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as int,joined: null == joined ? _self.joined : joined // ignore: cast_nullable_to_non_nullable
as bool,submitted: null == submitted ? _self.submitted : submitted // ignore: cast_nullable_to_non_nullable
as bool,correct: freezed == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ContestOverview {

 DateTime get serverNow; ContestInfo? get current; ContestInfo? get previous;
/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestOverviewCopyWith<ContestOverview> get copyWith => _$ContestOverviewCopyWithImpl<ContestOverview>(this as ContestOverview, _$identity);

  /// Serializes this ContestOverview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContestOverview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestOverview&&(identical(other.serverNow, _this.serverNow) || other.serverNow == _this.serverNow)&&(identical(other.current, _this.current) || other.current == _this.current)&&(identical(other.previous, _this.previous) || other.previous == _this.previous));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContestOverview;
  return Object.hash(runtimeType,_this.serverNow,_this.current,_this.previous);
}

@override
String toString() {
  final _this = this as ContestOverview;
  return 'ContestOverview(serverNow: ${_this.serverNow}, current: ${_this.current}, previous: ${_this.previous})';
}


}

/// @nodoc
abstract mixin class $ContestOverviewCopyWith<$Res>  {
  factory $ContestOverviewCopyWith(ContestOverview value, $Res Function(ContestOverview) _then) = _$ContestOverviewCopyWithImpl;
@useResult
$Res call({
 DateTime serverNow, ContestInfo? current, ContestInfo? previous
});


$ContestInfoCopyWith<$Res>? get current;$ContestInfoCopyWith<$Res>? get previous;

}
/// @nodoc
class _$ContestOverviewCopyWithImpl<$Res>
    implements $ContestOverviewCopyWith<$Res> {
  _$ContestOverviewCopyWithImpl(this._self, this._then);

  final ContestOverview _self;
  final $Res Function(ContestOverview) _then;

/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serverNow = null,Object? current = freezed,Object? previous = freezed,}) {
  return _then(ContestOverview(
serverNow: null == serverNow ? _self.serverNow : serverNow // ignore: cast_nullable_to_non_nullable
as DateTime,current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as ContestInfo?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as ContestInfo?,
  ));
}
/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContestInfoCopyWith<$Res>? get current {
    if (_self.current == null) {
    return null;
  }

  return $ContestInfoCopyWith<$Res>(_self.current!, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContestInfoCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $ContestInfoCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}


/// Adds pattern-matching-related methods to [ContestOverview].
extension ContestOverviewPatterns on ContestOverview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestOverview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestOverview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestOverview value)  $default,){
final _that = this;
switch (_that) {
case _ContestOverview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestOverview value)?  $default,){
final _that = this;
switch (_that) {
case _ContestOverview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime serverNow,  ContestInfo? current,  ContestInfo? previous)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestOverview() when $default != null:
return $default(_that.serverNow,_that.current,_that.previous);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime serverNow,  ContestInfo? current,  ContestInfo? previous)  $default,) {final _that = this;
switch (_that) {
case _ContestOverview():
return $default(_that.serverNow,_that.current,_that.previous);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime serverNow,  ContestInfo? current,  ContestInfo? previous)?  $default,) {final _that = this;
switch (_that) {
case _ContestOverview() when $default != null:
return $default(_that.serverNow,_that.current,_that.previous);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestOverview implements ContestOverview {
  const _ContestOverview({required this.serverNow, this.current, this.previous});
  factory _ContestOverview.fromJson(Map<String, dynamic> json) => _$ContestOverviewFromJson(json);

@override final  DateTime serverNow;
@override final  ContestInfo? current;
@override final  ContestInfo? previous;

/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestOverviewCopyWith<_ContestOverview> get copyWith => __$ContestOverviewCopyWithImpl<_ContestOverview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestOverviewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestOverview&&(identical(other.serverNow, serverNow) || other.serverNow == serverNow)&&(identical(other.current, current) || other.current == current)&&(identical(other.previous, previous) || other.previous == previous));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,serverNow,current,previous);
}

@override
String toString() {
    return 'ContestOverview(serverNow: $serverNow, current: $current, previous: $previous)';
}


}

/// @nodoc
abstract mixin class _$ContestOverviewCopyWith<$Res> implements $ContestOverviewCopyWith<$Res> {
  factory _$ContestOverviewCopyWith(_ContestOverview value, $Res Function(_ContestOverview) _then) = __$ContestOverviewCopyWithImpl;
@override @useResult
$Res call({
 DateTime serverNow, ContestInfo? current, ContestInfo? previous
});


@override $ContestInfoCopyWith<$Res>? get current;@override $ContestInfoCopyWith<$Res>? get previous;

}
/// @nodoc
class __$ContestOverviewCopyWithImpl<$Res>
    implements _$ContestOverviewCopyWith<$Res> {
  __$ContestOverviewCopyWithImpl(this._self, this._then);

  final _ContestOverview _self;
  final $Res Function(_ContestOverview) _then;

/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serverNow = null,Object? current = freezed,Object? previous = freezed,}) {
  return _then(_ContestOverview(
serverNow: null == serverNow ? _self.serverNow : serverNow // ignore: cast_nullable_to_non_nullable
as DateTime,current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as ContestInfo?,previous: freezed == previous ? _self.previous : previous // ignore: cast_nullable_to_non_nullable
as ContestInfo?,
  ));
}

/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContestInfoCopyWith<$Res>? get current {
    if (_self.current == null) {
    return null;
  }

  return $ContestInfoCopyWith<$Res>(_self.current!, (value) {
    return _then(_self.copyWith(current: value));
  });
}/// Create a copy of ContestOverview
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ContestInfoCopyWith<$Res>? get previous {
    if (_self.previous == null) {
    return null;
  }

  return $ContestInfoCopyWith<$Res>(_self.previous!, (value) {
    return _then(_self.copyWith(previous: value));
  });
}
}


/// @nodoc
mixin _$PaperQuestion {

 int get n; int get part; String? get content; List<String> get options;
/// Create a copy of PaperQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaperQuestionCopyWith<PaperQuestion> get copyWith => _$PaperQuestionCopyWithImpl<PaperQuestion>(this as PaperQuestion, _$identity);

  /// Serializes this PaperQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaperQuestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaperQuestion&&(identical(other.n, _this.n) || other.n == _this.n)&&(identical(other.part, _this.part) || other.part == _this.part)&&(identical(other.content, _this.content) || other.content == _this.content)&&const DeepCollectionEquality().equals(other.options, _this.options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaperQuestion;
  return Object.hash(runtimeType,_this.n,_this.part,_this.content,const DeepCollectionEquality().hash(_this.options));
}

@override
String toString() {
  final _this = this as PaperQuestion;
  return 'PaperQuestion(n: ${_this.n}, part: ${_this.part}, content: ${_this.content}, options: ${_this.options})';
}


}

/// @nodoc
abstract mixin class $PaperQuestionCopyWith<$Res>  {
  factory $PaperQuestionCopyWith(PaperQuestion value, $Res Function(PaperQuestion) _then) = _$PaperQuestionCopyWithImpl;
@useResult
$Res call({
 int n, int part, String? content, List<String> options
});




}
/// @nodoc
class _$PaperQuestionCopyWithImpl<$Res>
    implements $PaperQuestionCopyWith<$Res> {
  _$PaperQuestionCopyWithImpl(this._self, this._then);

  final PaperQuestion _self;
  final $Res Function(PaperQuestion) _then;

/// Create a copy of PaperQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? n = null,Object? part = null,Object? content = freezed,Object? options = null,}) {
  return _then(PaperQuestion(
n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaperQuestion].
extension PaperQuestionPatterns on PaperQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaperQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaperQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaperQuestion value)  $default,){
final _that = this;
switch (_that) {
case _PaperQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaperQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _PaperQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int n,  int part,  String? content,  List<String> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaperQuestion() when $default != null:
return $default(_that.n,_that.part,_that.content,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int n,  int part,  String? content,  List<String> options)  $default,) {final _that = this;
switch (_that) {
case _PaperQuestion():
return $default(_that.n,_that.part,_that.content,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int n,  int part,  String? content,  List<String> options)?  $default,) {final _that = this;
switch (_that) {
case _PaperQuestion() when $default != null:
return $default(_that.n,_that.part,_that.content,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaperQuestion implements PaperQuestion {
  const _PaperQuestion({required this.n, required this.part, this.content,  List<String> options = const <String>[]}): _options = options;
  factory _PaperQuestion.fromJson(Map<String, dynamic> json) => _$PaperQuestionFromJson(json);

@override final  int n;
@override final  int part;
@override final  String? content;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of PaperQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaperQuestionCopyWith<_PaperQuestion> get copyWith => __$PaperQuestionCopyWithImpl<_PaperQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaperQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaperQuestion&&(identical(other.n, n) || other.n == n)&&(identical(other.part, part) || other.part == part)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,n,part,content,const DeepCollectionEquality().hash(_options));
}

@override
String toString() {
    return 'PaperQuestion(n: $n, part: $part, content: $content, options: $options)';
}


}

/// @nodoc
abstract mixin class _$PaperQuestionCopyWith<$Res> implements $PaperQuestionCopyWith<$Res> {
  factory _$PaperQuestionCopyWith(_PaperQuestion value, $Res Function(_PaperQuestion) _then) = __$PaperQuestionCopyWithImpl;
@override @useResult
$Res call({
 int n, int part, String? content, List<String> options
});




}
/// @nodoc
class __$PaperQuestionCopyWithImpl<$Res>
    implements _$PaperQuestionCopyWith<$Res> {
  __$PaperQuestionCopyWithImpl(this._self, this._then);

  final _PaperQuestion _self;
  final $Res Function(_PaperQuestion) _then;

/// Create a copy of PaperQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? n = null,Object? part = null,Object? content = freezed,Object? options = null,}) {
  return _then(_PaperQuestion(
n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$PaperGroup {

 int get part; String? get passage; String? get audioUrl; String? get imageUrl; String? get transcript; List<PaperQuestion> get questions;
/// Create a copy of PaperGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaperGroupCopyWith<PaperGroup> get copyWith => _$PaperGroupCopyWithImpl<PaperGroup>(this as PaperGroup, _$identity);

  /// Serializes this PaperGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PaperGroup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaperGroup&&(identical(other.part, _this.part) || other.part == _this.part)&&(identical(other.passage, _this.passage) || other.passage == _this.passage)&&(identical(other.audioUrl, _this.audioUrl) || other.audioUrl == _this.audioUrl)&&(identical(other.imageUrl, _this.imageUrl) || other.imageUrl == _this.imageUrl)&&(identical(other.transcript, _this.transcript) || other.transcript == _this.transcript)&&const DeepCollectionEquality().equals(other.questions, _this.questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PaperGroup;
  return Object.hash(runtimeType,_this.part,_this.passage,_this.audioUrl,_this.imageUrl,_this.transcript,const DeepCollectionEquality().hash(_this.questions));
}

@override
String toString() {
  final _this = this as PaperGroup;
  return 'PaperGroup(part: ${_this.part}, passage: ${_this.passage}, audioUrl: ${_this.audioUrl}, imageUrl: ${_this.imageUrl}, transcript: ${_this.transcript}, questions: ${_this.questions})';
}


}

/// @nodoc
abstract mixin class $PaperGroupCopyWith<$Res>  {
  factory $PaperGroupCopyWith(PaperGroup value, $Res Function(PaperGroup) _then) = _$PaperGroupCopyWithImpl;
@useResult
$Res call({
 int part, String? passage, String? audioUrl, String? imageUrl, String? transcript, List<PaperQuestion> questions
});




}
/// @nodoc
class _$PaperGroupCopyWithImpl<$Res>
    implements $PaperGroupCopyWith<$Res> {
  _$PaperGroupCopyWithImpl(this._self, this._then);

  final PaperGroup _self;
  final $Res Function(PaperGroup) _then;

/// Create a copy of PaperGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? part = null,Object? passage = freezed,Object? audioUrl = freezed,Object? imageUrl = freezed,Object? transcript = freezed,Object? questions = null,}) {
  return _then(PaperGroup(
part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,passage: freezed == passage ? _self.passage : passage // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,transcript: freezed == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<PaperQuestion>,
  ));
}

}


/// Adds pattern-matching-related methods to [PaperGroup].
extension PaperGroupPatterns on PaperGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaperGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaperGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaperGroup value)  $default,){
final _that = this;
switch (_that) {
case _PaperGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaperGroup value)?  $default,){
final _that = this;
switch (_that) {
case _PaperGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int part,  String? passage,  String? audioUrl,  String? imageUrl,  String? transcript,  List<PaperQuestion> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaperGroup() when $default != null:
return $default(_that.part,_that.passage,_that.audioUrl,_that.imageUrl,_that.transcript,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int part,  String? passage,  String? audioUrl,  String? imageUrl,  String? transcript,  List<PaperQuestion> questions)  $default,) {final _that = this;
switch (_that) {
case _PaperGroup():
return $default(_that.part,_that.passage,_that.audioUrl,_that.imageUrl,_that.transcript,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int part,  String? passage,  String? audioUrl,  String? imageUrl,  String? transcript,  List<PaperQuestion> questions)?  $default,) {final _that = this;
switch (_that) {
case _PaperGroup() when $default != null:
return $default(_that.part,_that.passage,_that.audioUrl,_that.imageUrl,_that.transcript,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaperGroup implements PaperGroup {
  const _PaperGroup({required this.part, this.passage, this.audioUrl, this.imageUrl, this.transcript,  List<PaperQuestion> questions = const <PaperQuestion>[]}): _questions = questions;
  factory _PaperGroup.fromJson(Map<String, dynamic> json) => _$PaperGroupFromJson(json);

@override final  int part;
@override final  String? passage;
@override final  String? audioUrl;
@override final  String? imageUrl;
@override final  String? transcript;
 final  List<PaperQuestion> _questions;
@override@JsonKey() List<PaperQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of PaperGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaperGroupCopyWith<_PaperGroup> get copyWith => __$PaperGroupCopyWithImpl<_PaperGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaperGroupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaperGroup&&(identical(other.part, part) || other.part == part)&&(identical(other.passage, passage) || other.passage == passage)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.transcript, transcript) || other.transcript == transcript)&&const DeepCollectionEquality().equals(other.questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,part,passage,audioUrl,imageUrl,transcript,const DeepCollectionEquality().hash(_questions));
}

@override
String toString() {
    return 'PaperGroup(part: $part, passage: $passage, audioUrl: $audioUrl, imageUrl: $imageUrl, transcript: $transcript, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$PaperGroupCopyWith<$Res> implements $PaperGroupCopyWith<$Res> {
  factory _$PaperGroupCopyWith(_PaperGroup value, $Res Function(_PaperGroup) _then) = __$PaperGroupCopyWithImpl;
@override @useResult
$Res call({
 int part, String? passage, String? audioUrl, String? imageUrl, String? transcript, List<PaperQuestion> questions
});




}
/// @nodoc
class __$PaperGroupCopyWithImpl<$Res>
    implements _$PaperGroupCopyWith<$Res> {
  __$PaperGroupCopyWithImpl(this._self, this._then);

  final _PaperGroup _self;
  final $Res Function(_PaperGroup) _then;

/// Create a copy of PaperGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? part = null,Object? passage = freezed,Object? audioUrl = freezed,Object? imageUrl = freezed,Object? transcript = freezed,Object? questions = null,}) {
  return _then(_PaperGroup(
part: null == part ? _self.part : part // ignore: cast_nullable_to_non_nullable
as int,passage: freezed == passage ? _self.passage : passage // ignore: cast_nullable_to_non_nullable
as String?,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,transcript: freezed == transcript ? _self.transcript : transcript // ignore: cast_nullable_to_non_nullable
as String?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<PaperQuestion>,
  ));
}


}


/// @nodoc
mixin _$ContestPaper {

 String get id; String get title; DateTime get endsAt; DateTime get serverNow; DateTime get joinedAt; Map<String, String> get answers; List<PaperGroup> get groups;
/// Create a copy of ContestPaper
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestPaperCopyWith<ContestPaper> get copyWith => _$ContestPaperCopyWithImpl<ContestPaper>(this as ContestPaper, _$identity);

  /// Serializes this ContestPaper to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContestPaper;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestPaper&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.serverNow, _this.serverNow) || other.serverNow == _this.serverNow)&&(identical(other.joinedAt, _this.joinedAt) || other.joinedAt == _this.joinedAt)&&const DeepCollectionEquality().equals(other.answers, _this.answers)&&const DeepCollectionEquality().equals(other.groups, _this.groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContestPaper;
  return Object.hash(runtimeType,_this.id,_this.title,_this.endsAt,_this.serverNow,_this.joinedAt,const DeepCollectionEquality().hash(_this.answers),const DeepCollectionEquality().hash(_this.groups));
}

@override
String toString() {
  final _this = this as ContestPaper;
  return 'ContestPaper(id: ${_this.id}, title: ${_this.title}, endsAt: ${_this.endsAt}, serverNow: ${_this.serverNow}, joinedAt: ${_this.joinedAt}, answers: ${_this.answers}, groups: ${_this.groups})';
}


}

/// @nodoc
abstract mixin class $ContestPaperCopyWith<$Res>  {
  factory $ContestPaperCopyWith(ContestPaper value, $Res Function(ContestPaper) _then) = _$ContestPaperCopyWithImpl;
@useResult
$Res call({
 String id, String title, DateTime endsAt, DateTime serverNow, DateTime joinedAt, Map<String, String> answers, List<PaperGroup> groups
});




}
/// @nodoc
class _$ContestPaperCopyWithImpl<$Res>
    implements $ContestPaperCopyWith<$Res> {
  _$ContestPaperCopyWithImpl(this._self, this._then);

  final ContestPaper _self;
  final $Res Function(ContestPaper) _then;

/// Create a copy of ContestPaper
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? endsAt = null,Object? serverNow = null,Object? joinedAt = null,Object? answers = null,Object? groups = null,}) {
  return _then(ContestPaper(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,serverNow: null == serverNow ? _self.serverNow : serverNow // ignore: cast_nullable_to_non_nullable
as DateTime,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<PaperGroup>,
  ));
}

}


/// Adds pattern-matching-related methods to [ContestPaper].
extension ContestPaperPatterns on ContestPaper {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestPaper value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestPaper() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestPaper value)  $default,){
final _that = this;
switch (_that) {
case _ContestPaper():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestPaper value)?  $default,){
final _that = this;
switch (_that) {
case _ContestPaper() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  DateTime endsAt,  DateTime serverNow,  DateTime joinedAt,  Map<String, String> answers,  List<PaperGroup> groups)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestPaper() when $default != null:
return $default(_that.id,_that.title,_that.endsAt,_that.serverNow,_that.joinedAt,_that.answers,_that.groups);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  DateTime endsAt,  DateTime serverNow,  DateTime joinedAt,  Map<String, String> answers,  List<PaperGroup> groups)  $default,) {final _that = this;
switch (_that) {
case _ContestPaper():
return $default(_that.id,_that.title,_that.endsAt,_that.serverNow,_that.joinedAt,_that.answers,_that.groups);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  DateTime endsAt,  DateTime serverNow,  DateTime joinedAt,  Map<String, String> answers,  List<PaperGroup> groups)?  $default,) {final _that = this;
switch (_that) {
case _ContestPaper() when $default != null:
return $default(_that.id,_that.title,_that.endsAt,_that.serverNow,_that.joinedAt,_that.answers,_that.groups);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestPaper implements ContestPaper {
  const _ContestPaper({required this.id, required this.title, required this.endsAt, required this.serverNow, required this.joinedAt,  Map<String, String> answers = const <String, String>{},  List<PaperGroup> groups = const <PaperGroup>[]}): _answers = answers,_groups = groups;
  factory _ContestPaper.fromJson(Map<String, dynamic> json) => _$ContestPaperFromJson(json);

@override final  String id;
@override final  String title;
@override final  DateTime endsAt;
@override final  DateTime serverNow;
@override final  DateTime joinedAt;
 final  Map<String, String> _answers;
@override@JsonKey() Map<String, String> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}

 final  List<PaperGroup> _groups;
@override@JsonKey() List<PaperGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}


/// Create a copy of ContestPaper
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestPaperCopyWith<_ContestPaper> get copyWith => __$ContestPaperCopyWithImpl<_ContestPaper>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestPaperToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestPaper&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.serverNow, serverNow) || other.serverNow == serverNow)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&const DeepCollectionEquality().equals(other.answers, _answers)&&const DeepCollectionEquality().equals(other.groups, _groups));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,endsAt,serverNow,joinedAt,const DeepCollectionEquality().hash(_answers),const DeepCollectionEquality().hash(_groups));
}

@override
String toString() {
    return 'ContestPaper(id: $id, title: $title, endsAt: $endsAt, serverNow: $serverNow, joinedAt: $joinedAt, answers: $answers, groups: $groups)';
}


}

/// @nodoc
abstract mixin class _$ContestPaperCopyWith<$Res> implements $ContestPaperCopyWith<$Res> {
  factory _$ContestPaperCopyWith(_ContestPaper value, $Res Function(_ContestPaper) _then) = __$ContestPaperCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, DateTime endsAt, DateTime serverNow, DateTime joinedAt, Map<String, String> answers, List<PaperGroup> groups
});




}
/// @nodoc
class __$ContestPaperCopyWithImpl<$Res>
    implements _$ContestPaperCopyWith<$Res> {
  __$ContestPaperCopyWithImpl(this._self, this._then);

  final _ContestPaper _self;
  final $Res Function(_ContestPaper) _then;

/// Create a copy of ContestPaper
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? endsAt = null,Object? serverNow = null,Object? joinedAt = null,Object? answers = null,Object? groups = null,}) {
  return _then(_ContestPaper(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,serverNow: null == serverNow ? _self.serverNow : serverNow // ignore: cast_nullable_to_non_nullable
as DateTime,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<PaperGroup>,
  ));
}


}


/// @nodoc
mixin _$ContestResult {

 int get correct; int get listeningCorrect; int get readingCorrect; int get questionCount;
/// Create a copy of ContestResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestResultCopyWith<ContestResult> get copyWith => _$ContestResultCopyWithImpl<ContestResult>(this as ContestResult, _$identity);

  /// Serializes this ContestResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContestResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestResult&&(identical(other.correct, _this.correct) || other.correct == _this.correct)&&(identical(other.listeningCorrect, _this.listeningCorrect) || other.listeningCorrect == _this.listeningCorrect)&&(identical(other.readingCorrect, _this.readingCorrect) || other.readingCorrect == _this.readingCorrect)&&(identical(other.questionCount, _this.questionCount) || other.questionCount == _this.questionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContestResult;
  return Object.hash(runtimeType,_this.correct,_this.listeningCorrect,_this.readingCorrect,_this.questionCount);
}

@override
String toString() {
  final _this = this as ContestResult;
  return 'ContestResult(correct: ${_this.correct}, listeningCorrect: ${_this.listeningCorrect}, readingCorrect: ${_this.readingCorrect}, questionCount: ${_this.questionCount})';
}


}

/// @nodoc
abstract mixin class $ContestResultCopyWith<$Res>  {
  factory $ContestResultCopyWith(ContestResult value, $Res Function(ContestResult) _then) = _$ContestResultCopyWithImpl;
@useResult
$Res call({
 int correct, int listeningCorrect, int readingCorrect, int questionCount
});




}
/// @nodoc
class _$ContestResultCopyWithImpl<$Res>
    implements $ContestResultCopyWith<$Res> {
  _$ContestResultCopyWithImpl(this._self, this._then);

  final ContestResult _self;
  final $Res Function(ContestResult) _then;

/// Create a copy of ContestResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? correct = null,Object? listeningCorrect = null,Object? readingCorrect = null,Object? questionCount = null,}) {
  return _then(ContestResult(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,listeningCorrect: null == listeningCorrect ? _self.listeningCorrect : listeningCorrect // ignore: cast_nullable_to_non_nullable
as int,readingCorrect: null == readingCorrect ? _self.readingCorrect : readingCorrect // ignore: cast_nullable_to_non_nullable
as int,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ContestResult].
extension ContestResultPatterns on ContestResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestResult value)  $default,){
final _that = this;
switch (_that) {
case _ContestResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestResult value)?  $default,){
final _that = this;
switch (_that) {
case _ContestResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int correct,  int listeningCorrect,  int readingCorrect,  int questionCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestResult() when $default != null:
return $default(_that.correct,_that.listeningCorrect,_that.readingCorrect,_that.questionCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int correct,  int listeningCorrect,  int readingCorrect,  int questionCount)  $default,) {final _that = this;
switch (_that) {
case _ContestResult():
return $default(_that.correct,_that.listeningCorrect,_that.readingCorrect,_that.questionCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int correct,  int listeningCorrect,  int readingCorrect,  int questionCount)?  $default,) {final _that = this;
switch (_that) {
case _ContestResult() when $default != null:
return $default(_that.correct,_that.listeningCorrect,_that.readingCorrect,_that.questionCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestResult implements ContestResult {
  const _ContestResult({required this.correct, required this.listeningCorrect, required this.readingCorrect, required this.questionCount});
  factory _ContestResult.fromJson(Map<String, dynamic> json) => _$ContestResultFromJson(json);

@override final  int correct;
@override final  int listeningCorrect;
@override final  int readingCorrect;
@override final  int questionCount;

/// Create a copy of ContestResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestResultCopyWith<_ContestResult> get copyWith => __$ContestResultCopyWithImpl<_ContestResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestResult&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.listeningCorrect, listeningCorrect) || other.listeningCorrect == listeningCorrect)&&(identical(other.readingCorrect, readingCorrect) || other.readingCorrect == readingCorrect)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,correct,listeningCorrect,readingCorrect,questionCount);
}

@override
String toString() {
    return 'ContestResult(correct: $correct, listeningCorrect: $listeningCorrect, readingCorrect: $readingCorrect, questionCount: $questionCount)';
}


}

/// @nodoc
abstract mixin class _$ContestResultCopyWith<$Res> implements $ContestResultCopyWith<$Res> {
  factory _$ContestResultCopyWith(_ContestResult value, $Res Function(_ContestResult) _then) = __$ContestResultCopyWithImpl;
@override @useResult
$Res call({
 int correct, int listeningCorrect, int readingCorrect, int questionCount
});




}
/// @nodoc
class __$ContestResultCopyWithImpl<$Res>
    implements _$ContestResultCopyWith<$Res> {
  __$ContestResultCopyWithImpl(this._self, this._then);

  final _ContestResult _self;
  final $Res Function(_ContestResult) _then;

/// Create a copy of ContestResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? correct = null,Object? listeningCorrect = null,Object? readingCorrect = null,Object? questionCount = null,}) {
  return _then(_ContestResult(
correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,listeningCorrect: null == listeningCorrect ? _self.listeningCorrect : listeningCorrect // ignore: cast_nullable_to_non_nullable
as int,readingCorrect: null == readingCorrect ? _self.readingCorrect : readingCorrect // ignore: cast_nullable_to_non_nullable
as int,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$ContestRank {

 int get rank; String get displayName; bool get isMe; int get correct; int get durationMs; int get total;/// % người thi xếp sau mình (chỉ có khi mình đã nộp).
 int? get percentile;
/// Create a copy of ContestRank
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestRankCopyWith<ContestRank> get copyWith => _$ContestRankCopyWithImpl<ContestRank>(this as ContestRank, _$identity);

  /// Serializes this ContestRank to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContestRank;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestRank&&(identical(other.rank, _this.rank) || other.rank == _this.rank)&&(identical(other.displayName, _this.displayName) || other.displayName == _this.displayName)&&(identical(other.isMe, _this.isMe) || other.isMe == _this.isMe)&&(identical(other.correct, _this.correct) || other.correct == _this.correct)&&(identical(other.durationMs, _this.durationMs) || other.durationMs == _this.durationMs)&&(identical(other.total, _this.total) || other.total == _this.total)&&(identical(other.percentile, _this.percentile) || other.percentile == _this.percentile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContestRank;
  return Object.hash(runtimeType,_this.rank,_this.displayName,_this.isMe,_this.correct,_this.durationMs,_this.total,_this.percentile);
}

@override
String toString() {
  final _this = this as ContestRank;
  return 'ContestRank(rank: ${_this.rank}, displayName: ${_this.displayName}, isMe: ${_this.isMe}, correct: ${_this.correct}, durationMs: ${_this.durationMs}, total: ${_this.total}, percentile: ${_this.percentile})';
}


}

/// @nodoc
abstract mixin class $ContestRankCopyWith<$Res>  {
  factory $ContestRankCopyWith(ContestRank value, $Res Function(ContestRank) _then) = _$ContestRankCopyWithImpl;
@useResult
$Res call({
 int rank, String displayName, bool isMe, int correct, int durationMs, int total, int? percentile
});




}
/// @nodoc
class _$ContestRankCopyWithImpl<$Res>
    implements $ContestRankCopyWith<$Res> {
  _$ContestRankCopyWithImpl(this._self, this._then);

  final ContestRank _self;
  final $Res Function(ContestRank) _then;

/// Create a copy of ContestRank
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rank = null,Object? displayName = null,Object? isMe = null,Object? correct = null,Object? durationMs = null,Object? total = null,Object? percentile = freezed,}) {
  return _then(ContestRank(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percentile: freezed == percentile ? _self.percentile : percentile // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [ContestRank].
extension ContestRankPatterns on ContestRank {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestRank value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestRank() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestRank value)  $default,){
final _that = this;
switch (_that) {
case _ContestRank():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestRank value)?  $default,){
final _that = this;
switch (_that) {
case _ContestRank() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int rank,  String displayName,  bool isMe,  int correct,  int durationMs,  int total,  int? percentile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestRank() when $default != null:
return $default(_that.rank,_that.displayName,_that.isMe,_that.correct,_that.durationMs,_that.total,_that.percentile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int rank,  String displayName,  bool isMe,  int correct,  int durationMs,  int total,  int? percentile)  $default,) {final _that = this;
switch (_that) {
case _ContestRank():
return $default(_that.rank,_that.displayName,_that.isMe,_that.correct,_that.durationMs,_that.total,_that.percentile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int rank,  String displayName,  bool isMe,  int correct,  int durationMs,  int total,  int? percentile)?  $default,) {final _that = this;
switch (_that) {
case _ContestRank() when $default != null:
return $default(_that.rank,_that.displayName,_that.isMe,_that.correct,_that.durationMs,_that.total,_that.percentile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestRank implements ContestRank {
  const _ContestRank({required this.rank, required this.displayName, this.isMe = false, required this.correct, required this.durationMs, required this.total, this.percentile});
  factory _ContestRank.fromJson(Map<String, dynamic> json) => _$ContestRankFromJson(json);

@override final  int rank;
@override final  String displayName;
@override@JsonKey() final  bool isMe;
@override final  int correct;
@override final  int durationMs;
@override final  int total;
/// % người thi xếp sau mình (chỉ có khi mình đã nộp).
@override final  int? percentile;

/// Create a copy of ContestRank
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestRankCopyWith<_ContestRank> get copyWith => __$ContestRankCopyWithImpl<_ContestRank>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestRankToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestRank&&(identical(other.rank, rank) || other.rank == rank)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.isMe, isMe) || other.isMe == isMe)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.durationMs, durationMs) || other.durationMs == durationMs)&&(identical(other.total, total) || other.total == total)&&(identical(other.percentile, percentile) || other.percentile == percentile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,rank,displayName,isMe,correct,durationMs,total,percentile);
}

@override
String toString() {
    return 'ContestRank(rank: $rank, displayName: $displayName, isMe: $isMe, correct: $correct, durationMs: $durationMs, total: $total, percentile: $percentile)';
}


}

/// @nodoc
abstract mixin class _$ContestRankCopyWith<$Res> implements $ContestRankCopyWith<$Res> {
  factory _$ContestRankCopyWith(_ContestRank value, $Res Function(_ContestRank) _then) = __$ContestRankCopyWithImpl;
@override @useResult
$Res call({
 int rank, String displayName, bool isMe, int correct, int durationMs, int total, int? percentile
});




}
/// @nodoc
class __$ContestRankCopyWithImpl<$Res>
    implements _$ContestRankCopyWith<$Res> {
  __$ContestRankCopyWithImpl(this._self, this._then);

  final _ContestRank _self;
  final $Res Function(_ContestRank) _then;

/// Create a copy of ContestRank
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rank = null,Object? displayName = null,Object? isMe = null,Object? correct = null,Object? durationMs = null,Object? total = null,Object? percentile = freezed,}) {
  return _then(_ContestRank(
rank: null == rank ? _self.rank : rank // ignore: cast_nullable_to_non_nullable
as int,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,isMe: null == isMe ? _self.isMe : isMe // ignore: cast_nullable_to_non_nullable
as bool,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,durationMs: null == durationMs ? _self.durationMs : durationMs // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,percentile: freezed == percentile ? _self.percentile : percentile // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$ReviewKey {

 String get a; String? get e;
/// Create a copy of ReviewKey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewKeyCopyWith<ReviewKey> get copyWith => _$ReviewKeyCopyWithImpl<ReviewKey>(this as ReviewKey, _$identity);

  /// Serializes this ReviewKey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ReviewKey;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewKey&&(identical(other.a, _this.a) || other.a == _this.a)&&(identical(other.e, _this.e) || other.e == _this.e));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ReviewKey;
  return Object.hash(runtimeType,_this.a,_this.e);
}

@override
String toString() {
  final _this = this as ReviewKey;
  return 'ReviewKey(a: ${_this.a}, e: ${_this.e})';
}


}

/// @nodoc
abstract mixin class $ReviewKeyCopyWith<$Res>  {
  factory $ReviewKeyCopyWith(ReviewKey value, $Res Function(ReviewKey) _then) = _$ReviewKeyCopyWithImpl;
@useResult
$Res call({
 String a, String? e
});




}
/// @nodoc
class _$ReviewKeyCopyWithImpl<$Res>
    implements $ReviewKeyCopyWith<$Res> {
  _$ReviewKeyCopyWithImpl(this._self, this._then);

  final ReviewKey _self;
  final $Res Function(ReviewKey) _then;

/// Create a copy of ReviewKey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? a = null,Object? e = freezed,}) {
  return _then(ReviewKey(
a: null == a ? _self.a : a // ignore: cast_nullable_to_non_nullable
as String,e: freezed == e ? _self.e : e // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewKey].
extension ReviewKeyPatterns on ReviewKey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewKey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewKey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewKey value)  $default,){
final _that = this;
switch (_that) {
case _ReviewKey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewKey value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewKey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String a,  String? e)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewKey() when $default != null:
return $default(_that.a,_that.e);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String a,  String? e)  $default,) {final _that = this;
switch (_that) {
case _ReviewKey():
return $default(_that.a,_that.e);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String a,  String? e)?  $default,) {final _that = this;
switch (_that) {
case _ReviewKey() when $default != null:
return $default(_that.a,_that.e);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReviewKey implements ReviewKey {
  const _ReviewKey({required this.a, this.e});
  factory _ReviewKey.fromJson(Map<String, dynamic> json) => _$ReviewKeyFromJson(json);

@override final  String a;
@override final  String? e;

/// Create a copy of ReviewKey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewKeyCopyWith<_ReviewKey> get copyWith => __$ReviewKeyCopyWithImpl<_ReviewKey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewKeyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewKey&&(identical(other.a, a) || other.a == a)&&(identical(other.e, e) || other.e == e));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,a,e);
}

@override
String toString() {
    return 'ReviewKey(a: $a, e: $e)';
}


}

/// @nodoc
abstract mixin class _$ReviewKeyCopyWith<$Res> implements $ReviewKeyCopyWith<$Res> {
  factory _$ReviewKeyCopyWith(_ReviewKey value, $Res Function(_ReviewKey) _then) = __$ReviewKeyCopyWithImpl;
@override @useResult
$Res call({
 String a, String? e
});




}
/// @nodoc
class __$ReviewKeyCopyWithImpl<$Res>
    implements _$ReviewKeyCopyWith<$Res> {
  __$ReviewKeyCopyWithImpl(this._self, this._then);

  final _ReviewKey _self;
  final $Res Function(_ReviewKey) _then;

/// Create a copy of ReviewKey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? a = null,Object? e = freezed,}) {
  return _then(_ReviewKey(
a: null == a ? _self.a : a // ignore: cast_nullable_to_non_nullable
as String,e: freezed == e ? _self.e : e // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ContestReview {

 String get id; String get title; List<PaperGroup> get groups; Map<String, String> get answers; Map<String, ReviewKey> get key;
/// Create a copy of ContestReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestReviewCopyWith<ContestReview> get copyWith => _$ContestReviewCopyWithImpl<ContestReview>(this as ContestReview, _$identity);

  /// Serializes this ContestReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContestReview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestReview&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&const DeepCollectionEquality().equals(other.groups, _this.groups)&&const DeepCollectionEquality().equals(other.answers, _this.answers)&&const DeepCollectionEquality().equals(other.key, _this.key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContestReview;
  return Object.hash(runtimeType,_this.id,_this.title,const DeepCollectionEquality().hash(_this.groups),const DeepCollectionEquality().hash(_this.answers),const DeepCollectionEquality().hash(_this.key));
}

@override
String toString() {
  final _this = this as ContestReview;
  return 'ContestReview(id: ${_this.id}, title: ${_this.title}, groups: ${_this.groups}, answers: ${_this.answers}, key: ${_this.key})';
}


}

/// @nodoc
abstract mixin class $ContestReviewCopyWith<$Res>  {
  factory $ContestReviewCopyWith(ContestReview value, $Res Function(ContestReview) _then) = _$ContestReviewCopyWithImpl;
@useResult
$Res call({
 String id, String title, List<PaperGroup> groups, Map<String, String> answers, Map<String, ReviewKey> key
});




}
/// @nodoc
class _$ContestReviewCopyWithImpl<$Res>
    implements $ContestReviewCopyWith<$Res> {
  _$ContestReviewCopyWithImpl(this._self, this._then);

  final ContestReview _self;
  final $Res Function(ContestReview) _then;

/// Create a copy of ContestReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? groups = null,Object? answers = null,Object? key = null,}) {
  return _then(ContestReview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,groups: null == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<PaperGroup>,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as Map<String, ReviewKey>,
  ));
}

}


/// Adds pattern-matching-related methods to [ContestReview].
extension ContestReviewPatterns on ContestReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestReview value)  $default,){
final _that = this;
switch (_that) {
case _ContestReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestReview value)?  $default,){
final _that = this;
switch (_that) {
case _ContestReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  List<PaperGroup> groups,  Map<String, String> answers,  Map<String, ReviewKey> key)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestReview() when $default != null:
return $default(_that.id,_that.title,_that.groups,_that.answers,_that.key);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  List<PaperGroup> groups,  Map<String, String> answers,  Map<String, ReviewKey> key)  $default,) {final _that = this;
switch (_that) {
case _ContestReview():
return $default(_that.id,_that.title,_that.groups,_that.answers,_that.key);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  List<PaperGroup> groups,  Map<String, String> answers,  Map<String, ReviewKey> key)?  $default,) {final _that = this;
switch (_that) {
case _ContestReview() when $default != null:
return $default(_that.id,_that.title,_that.groups,_that.answers,_that.key);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestReview implements ContestReview {
  const _ContestReview({required this.id, required this.title,  List<PaperGroup> groups = const <PaperGroup>[],  Map<String, String> answers = const <String, String>{},  Map<String, ReviewKey> key = const <String, ReviewKey>{}}): _groups = groups,_answers = answers,_key = key;
  factory _ContestReview.fromJson(Map<String, dynamic> json) => _$ContestReviewFromJson(json);

@override final  String id;
@override final  String title;
 final  List<PaperGroup> _groups;
@override@JsonKey() List<PaperGroup> get groups {
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groups);
}

 final  Map<String, String> _answers;
@override@JsonKey() Map<String, String> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}

 final  Map<String, ReviewKey> _key;
@override@JsonKey() Map<String, ReviewKey> get key {
  if (_key is EqualUnmodifiableMapView) return _key;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_key);
}


/// Create a copy of ContestReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestReviewCopyWith<_ContestReview> get copyWith => __$ContestReviewCopyWithImpl<_ContestReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestReviewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestReview&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&const DeepCollectionEquality().equals(other.groups, _groups)&&const DeepCollectionEquality().equals(other.answers, _answers)&&const DeepCollectionEquality().equals(other.key, _key));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,const DeepCollectionEquality().hash(_groups),const DeepCollectionEquality().hash(_answers),const DeepCollectionEquality().hash(_key));
}

@override
String toString() {
    return 'ContestReview(id: $id, title: $title, groups: $groups, answers: $answers, key: $key)';
}


}

/// @nodoc
abstract mixin class _$ContestReviewCopyWith<$Res> implements $ContestReviewCopyWith<$Res> {
  factory _$ContestReviewCopyWith(_ContestReview value, $Res Function(_ContestReview) _then) = __$ContestReviewCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, List<PaperGroup> groups, Map<String, String> answers, Map<String, ReviewKey> key
});




}
/// @nodoc
class __$ContestReviewCopyWithImpl<$Res>
    implements _$ContestReviewCopyWith<$Res> {
  __$ContestReviewCopyWithImpl(this._self, this._then);

  final _ContestReview _self;
  final $Res Function(_ContestReview) _then;

/// Create a copy of ContestReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? groups = null,Object? answers = null,Object? key = null,}) {
  return _then(_ContestReview(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,groups: null == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<PaperGroup>,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,key: null == key ? _self._key : key // ignore: cast_nullable_to_non_nullable
as Map<String, ReviewKey>,
  ));
}


}


/// @nodoc
mixin _$DuelRules {

 int get questions; int get secondsPerQuestion; int get maxSeconds; int get freePerDay;
/// Create a copy of DuelRules
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuelRulesCopyWith<DuelRules> get copyWith => _$DuelRulesCopyWithImpl<DuelRules>(this as DuelRules, _$identity);

  /// Serializes this DuelRules to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DuelRules;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuelRules&&(identical(other.questions, _this.questions) || other.questions == _this.questions)&&(identical(other.secondsPerQuestion, _this.secondsPerQuestion) || other.secondsPerQuestion == _this.secondsPerQuestion)&&(identical(other.maxSeconds, _this.maxSeconds) || other.maxSeconds == _this.maxSeconds)&&(identical(other.freePerDay, _this.freePerDay) || other.freePerDay == _this.freePerDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DuelRules;
  return Object.hash(runtimeType,_this.questions,_this.secondsPerQuestion,_this.maxSeconds,_this.freePerDay);
}

@override
String toString() {
  final _this = this as DuelRules;
  return 'DuelRules(questions: ${_this.questions}, secondsPerQuestion: ${_this.secondsPerQuestion}, maxSeconds: ${_this.maxSeconds}, freePerDay: ${_this.freePerDay})';
}


}

/// @nodoc
abstract mixin class $DuelRulesCopyWith<$Res>  {
  factory $DuelRulesCopyWith(DuelRules value, $Res Function(DuelRules) _then) = _$DuelRulesCopyWithImpl;
@useResult
$Res call({
 int questions, int secondsPerQuestion, int maxSeconds, int freePerDay
});




}
/// @nodoc
class _$DuelRulesCopyWithImpl<$Res>
    implements $DuelRulesCopyWith<$Res> {
  _$DuelRulesCopyWithImpl(this._self, this._then);

  final DuelRules _self;
  final $Res Function(DuelRules) _then;

/// Create a copy of DuelRules
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? questions = null,Object? secondsPerQuestion = null,Object? maxSeconds = null,Object? freePerDay = null,}) {
  return _then(DuelRules(
questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as int,secondsPerQuestion: null == secondsPerQuestion ? _self.secondsPerQuestion : secondsPerQuestion // ignore: cast_nullable_to_non_nullable
as int,maxSeconds: null == maxSeconds ? _self.maxSeconds : maxSeconds // ignore: cast_nullable_to_non_nullable
as int,freePerDay: null == freePerDay ? _self.freePerDay : freePerDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DuelRules].
extension DuelRulesPatterns on DuelRules {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuelRules value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuelRules() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuelRules value)  $default,){
final _that = this;
switch (_that) {
case _DuelRules():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuelRules value)?  $default,){
final _that = this;
switch (_that) {
case _DuelRules() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int questions,  int secondsPerQuestion,  int maxSeconds,  int freePerDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DuelRules() when $default != null:
return $default(_that.questions,_that.secondsPerQuestion,_that.maxSeconds,_that.freePerDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int questions,  int secondsPerQuestion,  int maxSeconds,  int freePerDay)  $default,) {final _that = this;
switch (_that) {
case _DuelRules():
return $default(_that.questions,_that.secondsPerQuestion,_that.maxSeconds,_that.freePerDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int questions,  int secondsPerQuestion,  int maxSeconds,  int freePerDay)?  $default,) {final _that = this;
switch (_that) {
case _DuelRules() when $default != null:
return $default(_that.questions,_that.secondsPerQuestion,_that.maxSeconds,_that.freePerDay);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DuelRules implements DuelRules {
  const _DuelRules({this.questions = 10, this.secondsPerQuestion = 20, this.maxSeconds = 240, this.freePerDay = 3});
  factory _DuelRules.fromJson(Map<String, dynamic> json) => _$DuelRulesFromJson(json);

@override@JsonKey() final  int questions;
@override@JsonKey() final  int secondsPerQuestion;
@override@JsonKey() final  int maxSeconds;
@override@JsonKey() final  int freePerDay;

/// Create a copy of DuelRules
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuelRulesCopyWith<_DuelRules> get copyWith => __$DuelRulesCopyWithImpl<_DuelRules>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuelRulesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuelRules&&(identical(other.questions, questions) || other.questions == questions)&&(identical(other.secondsPerQuestion, secondsPerQuestion) || other.secondsPerQuestion == secondsPerQuestion)&&(identical(other.maxSeconds, maxSeconds) || other.maxSeconds == maxSeconds)&&(identical(other.freePerDay, freePerDay) || other.freePerDay == freePerDay));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,questions,secondsPerQuestion,maxSeconds,freePerDay);
}

@override
String toString() {
    return 'DuelRules(questions: $questions, secondsPerQuestion: $secondsPerQuestion, maxSeconds: $maxSeconds, freePerDay: $freePerDay)';
}


}

/// @nodoc
abstract mixin class _$DuelRulesCopyWith<$Res> implements $DuelRulesCopyWith<$Res> {
  factory _$DuelRulesCopyWith(_DuelRules value, $Res Function(_DuelRules) _then) = __$DuelRulesCopyWithImpl;
@override @useResult
$Res call({
 int questions, int secondsPerQuestion, int maxSeconds, int freePerDay
});




}
/// @nodoc
class __$DuelRulesCopyWithImpl<$Res>
    implements _$DuelRulesCopyWith<$Res> {
  __$DuelRulesCopyWithImpl(this._self, this._then);

  final _DuelRules _self;
  final $Res Function(_DuelRules) _then;

/// Create a copy of DuelRules
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? questions = null,Object? secondsPerQuestion = null,Object? maxSeconds = null,Object? freePerDay = null,}) {
  return _then(_DuelRules(
questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as int,secondsPerQuestion: null == secondsPerQuestion ? _self.secondsPerQuestion : secondsPerQuestion // ignore: cast_nullable_to_non_nullable
as int,maxSeconds: null == maxSeconds ? _self.maxSeconds : maxSeconds // ignore: cast_nullable_to_non_nullable
as int,freePerDay: null == freePerDay ? _self.freePerDay : freePerDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DuelSide {

 String get name; bool get isBot; int get answered; int get correct; int get timeMs; bool get finished;
/// Create a copy of DuelSide
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuelSideCopyWith<DuelSide> get copyWith => _$DuelSideCopyWithImpl<DuelSide>(this as DuelSide, _$identity);

  /// Serializes this DuelSide to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DuelSide;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuelSide&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.isBot, _this.isBot) || other.isBot == _this.isBot)&&(identical(other.answered, _this.answered) || other.answered == _this.answered)&&(identical(other.correct, _this.correct) || other.correct == _this.correct)&&(identical(other.timeMs, _this.timeMs) || other.timeMs == _this.timeMs)&&(identical(other.finished, _this.finished) || other.finished == _this.finished));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DuelSide;
  return Object.hash(runtimeType,_this.name,_this.isBot,_this.answered,_this.correct,_this.timeMs,_this.finished);
}

@override
String toString() {
  final _this = this as DuelSide;
  return 'DuelSide(name: ${_this.name}, isBot: ${_this.isBot}, answered: ${_this.answered}, correct: ${_this.correct}, timeMs: ${_this.timeMs}, finished: ${_this.finished})';
}


}

/// @nodoc
abstract mixin class $DuelSideCopyWith<$Res>  {
  factory $DuelSideCopyWith(DuelSide value, $Res Function(DuelSide) _then) = _$DuelSideCopyWithImpl;
@useResult
$Res call({
 String name, bool isBot, int answered, int correct, int timeMs, bool finished
});




}
/// @nodoc
class _$DuelSideCopyWithImpl<$Res>
    implements $DuelSideCopyWith<$Res> {
  _$DuelSideCopyWithImpl(this._self, this._then);

  final DuelSide _self;
  final $Res Function(DuelSide) _then;

/// Create a copy of DuelSide
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? isBot = null,Object? answered = null,Object? correct = null,Object? timeMs = null,Object? finished = null,}) {
  return _then(DuelSide(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isBot: null == isBot ? _self.isBot : isBot // ignore: cast_nullable_to_non_nullable
as bool,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,timeMs: null == timeMs ? _self.timeMs : timeMs // ignore: cast_nullable_to_non_nullable
as int,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DuelSide].
extension DuelSidePatterns on DuelSide {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuelSide value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuelSide() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuelSide value)  $default,){
final _that = this;
switch (_that) {
case _DuelSide():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuelSide value)?  $default,){
final _that = this;
switch (_that) {
case _DuelSide() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  bool isBot,  int answered,  int correct,  int timeMs,  bool finished)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DuelSide() when $default != null:
return $default(_that.name,_that.isBot,_that.answered,_that.correct,_that.timeMs,_that.finished);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  bool isBot,  int answered,  int correct,  int timeMs,  bool finished)  $default,) {final _that = this;
switch (_that) {
case _DuelSide():
return $default(_that.name,_that.isBot,_that.answered,_that.correct,_that.timeMs,_that.finished);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  bool isBot,  int answered,  int correct,  int timeMs,  bool finished)?  $default,) {final _that = this;
switch (_that) {
case _DuelSide() when $default != null:
return $default(_that.name,_that.isBot,_that.answered,_that.correct,_that.timeMs,_that.finished);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DuelSide implements DuelSide {
  const _DuelSide({required this.name, this.isBot = false, this.answered = 0, this.correct = 0, this.timeMs = 0, this.finished = false});
  factory _DuelSide.fromJson(Map<String, dynamic> json) => _$DuelSideFromJson(json);

@override final  String name;
@override@JsonKey() final  bool isBot;
@override@JsonKey() final  int answered;
@override@JsonKey() final  int correct;
@override@JsonKey() final  int timeMs;
@override@JsonKey() final  bool finished;

/// Create a copy of DuelSide
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuelSideCopyWith<_DuelSide> get copyWith => __$DuelSideCopyWithImpl<_DuelSide>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuelSideToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuelSide&&(identical(other.name, name) || other.name == name)&&(identical(other.isBot, isBot) || other.isBot == isBot)&&(identical(other.answered, answered) || other.answered == answered)&&(identical(other.correct, correct) || other.correct == correct)&&(identical(other.timeMs, timeMs) || other.timeMs == timeMs)&&(identical(other.finished, finished) || other.finished == finished));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,isBot,answered,correct,timeMs,finished);
}

@override
String toString() {
    return 'DuelSide(name: $name, isBot: $isBot, answered: $answered, correct: $correct, timeMs: $timeMs, finished: $finished)';
}


}

/// @nodoc
abstract mixin class _$DuelSideCopyWith<$Res> implements $DuelSideCopyWith<$Res> {
  factory _$DuelSideCopyWith(_DuelSide value, $Res Function(_DuelSide) _then) = __$DuelSideCopyWithImpl;
@override @useResult
$Res call({
 String name, bool isBot, int answered, int correct, int timeMs, bool finished
});




}
/// @nodoc
class __$DuelSideCopyWithImpl<$Res>
    implements _$DuelSideCopyWith<$Res> {
  __$DuelSideCopyWithImpl(this._self, this._then);

  final _DuelSide _self;
  final $Res Function(_DuelSide) _then;

/// Create a copy of DuelSide
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? isBot = null,Object? answered = null,Object? correct = null,Object? timeMs = null,Object? finished = null,}) {
  return _then(_DuelSide(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,isBot: null == isBot ? _self.isBot : isBot // ignore: cast_nullable_to_non_nullable
as bool,answered: null == answered ? _self.answered : answered // ignore: cast_nullable_to_non_nullable
as int,correct: null == correct ? _self.correct : correct // ignore: cast_nullable_to_non_nullable
as int,timeMs: null == timeMs ? _self.timeMs : timeMs // ignore: cast_nullable_to_non_nullable
as int,finished: null == finished ? _self.finished : finished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$DuelState {

 String get id;@JsonKey(unknownEnumValue: DuelStatus.cancelled) DuelStatus get status; String? get code; DateTime get serverNow; DateTime? get startedAt; int get questionCount; DuelRules get rules; DuelSide get me; DuelSide? get opponent; String? get winner;
/// Create a copy of DuelState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuelStateCopyWith<DuelState> get copyWith => _$DuelStateCopyWithImpl<DuelState>(this as DuelState, _$identity);

  /// Serializes this DuelState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DuelState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuelState&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.code, _this.code) || other.code == _this.code)&&(identical(other.serverNow, _this.serverNow) || other.serverNow == _this.serverNow)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.questionCount, _this.questionCount) || other.questionCount == _this.questionCount)&&(identical(other.rules, _this.rules) || other.rules == _this.rules)&&(identical(other.me, _this.me) || other.me == _this.me)&&(identical(other.opponent, _this.opponent) || other.opponent == _this.opponent)&&(identical(other.winner, _this.winner) || other.winner == _this.winner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DuelState;
  return Object.hash(runtimeType,_this.id,_this.status,_this.code,_this.serverNow,_this.startedAt,_this.questionCount,_this.rules,_this.me,_this.opponent,_this.winner);
}

@override
String toString() {
  final _this = this as DuelState;
  return 'DuelState(id: ${_this.id}, status: ${_this.status}, code: ${_this.code}, serverNow: ${_this.serverNow}, startedAt: ${_this.startedAt}, questionCount: ${_this.questionCount}, rules: ${_this.rules}, me: ${_this.me}, opponent: ${_this.opponent}, winner: ${_this.winner})';
}


}

/// @nodoc
abstract mixin class $DuelStateCopyWith<$Res>  {
  factory $DuelStateCopyWith(DuelState value, $Res Function(DuelState) _then) = _$DuelStateCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: DuelStatus.cancelled) DuelStatus status, String? code, DateTime serverNow, DateTime? startedAt, int questionCount, DuelRules rules, DuelSide me, DuelSide? opponent, String? winner
});


$DuelRulesCopyWith<$Res> get rules;$DuelSideCopyWith<$Res> get me;$DuelSideCopyWith<$Res>? get opponent;

}
/// @nodoc
class _$DuelStateCopyWithImpl<$Res>
    implements $DuelStateCopyWith<$Res> {
  _$DuelStateCopyWithImpl(this._self, this._then);

  final DuelState _self;
  final $Res Function(DuelState) _then;

/// Create a copy of DuelState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? code = freezed,Object? serverNow = null,Object? startedAt = freezed,Object? questionCount = null,Object? rules = null,Object? me = null,Object? opponent = freezed,Object? winner = freezed,}) {
  return _then(DuelState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DuelStatus,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,serverNow: null == serverNow ? _self.serverNow : serverNow // ignore: cast_nullable_to_non_nullable
as DateTime,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as DuelRules,me: null == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as DuelSide,opponent: freezed == opponent ? _self.opponent : opponent // ignore: cast_nullable_to_non_nullable
as DuelSide?,winner: freezed == winner ? _self.winner : winner // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of DuelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuelRulesCopyWith<$Res> get rules {
  
  return $DuelRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}/// Create a copy of DuelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuelSideCopyWith<$Res> get me {
  
  return $DuelSideCopyWith<$Res>(_self.me, (value) {
    return _then(_self.copyWith(me: value));
  });
}/// Create a copy of DuelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuelSideCopyWith<$Res>? get opponent {
    if (_self.opponent == null) {
    return null;
  }

  return $DuelSideCopyWith<$Res>(_self.opponent!, (value) {
    return _then(_self.copyWith(opponent: value));
  });
}
}


/// Adds pattern-matching-related methods to [DuelState].
extension DuelStatePatterns on DuelState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuelState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuelState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuelState value)  $default,){
final _that = this;
switch (_that) {
case _DuelState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuelState value)?  $default,){
final _that = this;
switch (_that) {
case _DuelState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: DuelStatus.cancelled)  DuelStatus status,  String? code,  DateTime serverNow,  DateTime? startedAt,  int questionCount,  DuelRules rules,  DuelSide me,  DuelSide? opponent,  String? winner)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DuelState() when $default != null:
return $default(_that.id,_that.status,_that.code,_that.serverNow,_that.startedAt,_that.questionCount,_that.rules,_that.me,_that.opponent,_that.winner);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(unknownEnumValue: DuelStatus.cancelled)  DuelStatus status,  String? code,  DateTime serverNow,  DateTime? startedAt,  int questionCount,  DuelRules rules,  DuelSide me,  DuelSide? opponent,  String? winner)  $default,) {final _that = this;
switch (_that) {
case _DuelState():
return $default(_that.id,_that.status,_that.code,_that.serverNow,_that.startedAt,_that.questionCount,_that.rules,_that.me,_that.opponent,_that.winner);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(unknownEnumValue: DuelStatus.cancelled)  DuelStatus status,  String? code,  DateTime serverNow,  DateTime? startedAt,  int questionCount,  DuelRules rules,  DuelSide me,  DuelSide? opponent,  String? winner)?  $default,) {final _that = this;
switch (_that) {
case _DuelState() when $default != null:
return $default(_that.id,_that.status,_that.code,_that.serverNow,_that.startedAt,_that.questionCount,_that.rules,_that.me,_that.opponent,_that.winner);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DuelState extends DuelState {
  const _DuelState({required this.id, @JsonKey(unknownEnumValue: DuelStatus.cancelled) required this.status, this.code, required this.serverNow, this.startedAt, required this.questionCount, this.rules = const DuelRules(), required this.me, this.opponent, this.winner}): super._();
  factory _DuelState.fromJson(Map<String, dynamic> json) => _$DuelStateFromJson(json);

@override final  String id;
@override@JsonKey(unknownEnumValue: DuelStatus.cancelled) final  DuelStatus status;
@override final  String? code;
@override final  DateTime serverNow;
@override final  DateTime? startedAt;
@override final  int questionCount;
@override@JsonKey() final  DuelRules rules;
@override final  DuelSide me;
@override final  DuelSide? opponent;
@override final  String? winner;

/// Create a copy of DuelState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuelStateCopyWith<_DuelState> get copyWith => __$DuelStateCopyWithImpl<_DuelState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuelStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuelState&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.code, code) || other.code == code)&&(identical(other.serverNow, serverNow) || other.serverNow == serverNow)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.questionCount, questionCount) || other.questionCount == questionCount)&&(identical(other.rules, rules) || other.rules == rules)&&(identical(other.me, me) || other.me == me)&&(identical(other.opponent, opponent) || other.opponent == opponent)&&(identical(other.winner, winner) || other.winner == winner));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,code,serverNow,startedAt,questionCount,rules,me,opponent,winner);
}

@override
String toString() {
    return 'DuelState(id: $id, status: $status, code: $code, serverNow: $serverNow, startedAt: $startedAt, questionCount: $questionCount, rules: $rules, me: $me, opponent: $opponent, winner: $winner)';
}


}

/// @nodoc
abstract mixin class _$DuelStateCopyWith<$Res> implements $DuelStateCopyWith<$Res> {
  factory _$DuelStateCopyWith(_DuelState value, $Res Function(_DuelState) _then) = __$DuelStateCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(unknownEnumValue: DuelStatus.cancelled) DuelStatus status, String? code, DateTime serverNow, DateTime? startedAt, int questionCount, DuelRules rules, DuelSide me, DuelSide? opponent, String? winner
});


@override $DuelRulesCopyWith<$Res> get rules;@override $DuelSideCopyWith<$Res> get me;@override $DuelSideCopyWith<$Res>? get opponent;

}
/// @nodoc
class __$DuelStateCopyWithImpl<$Res>
    implements _$DuelStateCopyWith<$Res> {
  __$DuelStateCopyWithImpl(this._self, this._then);

  final _DuelState _self;
  final $Res Function(_DuelState) _then;

/// Create a copy of DuelState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? code = freezed,Object? serverNow = null,Object? startedAt = freezed,Object? questionCount = null,Object? rules = null,Object? me = null,Object? opponent = freezed,Object? winner = freezed,}) {
  return _then(_DuelState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as DuelStatus,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,serverNow: null == serverNow ? _self.serverNow : serverNow // ignore: cast_nullable_to_non_nullable
as DateTime,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,questionCount: null == questionCount ? _self.questionCount : questionCount // ignore: cast_nullable_to_non_nullable
as int,rules: null == rules ? _self.rules : rules // ignore: cast_nullable_to_non_nullable
as DuelRules,me: null == me ? _self.me : me // ignore: cast_nullable_to_non_nullable
as DuelSide,opponent: freezed == opponent ? _self.opponent : opponent // ignore: cast_nullable_to_non_nullable
as DuelSide?,winner: freezed == winner ? _self.winner : winner // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of DuelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuelRulesCopyWith<$Res> get rules {
  
  return $DuelRulesCopyWith<$Res>(_self.rules, (value) {
    return _then(_self.copyWith(rules: value));
  });
}/// Create a copy of DuelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuelSideCopyWith<$Res> get me {
  
  return $DuelSideCopyWith<$Res>(_self.me, (value) {
    return _then(_self.copyWith(me: value));
  });
}/// Create a copy of DuelState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DuelSideCopyWith<$Res>? get opponent {
    if (_self.opponent == null) {
    return null;
  }

  return $DuelSideCopyWith<$Res>(_self.opponent!, (value) {
    return _then(_self.copyWith(opponent: value));
  });
}
}


/// @nodoc
mixin _$DuelQuestion {

 int get n; String get content; List<String> get options;
/// Create a copy of DuelQuestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuelQuestionCopyWith<DuelQuestion> get copyWith => _$DuelQuestionCopyWithImpl<DuelQuestion>(this as DuelQuestion, _$identity);

  /// Serializes this DuelQuestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DuelQuestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuelQuestion&&(identical(other.n, _this.n) || other.n == _this.n)&&(identical(other.content, _this.content) || other.content == _this.content)&&const DeepCollectionEquality().equals(other.options, _this.options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DuelQuestion;
  return Object.hash(runtimeType,_this.n,_this.content,const DeepCollectionEquality().hash(_this.options));
}

@override
String toString() {
  final _this = this as DuelQuestion;
  return 'DuelQuestion(n: ${_this.n}, content: ${_this.content}, options: ${_this.options})';
}


}

/// @nodoc
abstract mixin class $DuelQuestionCopyWith<$Res>  {
  factory $DuelQuestionCopyWith(DuelQuestion value, $Res Function(DuelQuestion) _then) = _$DuelQuestionCopyWithImpl;
@useResult
$Res call({
 int n, String content, List<String> options
});




}
/// @nodoc
class _$DuelQuestionCopyWithImpl<$Res>
    implements $DuelQuestionCopyWith<$Res> {
  _$DuelQuestionCopyWithImpl(this._self, this._then);

  final DuelQuestion _self;
  final $Res Function(DuelQuestion) _then;

/// Create a copy of DuelQuestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? n = null,Object? content = null,Object? options = null,}) {
  return _then(DuelQuestion(
n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DuelQuestion].
extension DuelQuestionPatterns on DuelQuestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuelQuestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuelQuestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuelQuestion value)  $default,){
final _that = this;
switch (_that) {
case _DuelQuestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuelQuestion value)?  $default,){
final _that = this;
switch (_that) {
case _DuelQuestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int n,  String content,  List<String> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DuelQuestion() when $default != null:
return $default(_that.n,_that.content,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int n,  String content,  List<String> options)  $default,) {final _that = this;
switch (_that) {
case _DuelQuestion():
return $default(_that.n,_that.content,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int n,  String content,  List<String> options)?  $default,) {final _that = this;
switch (_that) {
case _DuelQuestion() when $default != null:
return $default(_that.n,_that.content,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DuelQuestion implements DuelQuestion {
  const _DuelQuestion({required this.n, required this.content,  List<String> options = const <String>[]}): _options = options;
  factory _DuelQuestion.fromJson(Map<String, dynamic> json) => _$DuelQuestionFromJson(json);

@override final  int n;
@override final  String content;
 final  List<String> _options;
@override@JsonKey() List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of DuelQuestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuelQuestionCopyWith<_DuelQuestion> get copyWith => __$DuelQuestionCopyWithImpl<_DuelQuestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuelQuestionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuelQuestion&&(identical(other.n, n) || other.n == n)&&(identical(other.content, content) || other.content == content)&&const DeepCollectionEquality().equals(other.options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,n,content,const DeepCollectionEquality().hash(_options));
}

@override
String toString() {
    return 'DuelQuestion(n: $n, content: $content, options: $options)';
}


}

/// @nodoc
abstract mixin class _$DuelQuestionCopyWith<$Res> implements $DuelQuestionCopyWith<$Res> {
  factory _$DuelQuestionCopyWith(_DuelQuestion value, $Res Function(_DuelQuestion) _then) = __$DuelQuestionCopyWithImpl;
@override @useResult
$Res call({
 int n, String content, List<String> options
});




}
/// @nodoc
class __$DuelQuestionCopyWithImpl<$Res>
    implements _$DuelQuestionCopyWith<$Res> {
  __$DuelQuestionCopyWithImpl(this._self, this._then);

  final _DuelQuestion _self;
  final $Res Function(_DuelQuestion) _then;

/// Create a copy of DuelQuestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? n = null,Object? content = null,Object? options = null,}) {
  return _then(_DuelQuestion(
n: null == n ? _self.n : n // ignore: cast_nullable_to_non_nullable
as int,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$DuelAnswerResult {

 bool get ok; String get answer; String? get explanation;
/// Create a copy of DuelAnswerResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuelAnswerResultCopyWith<DuelAnswerResult> get copyWith => _$DuelAnswerResultCopyWithImpl<DuelAnswerResult>(this as DuelAnswerResult, _$identity);

  /// Serializes this DuelAnswerResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DuelAnswerResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuelAnswerResult&&(identical(other.ok, _this.ok) || other.ok == _this.ok)&&(identical(other.answer, _this.answer) || other.answer == _this.answer)&&(identical(other.explanation, _this.explanation) || other.explanation == _this.explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DuelAnswerResult;
  return Object.hash(runtimeType,_this.ok,_this.answer,_this.explanation);
}

@override
String toString() {
  final _this = this as DuelAnswerResult;
  return 'DuelAnswerResult(ok: ${_this.ok}, answer: ${_this.answer}, explanation: ${_this.explanation})';
}


}

/// @nodoc
abstract mixin class $DuelAnswerResultCopyWith<$Res>  {
  factory $DuelAnswerResultCopyWith(DuelAnswerResult value, $Res Function(DuelAnswerResult) _then) = _$DuelAnswerResultCopyWithImpl;
@useResult
$Res call({
 bool ok, String answer, String? explanation
});




}
/// @nodoc
class _$DuelAnswerResultCopyWithImpl<$Res>
    implements $DuelAnswerResultCopyWith<$Res> {
  _$DuelAnswerResultCopyWithImpl(this._self, this._then);

  final DuelAnswerResult _self;
  final $Res Function(DuelAnswerResult) _then;

/// Create a copy of DuelAnswerResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ok = null,Object? answer = null,Object? explanation = freezed,}) {
  return _then(DuelAnswerResult(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DuelAnswerResult].
extension DuelAnswerResultPatterns on DuelAnswerResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuelAnswerResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuelAnswerResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuelAnswerResult value)  $default,){
final _that = this;
switch (_that) {
case _DuelAnswerResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuelAnswerResult value)?  $default,){
final _that = this;
switch (_that) {
case _DuelAnswerResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool ok,  String answer,  String? explanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DuelAnswerResult() when $default != null:
return $default(_that.ok,_that.answer,_that.explanation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool ok,  String answer,  String? explanation)  $default,) {final _that = this;
switch (_that) {
case _DuelAnswerResult():
return $default(_that.ok,_that.answer,_that.explanation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool ok,  String answer,  String? explanation)?  $default,) {final _that = this;
switch (_that) {
case _DuelAnswerResult() when $default != null:
return $default(_that.ok,_that.answer,_that.explanation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DuelAnswerResult implements DuelAnswerResult {
  const _DuelAnswerResult({required this.ok, required this.answer, this.explanation});
  factory _DuelAnswerResult.fromJson(Map<String, dynamic> json) => _$DuelAnswerResultFromJson(json);

@override final  bool ok;
@override final  String answer;
@override final  String? explanation;

/// Create a copy of DuelAnswerResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuelAnswerResultCopyWith<_DuelAnswerResult> get copyWith => __$DuelAnswerResultCopyWithImpl<_DuelAnswerResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuelAnswerResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuelAnswerResult&&(identical(other.ok, ok) || other.ok == ok)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ok,answer,explanation);
}

@override
String toString() {
    return 'DuelAnswerResult(ok: $ok, answer: $answer, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class _$DuelAnswerResultCopyWith<$Res> implements $DuelAnswerResultCopyWith<$Res> {
  factory _$DuelAnswerResultCopyWith(_DuelAnswerResult value, $Res Function(_DuelAnswerResult) _then) = __$DuelAnswerResultCopyWithImpl;
@override @useResult
$Res call({
 bool ok, String answer, String? explanation
});




}
/// @nodoc
class __$DuelAnswerResultCopyWithImpl<$Res>
    implements _$DuelAnswerResultCopyWith<$Res> {
  __$DuelAnswerResultCopyWithImpl(this._self, this._then);

  final _DuelAnswerResult _self;
  final $Res Function(_DuelAnswerResult) _then;

/// Create a copy of DuelAnswerResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ok = null,Object? answer = null,Object? explanation = freezed,}) {
  return _then(_DuelAnswerResult(
ok: null == ok ? _self.ok : ok // ignore: cast_nullable_to_non_nullable
as bool,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,explanation: freezed == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DuelStats {

 int get wins; int get losses; int get draws; int get playedToday;/// Lượt miễn phí còn lại hôm nay; null = PRO, không giới hạn.
 int? get leftToday;
/// Create a copy of DuelStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuelStatsCopyWith<DuelStats> get copyWith => _$DuelStatsCopyWithImpl<DuelStats>(this as DuelStats, _$identity);

  /// Serializes this DuelStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DuelStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuelStats&&(identical(other.wins, _this.wins) || other.wins == _this.wins)&&(identical(other.losses, _this.losses) || other.losses == _this.losses)&&(identical(other.draws, _this.draws) || other.draws == _this.draws)&&(identical(other.playedToday, _this.playedToday) || other.playedToday == _this.playedToday)&&(identical(other.leftToday, _this.leftToday) || other.leftToday == _this.leftToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DuelStats;
  return Object.hash(runtimeType,_this.wins,_this.losses,_this.draws,_this.playedToday,_this.leftToday);
}

@override
String toString() {
  final _this = this as DuelStats;
  return 'DuelStats(wins: ${_this.wins}, losses: ${_this.losses}, draws: ${_this.draws}, playedToday: ${_this.playedToday}, leftToday: ${_this.leftToday})';
}


}

/// @nodoc
abstract mixin class $DuelStatsCopyWith<$Res>  {
  factory $DuelStatsCopyWith(DuelStats value, $Res Function(DuelStats) _then) = _$DuelStatsCopyWithImpl;
@useResult
$Res call({
 int wins, int losses, int draws, int playedToday, int? leftToday
});




}
/// @nodoc
class _$DuelStatsCopyWithImpl<$Res>
    implements $DuelStatsCopyWith<$Res> {
  _$DuelStatsCopyWithImpl(this._self, this._then);

  final DuelStats _self;
  final $Res Function(DuelStats) _then;

/// Create a copy of DuelStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wins = null,Object? losses = null,Object? draws = null,Object? playedToday = null,Object? leftToday = freezed,}) {
  return _then(DuelStats(
wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,losses: null == losses ? _self.losses : losses // ignore: cast_nullable_to_non_nullable
as int,draws: null == draws ? _self.draws : draws // ignore: cast_nullable_to_non_nullable
as int,playedToday: null == playedToday ? _self.playedToday : playedToday // ignore: cast_nullable_to_non_nullable
as int,leftToday: freezed == leftToday ? _self.leftToday : leftToday // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [DuelStats].
extension DuelStatsPatterns on DuelStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuelStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuelStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuelStats value)  $default,){
final _that = this;
switch (_that) {
case _DuelStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuelStats value)?  $default,){
final _that = this;
switch (_that) {
case _DuelStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int wins,  int losses,  int draws,  int playedToday,  int? leftToday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DuelStats() when $default != null:
return $default(_that.wins,_that.losses,_that.draws,_that.playedToday,_that.leftToday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int wins,  int losses,  int draws,  int playedToday,  int? leftToday)  $default,) {final _that = this;
switch (_that) {
case _DuelStats():
return $default(_that.wins,_that.losses,_that.draws,_that.playedToday,_that.leftToday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int wins,  int losses,  int draws,  int playedToday,  int? leftToday)?  $default,) {final _that = this;
switch (_that) {
case _DuelStats() when $default != null:
return $default(_that.wins,_that.losses,_that.draws,_that.playedToday,_that.leftToday);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DuelStats implements DuelStats {
  const _DuelStats({this.wins = 0, this.losses = 0, this.draws = 0, this.playedToday = 0, this.leftToday});
  factory _DuelStats.fromJson(Map<String, dynamic> json) => _$DuelStatsFromJson(json);

@override@JsonKey() final  int wins;
@override@JsonKey() final  int losses;
@override@JsonKey() final  int draws;
@override@JsonKey() final  int playedToday;
/// Lượt miễn phí còn lại hôm nay; null = PRO, không giới hạn.
@override final  int? leftToday;

/// Create a copy of DuelStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuelStatsCopyWith<_DuelStats> get copyWith => __$DuelStatsCopyWithImpl<_DuelStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuelStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuelStats&&(identical(other.wins, wins) || other.wins == wins)&&(identical(other.losses, losses) || other.losses == losses)&&(identical(other.draws, draws) || other.draws == draws)&&(identical(other.playedToday, playedToday) || other.playedToday == playedToday)&&(identical(other.leftToday, leftToday) || other.leftToday == leftToday));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,wins,losses,draws,playedToday,leftToday);
}

@override
String toString() {
    return 'DuelStats(wins: $wins, losses: $losses, draws: $draws, playedToday: $playedToday, leftToday: $leftToday)';
}


}

/// @nodoc
abstract mixin class _$DuelStatsCopyWith<$Res> implements $DuelStatsCopyWith<$Res> {
  factory _$DuelStatsCopyWith(_DuelStats value, $Res Function(_DuelStats) _then) = __$DuelStatsCopyWithImpl;
@override @useResult
$Res call({
 int wins, int losses, int draws, int playedToday, int? leftToday
});




}
/// @nodoc
class __$DuelStatsCopyWithImpl<$Res>
    implements _$DuelStatsCopyWith<$Res> {
  __$DuelStatsCopyWithImpl(this._self, this._then);

  final _DuelStats _self;
  final $Res Function(_DuelStats) _then;

/// Create a copy of DuelStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wins = null,Object? losses = null,Object? draws = null,Object? playedToday = null,Object? leftToday = freezed,}) {
  return _then(_DuelStats(
wins: null == wins ? _self.wins : wins // ignore: cast_nullable_to_non_nullable
as int,losses: null == losses ? _self.losses : losses // ignore: cast_nullable_to_non_nullable
as int,draws: null == draws ? _self.draws : draws // ignore: cast_nullable_to_non_nullable
as int,playedToday: null == playedToday ? _self.playedToday : playedToday // ignore: cast_nullable_to_non_nullable
as int,leftToday: freezed == leftToday ? _self.leftToday : leftToday // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$DuelRef {

 String get id; String? get code;
/// Create a copy of DuelRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DuelRefCopyWith<DuelRef> get copyWith => _$DuelRefCopyWithImpl<DuelRef>(this as DuelRef, _$identity);

  /// Serializes this DuelRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DuelRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DuelRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.code, _this.code) || other.code == _this.code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DuelRef;
  return Object.hash(runtimeType,_this.id,_this.code);
}

@override
String toString() {
  final _this = this as DuelRef;
  return 'DuelRef(id: ${_this.id}, code: ${_this.code})';
}


}

/// @nodoc
abstract mixin class $DuelRefCopyWith<$Res>  {
  factory $DuelRefCopyWith(DuelRef value, $Res Function(DuelRef) _then) = _$DuelRefCopyWithImpl;
@useResult
$Res call({
 String id, String? code
});




}
/// @nodoc
class _$DuelRefCopyWithImpl<$Res>
    implements $DuelRefCopyWith<$Res> {
  _$DuelRefCopyWithImpl(this._self, this._then);

  final DuelRef _self;
  final $Res Function(DuelRef) _then;

/// Create a copy of DuelRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? code = freezed,}) {
  return _then(DuelRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DuelRef].
extension DuelRefPatterns on DuelRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DuelRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DuelRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DuelRef value)  $default,){
final _that = this;
switch (_that) {
case _DuelRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DuelRef value)?  $default,){
final _that = this;
switch (_that) {
case _DuelRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? code)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DuelRef() when $default != null:
return $default(_that.id,_that.code);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? code)  $default,) {final _that = this;
switch (_that) {
case _DuelRef():
return $default(_that.id,_that.code);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? code)?  $default,) {final _that = this;
switch (_that) {
case _DuelRef() when $default != null:
return $default(_that.id,_that.code);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DuelRef implements DuelRef {
  const _DuelRef({required this.id, this.code});
  factory _DuelRef.fromJson(Map<String, dynamic> json) => _$DuelRefFromJson(json);

@override final  String id;
@override final  String? code;

/// Create a copy of DuelRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DuelRefCopyWith<_DuelRef> get copyWith => __$DuelRefCopyWithImpl<_DuelRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DuelRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DuelRef&&(identical(other.id, id) || other.id == id)&&(identical(other.code, code) || other.code == code));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,code);
}

@override
String toString() {
    return 'DuelRef(id: $id, code: $code)';
}


}

/// @nodoc
abstract mixin class _$DuelRefCopyWith<$Res> implements $DuelRefCopyWith<$Res> {
  factory _$DuelRefCopyWith(_DuelRef value, $Res Function(_DuelRef) _then) = __$DuelRefCopyWithImpl;
@override @useResult
$Res call({
 String id, String? code
});




}
/// @nodoc
class __$DuelRefCopyWithImpl<$Res>
    implements _$DuelRefCopyWith<$Res> {
  __$DuelRefCopyWithImpl(this._self, this._then);

  final _DuelRef _self;
  final $Res Function(_DuelRef) _then;

/// Create a copy of DuelRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? code = freezed,}) {
  return _then(_DuelRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
