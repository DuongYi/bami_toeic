// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dict_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DictSense {

@JsonKey(name: 'p') String? get pos;@JsonKey(name: 'm') String get meaning;@JsonKey(name: 'e') String? get example;
/// Create a copy of DictSense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DictSenseCopyWith<DictSense> get copyWith => _$DictSenseCopyWithImpl<DictSense>(this as DictSense, _$identity);

  /// Serializes this DictSense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DictSense;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DictSense&&(identical(other.pos, _this.pos) || other.pos == _this.pos)&&(identical(other.meaning, _this.meaning) || other.meaning == _this.meaning)&&(identical(other.example, _this.example) || other.example == _this.example));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DictSense;
  return Object.hash(runtimeType,_this.pos,_this.meaning,_this.example);
}

@override
String toString() {
  final _this = this as DictSense;
  return 'DictSense(pos: ${_this.pos}, meaning: ${_this.meaning}, example: ${_this.example})';
}


}

/// @nodoc
abstract mixin class $DictSenseCopyWith<$Res>  {
  factory $DictSenseCopyWith(DictSense value, $Res Function(DictSense) _then) = _$DictSenseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'p') String? pos,@JsonKey(name: 'm') String meaning,@JsonKey(name: 'e') String? example
});




}
/// @nodoc
class _$DictSenseCopyWithImpl<$Res>
    implements $DictSenseCopyWith<$Res> {
  _$DictSenseCopyWithImpl(this._self, this._then);

  final DictSense _self;
  final $Res Function(DictSense) _then;

/// Create a copy of DictSense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pos = freezed,Object? meaning = null,Object? example = freezed,}) {
  return _then(DictSense(
pos: freezed == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as String?,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,example: freezed == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DictSense].
extension DictSensePatterns on DictSense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DictSense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DictSense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DictSense value)  $default,){
final _that = this;
switch (_that) {
case _DictSense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DictSense value)?  $default,){
final _that = this;
switch (_that) {
case _DictSense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'p')  String? pos, @JsonKey(name: 'm')  String meaning, @JsonKey(name: 'e')  String? example)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DictSense() when $default != null:
return $default(_that.pos,_that.meaning,_that.example);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'p')  String? pos, @JsonKey(name: 'm')  String meaning, @JsonKey(name: 'e')  String? example)  $default,) {final _that = this;
switch (_that) {
case _DictSense():
return $default(_that.pos,_that.meaning,_that.example);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'p')  String? pos, @JsonKey(name: 'm')  String meaning, @JsonKey(name: 'e')  String? example)?  $default,) {final _that = this;
switch (_that) {
case _DictSense() when $default != null:
return $default(_that.pos,_that.meaning,_that.example);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DictSense implements DictSense {
  const _DictSense({@JsonKey(name: 'p') this.pos, @JsonKey(name: 'm') required this.meaning, @JsonKey(name: 'e') this.example});
  factory _DictSense.fromJson(Map<String, dynamic> json) => _$DictSenseFromJson(json);

@override@JsonKey(name: 'p') final  String? pos;
@override@JsonKey(name: 'm') final  String meaning;
@override@JsonKey(name: 'e') final  String? example;

/// Create a copy of DictSense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DictSenseCopyWith<_DictSense> get copyWith => __$DictSenseCopyWithImpl<_DictSense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DictSenseToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DictSense&&(identical(other.pos, pos) || other.pos == pos)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.example, example) || other.example == example));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,pos,meaning,example);
}

@override
String toString() {
    return 'DictSense(pos: $pos, meaning: $meaning, example: $example)';
}


}

/// @nodoc
abstract mixin class _$DictSenseCopyWith<$Res> implements $DictSenseCopyWith<$Res> {
  factory _$DictSenseCopyWith(_DictSense value, $Res Function(_DictSense) _then) = __$DictSenseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'p') String? pos,@JsonKey(name: 'm') String meaning,@JsonKey(name: 'e') String? example
});




}
/// @nodoc
class __$DictSenseCopyWithImpl<$Res>
    implements _$DictSenseCopyWith<$Res> {
  __$DictSenseCopyWithImpl(this._self, this._then);

  final _DictSense _self;
  final $Res Function(_DictSense) _then;

/// Create a copy of DictSense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pos = freezed,Object? meaning = null,Object? example = freezed,}) {
  return _then(_DictSense(
pos: freezed == pos ? _self.pos : pos // ignore: cast_nullable_to_non_nullable
as String?,meaning: null == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String,example: freezed == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$DictEntry {

 String get wordKey; String get word; String? get ipa; List<DictSense> get senses;
/// Create a copy of DictEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DictEntryCopyWith<DictEntry> get copyWith => _$DictEntryCopyWithImpl<DictEntry>(this as DictEntry, _$identity);

  /// Serializes this DictEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DictEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DictEntry&&(identical(other.wordKey, _this.wordKey) || other.wordKey == _this.wordKey)&&(identical(other.word, _this.word) || other.word == _this.word)&&(identical(other.ipa, _this.ipa) || other.ipa == _this.ipa)&&const DeepCollectionEquality().equals(other.senses, _this.senses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DictEntry;
  return Object.hash(runtimeType,_this.wordKey,_this.word,_this.ipa,const DeepCollectionEquality().hash(_this.senses));
}

@override
String toString() {
  final _this = this as DictEntry;
  return 'DictEntry(wordKey: ${_this.wordKey}, word: ${_this.word}, ipa: ${_this.ipa}, senses: ${_this.senses})';
}


}

/// @nodoc
abstract mixin class $DictEntryCopyWith<$Res>  {
  factory $DictEntryCopyWith(DictEntry value, $Res Function(DictEntry) _then) = _$DictEntryCopyWithImpl;
@useResult
$Res call({
 String wordKey, String word, String? ipa, List<DictSense> senses
});




}
/// @nodoc
class _$DictEntryCopyWithImpl<$Res>
    implements $DictEntryCopyWith<$Res> {
  _$DictEntryCopyWithImpl(this._self, this._then);

  final DictEntry _self;
  final $Res Function(DictEntry) _then;

/// Create a copy of DictEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wordKey = null,Object? word = null,Object? ipa = freezed,Object? senses = null,}) {
  return _then(DictEntry(
wordKey: null == wordKey ? _self.wordKey : wordKey // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,ipa: freezed == ipa ? _self.ipa : ipa // ignore: cast_nullable_to_non_nullable
as String?,senses: null == senses ? _self.senses : senses // ignore: cast_nullable_to_non_nullable
as List<DictSense>,
  ));
}

}


/// Adds pattern-matching-related methods to [DictEntry].
extension DictEntryPatterns on DictEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DictEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DictEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DictEntry value)  $default,){
final _that = this;
switch (_that) {
case _DictEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DictEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DictEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String wordKey,  String word,  String? ipa,  List<DictSense> senses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DictEntry() when $default != null:
return $default(_that.wordKey,_that.word,_that.ipa,_that.senses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String wordKey,  String word,  String? ipa,  List<DictSense> senses)  $default,) {final _that = this;
switch (_that) {
case _DictEntry():
return $default(_that.wordKey,_that.word,_that.ipa,_that.senses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String wordKey,  String word,  String? ipa,  List<DictSense> senses)?  $default,) {final _that = this;
switch (_that) {
case _DictEntry() when $default != null:
return $default(_that.wordKey,_that.word,_that.ipa,_that.senses);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DictEntry extends DictEntry {
  const _DictEntry({required this.wordKey, required this.word, this.ipa,  List<DictSense> senses = const <DictSense>[]}): _senses = senses,super._();
  factory _DictEntry.fromJson(Map<String, dynamic> json) => _$DictEntryFromJson(json);

@override final  String wordKey;
@override final  String word;
@override final  String? ipa;
 final  List<DictSense> _senses;
@override@JsonKey() List<DictSense> get senses {
  if (_senses is EqualUnmodifiableListView) return _senses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_senses);
}


/// Create a copy of DictEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DictEntryCopyWith<_DictEntry> get copyWith => __$DictEntryCopyWithImpl<_DictEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DictEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DictEntry&&(identical(other.wordKey, wordKey) || other.wordKey == wordKey)&&(identical(other.word, word) || other.word == word)&&(identical(other.ipa, ipa) || other.ipa == ipa)&&const DeepCollectionEquality().equals(other.senses, _senses));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,wordKey,word,ipa,const DeepCollectionEquality().hash(_senses));
}

@override
String toString() {
    return 'DictEntry(wordKey: $wordKey, word: $word, ipa: $ipa, senses: $senses)';
}


}

/// @nodoc
abstract mixin class _$DictEntryCopyWith<$Res> implements $DictEntryCopyWith<$Res> {
  factory _$DictEntryCopyWith(_DictEntry value, $Res Function(_DictEntry) _then) = __$DictEntryCopyWithImpl;
@override @useResult
$Res call({
 String wordKey, String word, String? ipa, List<DictSense> senses
});




}
/// @nodoc
class __$DictEntryCopyWithImpl<$Res>
    implements _$DictEntryCopyWith<$Res> {
  __$DictEntryCopyWithImpl(this._self, this._then);

  final _DictEntry _self;
  final $Res Function(_DictEntry) _then;

/// Create a copy of DictEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wordKey = null,Object? word = null,Object? ipa = freezed,Object? senses = null,}) {
  return _then(_DictEntry(
wordKey: null == wordKey ? _self.wordKey : wordKey // ignore: cast_nullable_to_non_nullable
as String,word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,ipa: freezed == ipa ? _self.ipa : ipa // ignore: cast_nullable_to_non_nullable
as String?,senses: null == senses ? _self._senses : senses // ignore: cast_nullable_to_non_nullable
as List<DictSense>,
  ));
}


}


/// @nodoc
mixin _$DictSuggestion {

 String get word; String? get ipa; String? get meaning; bool get fuzzy;
/// Create a copy of DictSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DictSuggestionCopyWith<DictSuggestion> get copyWith => _$DictSuggestionCopyWithImpl<DictSuggestion>(this as DictSuggestion, _$identity);

  /// Serializes this DictSuggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DictSuggestion;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DictSuggestion&&(identical(other.word, _this.word) || other.word == _this.word)&&(identical(other.ipa, _this.ipa) || other.ipa == _this.ipa)&&(identical(other.meaning, _this.meaning) || other.meaning == _this.meaning)&&(identical(other.fuzzy, _this.fuzzy) || other.fuzzy == _this.fuzzy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DictSuggestion;
  return Object.hash(runtimeType,_this.word,_this.ipa,_this.meaning,_this.fuzzy);
}

@override
String toString() {
  final _this = this as DictSuggestion;
  return 'DictSuggestion(word: ${_this.word}, ipa: ${_this.ipa}, meaning: ${_this.meaning}, fuzzy: ${_this.fuzzy})';
}


}

/// @nodoc
abstract mixin class $DictSuggestionCopyWith<$Res>  {
  factory $DictSuggestionCopyWith(DictSuggestion value, $Res Function(DictSuggestion) _then) = _$DictSuggestionCopyWithImpl;
@useResult
$Res call({
 String word, String? ipa, String? meaning, bool fuzzy
});




}
/// @nodoc
class _$DictSuggestionCopyWithImpl<$Res>
    implements $DictSuggestionCopyWith<$Res> {
  _$DictSuggestionCopyWithImpl(this._self, this._then);

  final DictSuggestion _self;
  final $Res Function(DictSuggestion) _then;

/// Create a copy of DictSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? ipa = freezed,Object? meaning = freezed,Object? fuzzy = null,}) {
  return _then(DictSuggestion(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,ipa: freezed == ipa ? _self.ipa : ipa // ignore: cast_nullable_to_non_nullable
as String?,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,fuzzy: null == fuzzy ? _self.fuzzy : fuzzy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [DictSuggestion].
extension DictSuggestionPatterns on DictSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DictSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DictSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DictSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _DictSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DictSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _DictSuggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word,  String? ipa,  String? meaning,  bool fuzzy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DictSuggestion() when $default != null:
return $default(_that.word,_that.ipa,_that.meaning,_that.fuzzy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word,  String? ipa,  String? meaning,  bool fuzzy)  $default,) {final _that = this;
switch (_that) {
case _DictSuggestion():
return $default(_that.word,_that.ipa,_that.meaning,_that.fuzzy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word,  String? ipa,  String? meaning,  bool fuzzy)?  $default,) {final _that = this;
switch (_that) {
case _DictSuggestion() when $default != null:
return $default(_that.word,_that.ipa,_that.meaning,_that.fuzzy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DictSuggestion implements DictSuggestion {
  const _DictSuggestion({required this.word, this.ipa, this.meaning, this.fuzzy = false});
  factory _DictSuggestion.fromJson(Map<String, dynamic> json) => _$DictSuggestionFromJson(json);

@override final  String word;
@override final  String? ipa;
@override final  String? meaning;
@override@JsonKey() final  bool fuzzy;

/// Create a copy of DictSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DictSuggestionCopyWith<_DictSuggestion> get copyWith => __$DictSuggestionCopyWithImpl<_DictSuggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DictSuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DictSuggestion&&(identical(other.word, word) || other.word == word)&&(identical(other.ipa, ipa) || other.ipa == ipa)&&(identical(other.meaning, meaning) || other.meaning == meaning)&&(identical(other.fuzzy, fuzzy) || other.fuzzy == fuzzy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,word,ipa,meaning,fuzzy);
}

@override
String toString() {
    return 'DictSuggestion(word: $word, ipa: $ipa, meaning: $meaning, fuzzy: $fuzzy)';
}


}

/// @nodoc
abstract mixin class _$DictSuggestionCopyWith<$Res> implements $DictSuggestionCopyWith<$Res> {
  factory _$DictSuggestionCopyWith(_DictSuggestion value, $Res Function(_DictSuggestion) _then) = __$DictSuggestionCopyWithImpl;
@override @useResult
$Res call({
 String word, String? ipa, String? meaning, bool fuzzy
});




}
/// @nodoc
class __$DictSuggestionCopyWithImpl<$Res>
    implements _$DictSuggestionCopyWith<$Res> {
  __$DictSuggestionCopyWithImpl(this._self, this._then);

  final _DictSuggestion _self;
  final $Res Function(_DictSuggestion) _then;

/// Create a copy of DictSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? ipa = freezed,Object? meaning = freezed,Object? fuzzy = null,}) {
  return _then(_DictSuggestion(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,ipa: freezed == ipa ? _self.ipa : ipa // ignore: cast_nullable_to_non_nullable
as String?,meaning: freezed == meaning ? _self.meaning : meaning // ignore: cast_nullable_to_non_nullable
as String?,fuzzy: null == fuzzy ? _self.fuzzy : fuzzy // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$EnEntry {

 String get word; String? get phonetic; List<EnPhonetic> get phonetics; List<EnMeaning> get meanings;
/// Create a copy of EnEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnEntryCopyWith<EnEntry> get copyWith => _$EnEntryCopyWithImpl<EnEntry>(this as EnEntry, _$identity);

  /// Serializes this EnEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EnEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnEntry&&(identical(other.word, _this.word) || other.word == _this.word)&&(identical(other.phonetic, _this.phonetic) || other.phonetic == _this.phonetic)&&const DeepCollectionEquality().equals(other.phonetics, _this.phonetics)&&const DeepCollectionEquality().equals(other.meanings, _this.meanings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EnEntry;
  return Object.hash(runtimeType,_this.word,_this.phonetic,const DeepCollectionEquality().hash(_this.phonetics),const DeepCollectionEquality().hash(_this.meanings));
}

@override
String toString() {
  final _this = this as EnEntry;
  return 'EnEntry(word: ${_this.word}, phonetic: ${_this.phonetic}, phonetics: ${_this.phonetics}, meanings: ${_this.meanings})';
}


}

/// @nodoc
abstract mixin class $EnEntryCopyWith<$Res>  {
  factory $EnEntryCopyWith(EnEntry value, $Res Function(EnEntry) _then) = _$EnEntryCopyWithImpl;
@useResult
$Res call({
 String word, String? phonetic, List<EnPhonetic> phonetics, List<EnMeaning> meanings
});




}
/// @nodoc
class _$EnEntryCopyWithImpl<$Res>
    implements $EnEntryCopyWith<$Res> {
  _$EnEntryCopyWithImpl(this._self, this._then);

  final EnEntry _self;
  final $Res Function(EnEntry) _then;

/// Create a copy of EnEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? phonetic = freezed,Object? phonetics = null,Object? meanings = null,}) {
  return _then(EnEntry(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,phonetic: freezed == phonetic ? _self.phonetic : phonetic // ignore: cast_nullable_to_non_nullable
as String?,phonetics: null == phonetics ? _self.phonetics : phonetics // ignore: cast_nullable_to_non_nullable
as List<EnPhonetic>,meanings: null == meanings ? _self.meanings : meanings // ignore: cast_nullable_to_non_nullable
as List<EnMeaning>,
  ));
}

}


/// Adds pattern-matching-related methods to [EnEntry].
extension EnEntryPatterns on EnEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnEntry value)  $default,){
final _that = this;
switch (_that) {
case _EnEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnEntry value)?  $default,){
final _that = this;
switch (_that) {
case _EnEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word,  String? phonetic,  List<EnPhonetic> phonetics,  List<EnMeaning> meanings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnEntry() when $default != null:
return $default(_that.word,_that.phonetic,_that.phonetics,_that.meanings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word,  String? phonetic,  List<EnPhonetic> phonetics,  List<EnMeaning> meanings)  $default,) {final _that = this;
switch (_that) {
case _EnEntry():
return $default(_that.word,_that.phonetic,_that.phonetics,_that.meanings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word,  String? phonetic,  List<EnPhonetic> phonetics,  List<EnMeaning> meanings)?  $default,) {final _that = this;
switch (_that) {
case _EnEntry() when $default != null:
return $default(_that.word,_that.phonetic,_that.phonetics,_that.meanings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnEntry extends EnEntry {
  const _EnEntry({required this.word, this.phonetic,  List<EnPhonetic> phonetics = const <EnPhonetic>[],  List<EnMeaning> meanings = const <EnMeaning>[]}): _phonetics = phonetics,_meanings = meanings,super._();
  factory _EnEntry.fromJson(Map<String, dynamic> json) => _$EnEntryFromJson(json);

@override final  String word;
@override final  String? phonetic;
 final  List<EnPhonetic> _phonetics;
@override@JsonKey() List<EnPhonetic> get phonetics {
  if (_phonetics is EqualUnmodifiableListView) return _phonetics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_phonetics);
}

 final  List<EnMeaning> _meanings;
@override@JsonKey() List<EnMeaning> get meanings {
  if (_meanings is EqualUnmodifiableListView) return _meanings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_meanings);
}


/// Create a copy of EnEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnEntryCopyWith<_EnEntry> get copyWith => __$EnEntryCopyWithImpl<_EnEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnEntry&&(identical(other.word, word) || other.word == word)&&(identical(other.phonetic, phonetic) || other.phonetic == phonetic)&&const DeepCollectionEquality().equals(other.phonetics, _phonetics)&&const DeepCollectionEquality().equals(other.meanings, _meanings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,word,phonetic,const DeepCollectionEquality().hash(_phonetics),const DeepCollectionEquality().hash(_meanings));
}

@override
String toString() {
    return 'EnEntry(word: $word, phonetic: $phonetic, phonetics: $phonetics, meanings: $meanings)';
}


}

/// @nodoc
abstract mixin class _$EnEntryCopyWith<$Res> implements $EnEntryCopyWith<$Res> {
  factory _$EnEntryCopyWith(_EnEntry value, $Res Function(_EnEntry) _then) = __$EnEntryCopyWithImpl;
@override @useResult
$Res call({
 String word, String? phonetic, List<EnPhonetic> phonetics, List<EnMeaning> meanings
});




}
/// @nodoc
class __$EnEntryCopyWithImpl<$Res>
    implements _$EnEntryCopyWith<$Res> {
  __$EnEntryCopyWithImpl(this._self, this._then);

  final _EnEntry _self;
  final $Res Function(_EnEntry) _then;

/// Create a copy of EnEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? phonetic = freezed,Object? phonetics = null,Object? meanings = null,}) {
  return _then(_EnEntry(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,phonetic: freezed == phonetic ? _self.phonetic : phonetic // ignore: cast_nullable_to_non_nullable
as String?,phonetics: null == phonetics ? _self._phonetics : phonetics // ignore: cast_nullable_to_non_nullable
as List<EnPhonetic>,meanings: null == meanings ? _self._meanings : meanings // ignore: cast_nullable_to_non_nullable
as List<EnMeaning>,
  ));
}


}


/// @nodoc
mixin _$EnPhonetic {

 String? get text; String? get audio;
/// Create a copy of EnPhonetic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnPhoneticCopyWith<EnPhonetic> get copyWith => _$EnPhoneticCopyWithImpl<EnPhonetic>(this as EnPhonetic, _$identity);

  /// Serializes this EnPhonetic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EnPhonetic;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnPhonetic&&(identical(other.text, _this.text) || other.text == _this.text)&&(identical(other.audio, _this.audio) || other.audio == _this.audio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EnPhonetic;
  return Object.hash(runtimeType,_this.text,_this.audio);
}

@override
String toString() {
  final _this = this as EnPhonetic;
  return 'EnPhonetic(text: ${_this.text}, audio: ${_this.audio})';
}


}

/// @nodoc
abstract mixin class $EnPhoneticCopyWith<$Res>  {
  factory $EnPhoneticCopyWith(EnPhonetic value, $Res Function(EnPhonetic) _then) = _$EnPhoneticCopyWithImpl;
@useResult
$Res call({
 String? text, String? audio
});




}
/// @nodoc
class _$EnPhoneticCopyWithImpl<$Res>
    implements $EnPhoneticCopyWith<$Res> {
  _$EnPhoneticCopyWithImpl(this._self, this._then);

  final EnPhonetic _self;
  final $Res Function(EnPhonetic) _then;

/// Create a copy of EnPhonetic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = freezed,Object? audio = freezed,}) {
  return _then(EnPhonetic(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,audio: freezed == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [EnPhonetic].
extension EnPhoneticPatterns on EnPhonetic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnPhonetic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnPhonetic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnPhonetic value)  $default,){
final _that = this;
switch (_that) {
case _EnPhonetic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnPhonetic value)?  $default,){
final _that = this;
switch (_that) {
case _EnPhonetic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? text,  String? audio)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnPhonetic() when $default != null:
return $default(_that.text,_that.audio);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? text,  String? audio)  $default,) {final _that = this;
switch (_that) {
case _EnPhonetic():
return $default(_that.text,_that.audio);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? text,  String? audio)?  $default,) {final _that = this;
switch (_that) {
case _EnPhonetic() when $default != null:
return $default(_that.text,_that.audio);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnPhonetic implements EnPhonetic {
  const _EnPhonetic({this.text, this.audio});
  factory _EnPhonetic.fromJson(Map<String, dynamic> json) => _$EnPhoneticFromJson(json);

@override final  String? text;
@override final  String? audio;

/// Create a copy of EnPhonetic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnPhoneticCopyWith<_EnPhonetic> get copyWith => __$EnPhoneticCopyWithImpl<_EnPhonetic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnPhoneticToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnPhonetic&&(identical(other.text, text) || other.text == text)&&(identical(other.audio, audio) || other.audio == audio));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,text,audio);
}

@override
String toString() {
    return 'EnPhonetic(text: $text, audio: $audio)';
}


}

/// @nodoc
abstract mixin class _$EnPhoneticCopyWith<$Res> implements $EnPhoneticCopyWith<$Res> {
  factory _$EnPhoneticCopyWith(_EnPhonetic value, $Res Function(_EnPhonetic) _then) = __$EnPhoneticCopyWithImpl;
@override @useResult
$Res call({
 String? text, String? audio
});




}
/// @nodoc
class __$EnPhoneticCopyWithImpl<$Res>
    implements _$EnPhoneticCopyWith<$Res> {
  __$EnPhoneticCopyWithImpl(this._self, this._then);

  final _EnPhonetic _self;
  final $Res Function(_EnPhonetic) _then;

/// Create a copy of EnPhonetic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = freezed,Object? audio = freezed,}) {
  return _then(_EnPhonetic(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,audio: freezed == audio ? _self.audio : audio // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$EnMeaning {

@JsonKey(name: 'partOfSpeech') String get partOfSpeech; List<EnDefinition> get definitions; List<String> get synonyms; List<String> get antonyms;
/// Create a copy of EnMeaning
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnMeaningCopyWith<EnMeaning> get copyWith => _$EnMeaningCopyWithImpl<EnMeaning>(this as EnMeaning, _$identity);

  /// Serializes this EnMeaning to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EnMeaning;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnMeaning&&(identical(other.partOfSpeech, _this.partOfSpeech) || other.partOfSpeech == _this.partOfSpeech)&&const DeepCollectionEquality().equals(other.definitions, _this.definitions)&&const DeepCollectionEquality().equals(other.synonyms, _this.synonyms)&&const DeepCollectionEquality().equals(other.antonyms, _this.antonyms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EnMeaning;
  return Object.hash(runtimeType,_this.partOfSpeech,const DeepCollectionEquality().hash(_this.definitions),const DeepCollectionEquality().hash(_this.synonyms),const DeepCollectionEquality().hash(_this.antonyms));
}

@override
String toString() {
  final _this = this as EnMeaning;
  return 'EnMeaning(partOfSpeech: ${_this.partOfSpeech}, definitions: ${_this.definitions}, synonyms: ${_this.synonyms}, antonyms: ${_this.antonyms})';
}


}

/// @nodoc
abstract mixin class $EnMeaningCopyWith<$Res>  {
  factory $EnMeaningCopyWith(EnMeaning value, $Res Function(EnMeaning) _then) = _$EnMeaningCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'partOfSpeech') String partOfSpeech, List<EnDefinition> definitions, List<String> synonyms, List<String> antonyms
});




}
/// @nodoc
class _$EnMeaningCopyWithImpl<$Res>
    implements $EnMeaningCopyWith<$Res> {
  _$EnMeaningCopyWithImpl(this._self, this._then);

  final EnMeaning _self;
  final $Res Function(EnMeaning) _then;

/// Create a copy of EnMeaning
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? partOfSpeech = null,Object? definitions = null,Object? synonyms = null,Object? antonyms = null,}) {
  return _then(EnMeaning(
partOfSpeech: null == partOfSpeech ? _self.partOfSpeech : partOfSpeech // ignore: cast_nullable_to_non_nullable
as String,definitions: null == definitions ? _self.definitions : definitions // ignore: cast_nullable_to_non_nullable
as List<EnDefinition>,synonyms: null == synonyms ? _self.synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,antonyms: null == antonyms ? _self.antonyms : antonyms // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [EnMeaning].
extension EnMeaningPatterns on EnMeaning {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnMeaning value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnMeaning() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnMeaning value)  $default,){
final _that = this;
switch (_that) {
case _EnMeaning():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnMeaning value)?  $default,){
final _that = this;
switch (_that) {
case _EnMeaning() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'partOfSpeech')  String partOfSpeech,  List<EnDefinition> definitions,  List<String> synonyms,  List<String> antonyms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnMeaning() when $default != null:
return $default(_that.partOfSpeech,_that.definitions,_that.synonyms,_that.antonyms);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'partOfSpeech')  String partOfSpeech,  List<EnDefinition> definitions,  List<String> synonyms,  List<String> antonyms)  $default,) {final _that = this;
switch (_that) {
case _EnMeaning():
return $default(_that.partOfSpeech,_that.definitions,_that.synonyms,_that.antonyms);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'partOfSpeech')  String partOfSpeech,  List<EnDefinition> definitions,  List<String> synonyms,  List<String> antonyms)?  $default,) {final _that = this;
switch (_that) {
case _EnMeaning() when $default != null:
return $default(_that.partOfSpeech,_that.definitions,_that.synonyms,_that.antonyms);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnMeaning implements EnMeaning {
  const _EnMeaning({@JsonKey(name: 'partOfSpeech') required this.partOfSpeech,  List<EnDefinition> definitions = const <EnDefinition>[],  List<String> synonyms = const <String>[],  List<String> antonyms = const <String>[]}): _definitions = definitions,_synonyms = synonyms,_antonyms = antonyms;
  factory _EnMeaning.fromJson(Map<String, dynamic> json) => _$EnMeaningFromJson(json);

@override@JsonKey(name: 'partOfSpeech') final  String partOfSpeech;
 final  List<EnDefinition> _definitions;
@override@JsonKey() List<EnDefinition> get definitions {
  if (_definitions is EqualUnmodifiableListView) return _definitions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_definitions);
}

 final  List<String> _synonyms;
@override@JsonKey() List<String> get synonyms {
  if (_synonyms is EqualUnmodifiableListView) return _synonyms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_synonyms);
}

 final  List<String> _antonyms;
@override@JsonKey() List<String> get antonyms {
  if (_antonyms is EqualUnmodifiableListView) return _antonyms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_antonyms);
}


/// Create a copy of EnMeaning
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnMeaningCopyWith<_EnMeaning> get copyWith => __$EnMeaningCopyWithImpl<_EnMeaning>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnMeaningToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnMeaning&&(identical(other.partOfSpeech, partOfSpeech) || other.partOfSpeech == partOfSpeech)&&const DeepCollectionEquality().equals(other.definitions, _definitions)&&const DeepCollectionEquality().equals(other.synonyms, _synonyms)&&const DeepCollectionEquality().equals(other.antonyms, _antonyms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,partOfSpeech,const DeepCollectionEquality().hash(_definitions),const DeepCollectionEquality().hash(_synonyms),const DeepCollectionEquality().hash(_antonyms));
}

@override
String toString() {
    return 'EnMeaning(partOfSpeech: $partOfSpeech, definitions: $definitions, synonyms: $synonyms, antonyms: $antonyms)';
}


}

/// @nodoc
abstract mixin class _$EnMeaningCopyWith<$Res> implements $EnMeaningCopyWith<$Res> {
  factory _$EnMeaningCopyWith(_EnMeaning value, $Res Function(_EnMeaning) _then) = __$EnMeaningCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'partOfSpeech') String partOfSpeech, List<EnDefinition> definitions, List<String> synonyms, List<String> antonyms
});




}
/// @nodoc
class __$EnMeaningCopyWithImpl<$Res>
    implements _$EnMeaningCopyWith<$Res> {
  __$EnMeaningCopyWithImpl(this._self, this._then);

  final _EnMeaning _self;
  final $Res Function(_EnMeaning) _then;

/// Create a copy of EnMeaning
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? partOfSpeech = null,Object? definitions = null,Object? synonyms = null,Object? antonyms = null,}) {
  return _then(_EnMeaning(
partOfSpeech: null == partOfSpeech ? _self.partOfSpeech : partOfSpeech // ignore: cast_nullable_to_non_nullable
as String,definitions: null == definitions ? _self._definitions : definitions // ignore: cast_nullable_to_non_nullable
as List<EnDefinition>,synonyms: null == synonyms ? _self._synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,antonyms: null == antonyms ? _self._antonyms : antonyms // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$EnDefinition {

 String get definition; String? get example; List<String> get synonyms;
/// Create a copy of EnDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EnDefinitionCopyWith<EnDefinition> get copyWith => _$EnDefinitionCopyWithImpl<EnDefinition>(this as EnDefinition, _$identity);

  /// Serializes this EnDefinition to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as EnDefinition;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EnDefinition&&(identical(other.definition, _this.definition) || other.definition == _this.definition)&&(identical(other.example, _this.example) || other.example == _this.example)&&const DeepCollectionEquality().equals(other.synonyms, _this.synonyms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as EnDefinition;
  return Object.hash(runtimeType,_this.definition,_this.example,const DeepCollectionEquality().hash(_this.synonyms));
}

@override
String toString() {
  final _this = this as EnDefinition;
  return 'EnDefinition(definition: ${_this.definition}, example: ${_this.example}, synonyms: ${_this.synonyms})';
}


}

/// @nodoc
abstract mixin class $EnDefinitionCopyWith<$Res>  {
  factory $EnDefinitionCopyWith(EnDefinition value, $Res Function(EnDefinition) _then) = _$EnDefinitionCopyWithImpl;
@useResult
$Res call({
 String definition, String? example, List<String> synonyms
});




}
/// @nodoc
class _$EnDefinitionCopyWithImpl<$Res>
    implements $EnDefinitionCopyWith<$Res> {
  _$EnDefinitionCopyWithImpl(this._self, this._then);

  final EnDefinition _self;
  final $Res Function(EnDefinition) _then;

/// Create a copy of EnDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? definition = null,Object? example = freezed,Object? synonyms = null,}) {
  return _then(EnDefinition(
definition: null == definition ? _self.definition : definition // ignore: cast_nullable_to_non_nullable
as String,example: freezed == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String?,synonyms: null == synonyms ? _self.synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [EnDefinition].
extension EnDefinitionPatterns on EnDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EnDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EnDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EnDefinition value)  $default,){
final _that = this;
switch (_that) {
case _EnDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EnDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _EnDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String definition,  String? example,  List<String> synonyms)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EnDefinition() when $default != null:
return $default(_that.definition,_that.example,_that.synonyms);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String definition,  String? example,  List<String> synonyms)  $default,) {final _that = this;
switch (_that) {
case _EnDefinition():
return $default(_that.definition,_that.example,_that.synonyms);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String definition,  String? example,  List<String> synonyms)?  $default,) {final _that = this;
switch (_that) {
case _EnDefinition() when $default != null:
return $default(_that.definition,_that.example,_that.synonyms);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EnDefinition implements EnDefinition {
  const _EnDefinition({required this.definition, this.example,  List<String> synonyms = const <String>[]}): _synonyms = synonyms;
  factory _EnDefinition.fromJson(Map<String, dynamic> json) => _$EnDefinitionFromJson(json);

@override final  String definition;
@override final  String? example;
 final  List<String> _synonyms;
@override@JsonKey() List<String> get synonyms {
  if (_synonyms is EqualUnmodifiableListView) return _synonyms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_synonyms);
}


/// Create a copy of EnDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EnDefinitionCopyWith<_EnDefinition> get copyWith => __$EnDefinitionCopyWithImpl<_EnDefinition>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EnDefinitionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _EnDefinition&&(identical(other.definition, definition) || other.definition == definition)&&(identical(other.example, example) || other.example == example)&&const DeepCollectionEquality().equals(other.synonyms, _synonyms));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,definition,example,const DeepCollectionEquality().hash(_synonyms));
}

@override
String toString() {
    return 'EnDefinition(definition: $definition, example: $example, synonyms: $synonyms)';
}


}

/// @nodoc
abstract mixin class _$EnDefinitionCopyWith<$Res> implements $EnDefinitionCopyWith<$Res> {
  factory _$EnDefinitionCopyWith(_EnDefinition value, $Res Function(_EnDefinition) _then) = __$EnDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String definition, String? example, List<String> synonyms
});




}
/// @nodoc
class __$EnDefinitionCopyWithImpl<$Res>
    implements _$EnDefinitionCopyWith<$Res> {
  __$EnDefinitionCopyWithImpl(this._self, this._then);

  final _EnDefinition _self;
  final $Res Function(_EnDefinition) _then;

/// Create a copy of EnDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? definition = null,Object? example = freezed,Object? synonyms = null,}) {
  return _then(_EnDefinition(
definition: null == definition ? _self.definition : definition // ignore: cast_nullable_to_non_nullable
as String,example: freezed == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String?,synonyms: null == synonyms ? _self._synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
