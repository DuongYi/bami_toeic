// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocab_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VocabReview {

 double get ease; int get intervalDays; int get repetitions; DateTime get dueAt;/// Người học đánh dấu "đã biết" → không đưa vào phiên học nữa.
 bool get known;/// Lần đầu học từ này (giới hạn số từ mới mỗi ngày).
 DateTime? get learnedAt;
/// Create a copy of VocabReview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabReviewCopyWith<VocabReview> get copyWith => _$VocabReviewCopyWithImpl<VocabReview>(this as VocabReview, _$identity);

  /// Serializes this VocabReview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VocabReview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabReview&&(identical(other.ease, _this.ease) || other.ease == _this.ease)&&(identical(other.intervalDays, _this.intervalDays) || other.intervalDays == _this.intervalDays)&&(identical(other.repetitions, _this.repetitions) || other.repetitions == _this.repetitions)&&(identical(other.dueAt, _this.dueAt) || other.dueAt == _this.dueAt)&&(identical(other.known, _this.known) || other.known == _this.known)&&(identical(other.learnedAt, _this.learnedAt) || other.learnedAt == _this.learnedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VocabReview;
  return Object.hash(runtimeType,_this.ease,_this.intervalDays,_this.repetitions,_this.dueAt,_this.known,_this.learnedAt);
}

@override
String toString() {
  final _this = this as VocabReview;
  return 'VocabReview(ease: ${_this.ease}, intervalDays: ${_this.intervalDays}, repetitions: ${_this.repetitions}, dueAt: ${_this.dueAt}, known: ${_this.known}, learnedAt: ${_this.learnedAt})';
}


}

/// @nodoc
abstract mixin class $VocabReviewCopyWith<$Res>  {
  factory $VocabReviewCopyWith(VocabReview value, $Res Function(VocabReview) _then) = _$VocabReviewCopyWithImpl;
@useResult
$Res call({
 double ease, int intervalDays, int repetitions, DateTime dueAt, bool known, DateTime? learnedAt
});




}
/// @nodoc
class _$VocabReviewCopyWithImpl<$Res>
    implements $VocabReviewCopyWith<$Res> {
  _$VocabReviewCopyWithImpl(this._self, this._then);

  final VocabReview _self;
  final $Res Function(VocabReview) _then;

/// Create a copy of VocabReview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ease = null,Object? intervalDays = null,Object? repetitions = null,Object? dueAt = null,Object? known = null,Object? learnedAt = freezed,}) {
  return _then(VocabReview(
ease: null == ease ? _self.ease : ease // ignore: cast_nullable_to_non_nullable
as double,intervalDays: null == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as int,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,known: null == known ? _self.known : known // ignore: cast_nullable_to_non_nullable
as bool,learnedAt: freezed == learnedAt ? _self.learnedAt : learnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabReview].
extension VocabReviewPatterns on VocabReview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabReview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabReview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabReview value)  $default,){
final _that = this;
switch (_that) {
case _VocabReview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabReview value)?  $default,){
final _that = this;
switch (_that) {
case _VocabReview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double ease,  int intervalDays,  int repetitions,  DateTime dueAt,  bool known,  DateTime? learnedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabReview() when $default != null:
return $default(_that.ease,_that.intervalDays,_that.repetitions,_that.dueAt,_that.known,_that.learnedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double ease,  int intervalDays,  int repetitions,  DateTime dueAt,  bool known,  DateTime? learnedAt)  $default,) {final _that = this;
switch (_that) {
case _VocabReview():
return $default(_that.ease,_that.intervalDays,_that.repetitions,_that.dueAt,_that.known,_that.learnedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double ease,  int intervalDays,  int repetitions,  DateTime dueAt,  bool known,  DateTime? learnedAt)?  $default,) {final _that = this;
switch (_that) {
case _VocabReview() when $default != null:
return $default(_that.ease,_that.intervalDays,_that.repetitions,_that.dueAt,_that.known,_that.learnedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VocabReview implements VocabReview {
  const _VocabReview({required this.ease, required this.intervalDays, required this.repetitions, required this.dueAt, this.known = false, this.learnedAt});
  factory _VocabReview.fromJson(Map<String, dynamic> json) => _$VocabReviewFromJson(json);

@override final  double ease;
@override final  int intervalDays;
@override final  int repetitions;
@override final  DateTime dueAt;
/// Người học đánh dấu "đã biết" → không đưa vào phiên học nữa.
@override@JsonKey() final  bool known;
/// Lần đầu học từ này (giới hạn số từ mới mỗi ngày).
@override final  DateTime? learnedAt;

/// Create a copy of VocabReview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabReviewCopyWith<_VocabReview> get copyWith => __$VocabReviewCopyWithImpl<_VocabReview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VocabReviewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabReview&&(identical(other.ease, ease) || other.ease == ease)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays)&&(identical(other.repetitions, repetitions) || other.repetitions == repetitions)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.known, known) || other.known == known)&&(identical(other.learnedAt, learnedAt) || other.learnedAt == learnedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,ease,intervalDays,repetitions,dueAt,known,learnedAt);
}

@override
String toString() {
    return 'VocabReview(ease: $ease, intervalDays: $intervalDays, repetitions: $repetitions, dueAt: $dueAt, known: $known, learnedAt: $learnedAt)';
}


}

/// @nodoc
abstract mixin class _$VocabReviewCopyWith<$Res> implements $VocabReviewCopyWith<$Res> {
  factory _$VocabReviewCopyWith(_VocabReview value, $Res Function(_VocabReview) _then) = __$VocabReviewCopyWithImpl;
@override @useResult
$Res call({
 double ease, int intervalDays, int repetitions, DateTime dueAt, bool known, DateTime? learnedAt
});




}
/// @nodoc
class __$VocabReviewCopyWithImpl<$Res>
    implements _$VocabReviewCopyWith<$Res> {
  __$VocabReviewCopyWithImpl(this._self, this._then);

  final _VocabReview _self;
  final $Res Function(_VocabReview) _then;

/// Create a copy of VocabReview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ease = null,Object? intervalDays = null,Object? repetitions = null,Object? dueAt = null,Object? known = null,Object? learnedAt = freezed,}) {
  return _then(_VocabReview(
ease: null == ease ? _self.ease : ease // ignore: cast_nullable_to_non_nullable
as double,intervalDays: null == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int,repetitions: null == repetitions ? _self.repetitions : repetitions // ignore: cast_nullable_to_non_nullable
as int,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,known: null == known ? _self.known : known // ignore: cast_nullable_to_non_nullable
as bool,learnedAt: freezed == learnedAt ? _self.learnedAt : learnedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$VocabItem {

 String get id; String get word; String? get ipa; String? get pos; String get meaning; String? get example; String? get exampleMeaning; String get topic; String? get audioUrl;/// Nguồn trong đề, vd. "ETS 2026 Test 3 · câu 147" (null = từ thêm tay).
 String? get source;/// null = từ trong bộ chung (vd. ETS 2026); có giá trị = từ riêng của user này
 String? get userId;/// Embed `vocab_reviews(*)`; RLS chỉ trả về lịch ôn của user hiện tại (0 hoặc 1 dòng).
@JsonKey(name: 'vocab_reviews', includeToJson: false) List<VocabReview> get reviews;
/// Create a copy of VocabItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabItemCopyWith<VocabItem> get copyWith => _$VocabItemCopyWithImpl<VocabItem>(this as VocabItem, _$identity);

  /// Serializes this VocabItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as VocabItem;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabItem&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.word, _this.word) || other.word == _this.word)&&(identical(other.ipa, _this.ipa) || other.ipa == _this.ipa)&&(identical(other.pos, _this.pos) || other.pos == _this.pos)&&(identical(other.meaning, _this.meaning) || other.meaning == _this.meaning)&&(identical(other.example, _this.example) || other.example == _this.example)&&(identical(other.exampleMeaning, _this.exampleMeaning) || other.exampleMeaning == _this.exampleMeaning)&&(identical(other.topic, _this.topic) || other.topic == _this.topic)&&(identical(other.audioUrl, _this.audioUrl) || other.audioUrl == _this.audioUrl)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&const DeepCollectionEquality().equals(other.reviews, _this.reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as VocabItem;
  return Object.hash(runtimeType,_this.id,_this.word,_this.ipa,_this.pos,_this.meaning,_this.example,_this.exampleMeaning,_this.topic,_this.audioUrl,_this.source,_this.userId,const DeepCollectionEquality().hash(_this.reviews));
}

@override
String toString() {
  final _this = this as VocabItem;
  return 'VocabItem(id: ${_this.id}, word: ${_this.word}, ipa: ${_this.ipa}, pos: ${_this.pos}, meaning: ${_this.meaning}, example: ${_this.example}, exampleMeaning: ${_this.exampleMeaning}, topic: ${_this.topic}, audioUrl: ${_this.audioUrl}, source: ${_this.source}, userId: ${_this.userId}, reviews: ${_this.reviews})';
}


}

/// @nodoc
abstract mixin class $VocabItemCopyWith<$Res>  {
  factory $VocabItemCopyWith(VocabItem value, $Res Function(VocabItem) _then) = _$VocabItemCopyWithImpl;
@useResult
$Res call({
 String id, String word, String? ipa, String? pos, String meaning, String? example, String? exampleMeaning, String topic, String? audioUrl, String? source, String? userId,@JsonKey(name: 'vocab_reviews', includeToJson: false) List<VocabReview> reviews
});




}
/// @nodoc
class _$VocabItemCopyWithImpl<$Res>
    implements $VocabItemCopyWith<$Res> {
  _$VocabItemCopyWithImpl(this._self, this._then);

  final VocabItem _self;
  final $Res Function(VocabItem) _then;

/// Create a copy of VocabItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? word = null,Object? ipa = freezed,Object? pos = freezed,Object? meaning = null,Object? example = freezed,Object? exampleMeaning = freezed,Object? topic = null,Object? audioUrl = freezed,Object? source = freezed,Object? userId = freezed,Object? reviews = null,}) {
  return _then(VocabItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,ipa: freezed == ipa ? _self.ipa : ipa // ignore: cast_nullable_to_non_nullable
as String?,pos: freezed == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as String?,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,example: freezed == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String?,exampleMeaning: freezed == exampleMeaning ? _self.exampleMeaning : exampleMeaning // ignore: cast_nullable_to_non_nullable
as String?,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,reviews: null == reviews ? _self.reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<VocabReview>,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabItem].
extension VocabItemPatterns on VocabItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabItem value)  $default,){
final _that = this;
switch (_that) {
case _VocabItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabItem value)?  $default,){
final _that = this;
switch (_that) {
case _VocabItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String word,  String? ipa,  String? pos,  String meaning,  String? example,  String? exampleMeaning,  String topic,  String? audioUrl,  String? source,  String? userId, @JsonKey(name: 'vocab_reviews', includeToJson: false)  List<VocabReview> reviews)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabItem() when $default != null:
return $default(_that.id,_that.word,_that.ipa,_that.pos,_that.meaning,_that.example,_that.exampleMeaning,_that.topic,_that.audioUrl,_that.source,_that.userId,_that.reviews);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String word,  String? ipa,  String? pos,  String meaning,  String? example,  String? exampleMeaning,  String topic,  String? audioUrl,  String? source,  String? userId, @JsonKey(name: 'vocab_reviews', includeToJson: false)  List<VocabReview> reviews)  $default,) {final _that = this;
switch (_that) {
case _VocabItem():
return $default(_that.id,_that.word,_that.ipa,_that.pos,_that.meaning,_that.example,_that.exampleMeaning,_that.topic,_that.audioUrl,_that.source,_that.userId,_that.reviews);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String word,  String? ipa,  String? pos,  String meaning,  String? example,  String? exampleMeaning,  String topic,  String? audioUrl,  String? source,  String? userId, @JsonKey(name: 'vocab_reviews', includeToJson: false)  List<VocabReview> reviews)?  $default,) {final _that = this;
switch (_that) {
case _VocabItem() when $default != null:
return $default(_that.id,_that.word,_that.ipa,_that.pos,_that.meaning,_that.example,_that.exampleMeaning,_that.topic,_that.audioUrl,_that.source,_that.userId,_that.reviews);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VocabItem extends VocabItem {
  const _VocabItem({required this.id, required this.word, this.ipa, this.pos, required this.meaning, this.example, this.exampleMeaning, required this.topic, this.audioUrl, this.source, this.userId, @JsonKey(name: 'vocab_reviews', includeToJson: false)  List<VocabReview> reviews = const <VocabReview>[]}): _reviews = reviews,super._();
  factory _VocabItem.fromJson(Map<String, dynamic> json) => _$VocabItemFromJson(json);

@override final  String id;
@override final  String word;
@override final  String? ipa;
@override final  String? pos;
@override final  String meaning;
@override final  String? example;
@override final  String? exampleMeaning;
@override final  String topic;
@override final  String? audioUrl;
/// Nguồn trong đề, vd. "ETS 2026 Test 3 · câu 147" (null = từ thêm tay).
@override final  String? source;
/// null = từ trong bộ chung (vd. ETS 2026); có giá trị = từ riêng của user này
@override final  String? userId;
/// Embed `vocab_reviews(*)`; RLS chỉ trả về lịch ôn của user hiện tại (0 hoặc 1 dòng).
 final  List<VocabReview> _reviews;
/// Embed `vocab_reviews(*)`; RLS chỉ trả về lịch ôn của user hiện tại (0 hoặc 1 dòng).
@override@JsonKey(name: 'vocab_reviews', includeToJson: false) List<VocabReview> get reviews {
  if (_reviews is EqualUnmodifiableListView) return _reviews;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_reviews);
}


/// Create a copy of VocabItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabItemCopyWith<_VocabItem> get copyWith => __$VocabItemCopyWithImpl<_VocabItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VocabItemToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabItem&&(identical(other.id, id) || other.id == id)&&(identical(other.word, word) || other.word == word)&&(identical(other.ipa, ipa) || other.ipa == ipa)&&(identical(other.pos, pos) || other.pos == pos)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.example, example) || other.example == example)&&(identical(other.exampleMeaning, exampleMeaning) || other.exampleMeaning == exampleMeaning)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.audioUrl, audioUrl) || other.audioUrl == audioUrl)&&(identical(other.source, source) || other.source == source)&&(identical(other.userId, userId) || other.userId == userId)&&const DeepCollectionEquality().equals(other.reviews, _reviews));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,word,ipa,pos,meaning,example,exampleMeaning,topic,audioUrl,source,userId,const DeepCollectionEquality().hash(_reviews));
}

@override
String toString() {
    return 'VocabItem(id: $id, word: $word, ipa: $ipa, pos: $pos, meaning: $meaning, example: $example, exampleMeaning: $exampleMeaning, topic: $topic, audioUrl: $audioUrl, source: $source, userId: $userId, reviews: $reviews)';
}


}

/// @nodoc
abstract mixin class _$VocabItemCopyWith<$Res> implements $VocabItemCopyWith<$Res> {
  factory _$VocabItemCopyWith(_VocabItem value, $Res Function(_VocabItem) _then) = __$VocabItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String word, String? ipa, String? pos, String meaning, String? example, String? exampleMeaning, String topic, String? audioUrl, String? source, String? userId,@JsonKey(name: 'vocab_reviews', includeToJson: false) List<VocabReview> reviews
});




}
/// @nodoc
class __$VocabItemCopyWithImpl<$Res>
    implements _$VocabItemCopyWith<$Res> {
  __$VocabItemCopyWithImpl(this._self, this._then);

  final _VocabItem _self;
  final $Res Function(_VocabItem) _then;

/// Create a copy of VocabItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? word = null,Object? ipa = freezed,Object? pos = freezed,Object? meaning = null,Object? example = freezed,Object? exampleMeaning = freezed,Object? topic = null,Object? audioUrl = freezed,Object? source = freezed,Object? userId = freezed,Object? reviews = null,}) {
  return _then(_VocabItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,ipa: freezed == ipa ? _self.ipa : ipa // ignore: cast_nullable_to_non_nullable
as String?,pos: freezed == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as String?,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,example: freezed == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String?,exampleMeaning: freezed == exampleMeaning ? _self.exampleMeaning : exampleMeaning // ignore: cast_nullable_to_non_nullable
as String?,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,audioUrl: freezed == audioUrl ? _self.audioUrl : audioUrl // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,reviews: null == reviews ? _self._reviews : reviews // ignore: cast_nullable_to_non_nullable
as List<VocabReview>,
  ));
}


}

// dart format on
