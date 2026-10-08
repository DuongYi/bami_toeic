// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flashcard_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FlashcardState {

 List<VocabItem> get queue; int get done; bool get flipped;/// Lỗi lưu tiến độ gần nhất (để UI báo snackbar)
 Object? get saveError;
/// Create a copy of FlashcardState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashcardStateCopyWith<FlashcardState> get copyWith => _$FlashcardStateCopyWithImpl<FlashcardState>(this as FlashcardState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as FlashcardState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlashcardState&&const DeepCollectionEquality().equals(other.queue, _this.queue)&&(identical(other.done, _this.done) || other.done == _this.done)&&(identical(other.flipped, _this.flipped) || other.flipped == _this.flipped)&&const DeepCollectionEquality().equals(other.saveError, _this.saveError));
}


@override
int get hashCode {
  final _this = this as FlashcardState;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.queue),_this.done,_this.flipped,const DeepCollectionEquality().hash(_this.saveError));
}

@override
String toString() {
  final _this = this as FlashcardState;
  return 'FlashcardState(queue: ${_this.queue}, done: ${_this.done}, flipped: ${_this.flipped}, saveError: ${_this.saveError})';
}


}

/// @nodoc
abstract mixin class $FlashcardStateCopyWith<$Res>  {
  factory $FlashcardStateCopyWith(FlashcardState value, $Res Function(FlashcardState) _then) = _$FlashcardStateCopyWithImpl;
@useResult
$Res call({
 List<VocabItem> queue, int done, bool flipped, Object? saveError
});




}
/// @nodoc
class _$FlashcardStateCopyWithImpl<$Res>
    implements $FlashcardStateCopyWith<$Res> {
  _$FlashcardStateCopyWithImpl(this._self, this._then);

  final FlashcardState _self;
  final $Res Function(FlashcardState) _then;

/// Create a copy of FlashcardState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? queue = null,Object? done = null,Object? flipped = null,Object? saveError = freezed,}) {
  return _then(FlashcardState(
queue: null == queue ? _self.queue : queue // ignore: cast_nullable_to_non_nullable
as List<VocabItem>,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,flipped: null == flipped ? _self.flipped : flipped // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError ,
  ));
}

}


/// Adds pattern-matching-related methods to [FlashcardState].
extension FlashcardStatePatterns on FlashcardState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlashcardState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlashcardState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlashcardState value)  $default,){
final _that = this;
switch (_that) {
case _FlashcardState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlashcardState value)?  $default,){
final _that = this;
switch (_that) {
case _FlashcardState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<VocabItem> queue,  int done,  bool flipped,  Object? saveError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlashcardState() when $default != null:
return $default(_that.queue,_that.done,_that.flipped,_that.saveError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<VocabItem> queue,  int done,  bool flipped,  Object? saveError)  $default,) {final _that = this;
switch (_that) {
case _FlashcardState():
return $default(_that.queue,_that.done,_that.flipped,_that.saveError);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<VocabItem> queue,  int done,  bool flipped,  Object? saveError)?  $default,) {final _that = this;
switch (_that) {
case _FlashcardState() when $default != null:
return $default(_that.queue,_that.done,_that.flipped,_that.saveError);case _:
  return null;

}
}

}

/// @nodoc


class _FlashcardState extends FlashcardState {
  const _FlashcardState({required  List<VocabItem> queue, this.done = 0, this.flipped = false, this.saveError}): _queue = queue,super._();
  

 final  List<VocabItem> _queue;
@override List<VocabItem> get queue {
  if (_queue is EqualUnmodifiableListView) return _queue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_queue);
}

@override@JsonKey() final  int done;
@override@JsonKey() final  bool flipped;
/// Lỗi lưu tiến độ gần nhất (để UI báo snackbar)
@override final  Object? saveError;

/// Create a copy of FlashcardState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashcardStateCopyWith<_FlashcardState> get copyWith => __$FlashcardStateCopyWithImpl<_FlashcardState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlashcardState&&const DeepCollectionEquality().equals(other.queue, _queue)&&(identical(other.done, done) || other.done == done)&&(identical(other.flipped, flipped) || other.flipped == flipped)&&const DeepCollectionEquality().equals(other.saveError, saveError));
}


@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_queue),done,flipped,const DeepCollectionEquality().hash(saveError));
}

@override
String toString() {
    return 'FlashcardState(queue: $queue, done: $done, flipped: $flipped, saveError: $saveError)';
}


}

/// @nodoc
abstract mixin class _$FlashcardStateCopyWith<$Res> implements $FlashcardStateCopyWith<$Res> {
  factory _$FlashcardStateCopyWith(_FlashcardState value, $Res Function(_FlashcardState) _then) = __$FlashcardStateCopyWithImpl;
@override @useResult
$Res call({
 List<VocabItem> queue, int done, bool flipped, Object? saveError
});




}
/// @nodoc
class __$FlashcardStateCopyWithImpl<$Res>
    implements _$FlashcardStateCopyWith<$Res> {
  __$FlashcardStateCopyWithImpl(this._self, this._then);

  final _FlashcardState _self;
  final $Res Function(_FlashcardState) _then;

/// Create a copy of FlashcardState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? queue = null,Object? done = null,Object? flipped = null,Object? saveError = freezed,}) {
  return _then(_FlashcardState(
queue: null == queue ? _self._queue : queue // ignore: cast_nullable_to_non_nullable
as List<VocabItem>,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as int,flipped: null == flipped ? _self.flipped : flipped // ignore: cast_nullable_to_non_nullable
as bool,saveError: freezed == saveError ? _self.saveError : saveError ,
  ));
}


}

// dart format on
