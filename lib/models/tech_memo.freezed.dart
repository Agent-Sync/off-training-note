// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tech_memo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TechMemo {

 String get id; String get focus; String get outcome; MemoCondition get condition; MemoSize get size; DateTime get updatedAt; DateTime get createdAt;
/// Create a copy of TechMemo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechMemoCopyWith<TechMemo> get copyWith => _$TechMemoCopyWithImpl<TechMemo>(this as TechMemo, _$identity);

  /// Serializes this TechMemo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechMemo&&(identical(other.id, id) || other.id == id)&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.size, size) || other.size == size)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,focus,outcome,condition,size,updatedAt,createdAt);

@override
String toString() {
  return 'TechMemo(id: $id, focus: $focus, outcome: $outcome, condition: $condition, size: $size, updatedAt: $updatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TechMemoCopyWith<$Res>  {
  factory $TechMemoCopyWith(TechMemo value, $Res Function(TechMemo) _then) = _$TechMemoCopyWithImpl;
@useResult
$Res call({
 String id, String focus, String outcome, MemoCondition condition, MemoSize size, DateTime updatedAt, DateTime createdAt
});




}
/// @nodoc
class _$TechMemoCopyWithImpl<$Res>
    implements $TechMemoCopyWith<$Res> {
  _$TechMemoCopyWithImpl(this._self, this._then);

  final TechMemo _self;
  final $Res Function(TechMemo) _then;

/// Create a copy of TechMemo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? focus = null,Object? outcome = null,Object? condition = null,Object? size = null,Object? updatedAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as MemoCondition,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as MemoSize,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TechMemo].
extension TechMemoPatterns on TechMemo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TechMemo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TechMemo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TechMemo value)  $default,){
final _that = this;
switch (_that) {
case _TechMemo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TechMemo value)?  $default,){
final _that = this;
switch (_that) {
case _TechMemo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String focus,  String outcome,  MemoCondition condition,  MemoSize size,  DateTime updatedAt,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TechMemo() when $default != null:
return $default(_that.id,_that.focus,_that.outcome,_that.condition,_that.size,_that.updatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String focus,  String outcome,  MemoCondition condition,  MemoSize size,  DateTime updatedAt,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _TechMemo():
return $default(_that.id,_that.focus,_that.outcome,_that.condition,_that.size,_that.updatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String focus,  String outcome,  MemoCondition condition,  MemoSize size,  DateTime updatedAt,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TechMemo() when $default != null:
return $default(_that.id,_that.focus,_that.outcome,_that.condition,_that.size,_that.updatedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TechMemo implements TechMemo {
  const _TechMemo({required this.id, required this.focus, required this.outcome, required this.condition, required this.size, required this.updatedAt, required this.createdAt});
  factory _TechMemo.fromJson(Map<String, dynamic> json) => _$TechMemoFromJson(json);

@override final  String id;
@override final  String focus;
@override final  String outcome;
@override final  MemoCondition condition;
@override final  MemoSize size;
@override final  DateTime updatedAt;
@override final  DateTime createdAt;

/// Create a copy of TechMemo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TechMemoCopyWith<_TechMemo> get copyWith => __$TechMemoCopyWithImpl<_TechMemo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TechMemoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TechMemo&&(identical(other.id, id) || other.id == id)&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.size, size) || other.size == size)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,focus,outcome,condition,size,updatedAt,createdAt);

@override
String toString() {
  return 'TechMemo(id: $id, focus: $focus, outcome: $outcome, condition: $condition, size: $size, updatedAt: $updatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TechMemoCopyWith<$Res> implements $TechMemoCopyWith<$Res> {
  factory _$TechMemoCopyWith(_TechMemo value, $Res Function(_TechMemo) _then) = __$TechMemoCopyWithImpl;
@override @useResult
$Res call({
 String id, String focus, String outcome, MemoCondition condition, MemoSize size, DateTime updatedAt, DateTime createdAt
});




}
/// @nodoc
class __$TechMemoCopyWithImpl<$Res>
    implements _$TechMemoCopyWith<$Res> {
  __$TechMemoCopyWithImpl(this._self, this._then);

  final _TechMemo _self;
  final $Res Function(_TechMemo) _then;

/// Create a copy of TechMemo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? focus = null,Object? outcome = null,Object? condition = null,Object? size = null,Object? updatedAt = null,Object? createdAt = null,}) {
  return _then(_TechMemo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as MemoCondition,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as MemoSize,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
