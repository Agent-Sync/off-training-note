// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trick_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrickMeta {

 String get id; String get userId; bool get isPublic; String get trickName; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of TrickMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrickMetaCopyWith<TrickMeta> get copyWith => _$TrickMetaCopyWithImpl<TrickMeta>(this as TrickMeta, _$identity);

  /// Serializes this TrickMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrickMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.trickName, trickName) || other.trickName == trickName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,isPublic,trickName,createdAt,updatedAt);

@override
String toString() {
  return 'TrickMeta(id: $id, userId: $userId, isPublic: $isPublic, trickName: $trickName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TrickMetaCopyWith<$Res>  {
  factory $TrickMetaCopyWith(TrickMeta value, $Res Function(TrickMeta) _then) = _$TrickMetaCopyWithImpl;
@useResult
$Res call({
 String id, String userId, bool isPublic, String trickName, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$TrickMetaCopyWithImpl<$Res>
    implements $TrickMetaCopyWith<$Res> {
  _$TrickMetaCopyWithImpl(this._self, this._then);

  final TrickMeta _self;
  final $Res Function(TrickMeta) _then;

/// Create a copy of TrickMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? isPublic = null,Object? trickName = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,trickName: null == trickName ? _self.trickName : trickName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TrickMeta].
extension TrickMetaPatterns on TrickMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrickMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrickMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrickMeta value)  $default,){
final _that = this;
switch (_that) {
case _TrickMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrickMeta value)?  $default,){
final _that = this;
switch (_that) {
case _TrickMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  bool isPublic,  String trickName,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrickMeta() when $default != null:
return $default(_that.id,_that.userId,_that.isPublic,_that.trickName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  bool isPublic,  String trickName,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TrickMeta():
return $default(_that.id,_that.userId,_that.isPublic,_that.trickName,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  bool isPublic,  String trickName,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TrickMeta() when $default != null:
return $default(_that.id,_that.userId,_that.isPublic,_that.trickName,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrickMeta implements TrickMeta {
  const _TrickMeta({required this.id, required this.userId, this.isPublic = true, this.trickName = '', required this.createdAt, required this.updatedAt});
  factory _TrickMeta.fromJson(Map<String, dynamic> json) => _$TrickMetaFromJson(json);

@override final  String id;
@override final  String userId;
@override@JsonKey() final  bool isPublic;
@override@JsonKey() final  String trickName;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of TrickMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrickMetaCopyWith<_TrickMeta> get copyWith => __$TrickMetaCopyWithImpl<_TrickMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrickMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrickMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.isPublic, isPublic) || other.isPublic == isPublic)&&(identical(other.trickName, trickName) || other.trickName == trickName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,isPublic,trickName,createdAt,updatedAt);

@override
String toString() {
  return 'TrickMeta(id: $id, userId: $userId, isPublic: $isPublic, trickName: $trickName, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TrickMetaCopyWith<$Res> implements $TrickMetaCopyWith<$Res> {
  factory _$TrickMetaCopyWith(_TrickMeta value, $Res Function(_TrickMeta) _then) = __$TrickMetaCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, bool isPublic, String trickName, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$TrickMetaCopyWithImpl<$Res>
    implements _$TrickMetaCopyWith<$Res> {
  __$TrickMetaCopyWithImpl(this._self, this._then);

  final _TrickMeta _self;
  final $Res Function(_TrickMeta) _then;

/// Create a copy of TrickMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? isPublic = null,Object? trickName = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TrickMeta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,isPublic: null == isPublic ? _self.isPublic : isPublic // ignore: cast_nullable_to_non_nullable
as bool,trickName: null == trickName ? _self.trickName : trickName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
