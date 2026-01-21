// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'jib_trick.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JibTrick {

 String get id; String get customName; DateTime get createdAt;
/// Create a copy of JibTrick
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JibTrickCopyWith<JibTrick> get copyWith => _$JibTrickCopyWithImpl<JibTrick>(this as JibTrick, _$identity);

  /// Serializes this JibTrick to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JibTrick&&(identical(other.id, id) || other.id == id)&&(identical(other.customName, customName) || other.customName == customName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customName,createdAt);

@override
String toString() {
  return 'JibTrick(id: $id, customName: $customName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $JibTrickCopyWith<$Res>  {
  factory $JibTrickCopyWith(JibTrick value, $Res Function(JibTrick) _then) = _$JibTrickCopyWithImpl;
@useResult
$Res call({
 String id, String customName, DateTime createdAt
});




}
/// @nodoc
class _$JibTrickCopyWithImpl<$Res>
    implements $JibTrickCopyWith<$Res> {
  _$JibTrickCopyWithImpl(this._self, this._then);

  final JibTrick _self;
  final $Res Function(JibTrick) _then;

/// Create a copy of JibTrick
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? customName = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customName: null == customName ? _self.customName : customName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [JibTrick].
extension JibTrickPatterns on JibTrick {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JibTrick value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JibTrick() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JibTrick value)  $default,){
final _that = this;
switch (_that) {
case _JibTrick():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JibTrick value)?  $default,){
final _that = this;
switch (_that) {
case _JibTrick() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String customName,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JibTrick() when $default != null:
return $default(_that.id,_that.customName,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String customName,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _JibTrick():
return $default(_that.id,_that.customName,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String customName,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _JibTrick() when $default != null:
return $default(_that.id,_that.customName,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JibTrick implements JibTrick {
  const _JibTrick({required this.id, required this.customName, required this.createdAt});
  factory _JibTrick.fromJson(Map<String, dynamic> json) => _$JibTrickFromJson(json);

@override final  String id;
@override final  String customName;
@override final  DateTime createdAt;

/// Create a copy of JibTrick
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JibTrickCopyWith<_JibTrick> get copyWith => __$JibTrickCopyWithImpl<_JibTrick>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JibTrickToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JibTrick&&(identical(other.id, id) || other.id == id)&&(identical(other.customName, customName) || other.customName == customName)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,customName,createdAt);

@override
String toString() {
  return 'JibTrick(id: $id, customName: $customName, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$JibTrickCopyWith<$Res> implements $JibTrickCopyWith<$Res> {
  factory _$JibTrickCopyWith(_JibTrick value, $Res Function(_JibTrick) _then) = __$JibTrickCopyWithImpl;
@override @useResult
$Res call({
 String id, String customName, DateTime createdAt
});




}
/// @nodoc
class __$JibTrickCopyWithImpl<$Res>
    implements _$JibTrickCopyWith<$Res> {
  __$JibTrickCopyWithImpl(this._self, this._then);

  final _JibTrick _self;
  final $Res Function(_JibTrick) _then;

/// Create a copy of JibTrick
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? customName = null,Object? createdAt = null,}) {
  return _then(_JibTrick(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,customName: null == customName ? _self.customName : customName // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
