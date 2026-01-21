// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'air_trick.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AirTrick _$AirTrickFromJson(
  Map<String, dynamic> json
) {
    return _Trick.fromJson(
      json
    );
}

/// @nodoc
mixin _$AirTrick {

 String get id; Stance get stance; Takeoff get takeoff; String get axis; int get spin; String get grab; Direction get direction; List<TechMemo> get memos; DateTime get createdAt;
/// Create a copy of AirTrick
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AirTrickCopyWith<AirTrick> get copyWith => _$AirTrickCopyWithImpl<AirTrick>(this as AirTrick, _$identity);

  /// Serializes this AirTrick to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AirTrick&&(identical(other.id, id) || other.id == id)&&(identical(other.stance, stance) || other.stance == stance)&&(identical(other.takeoff, takeoff) || other.takeoff == takeoff)&&(identical(other.axis, axis) || other.axis == axis)&&(identical(other.spin, spin) || other.spin == spin)&&(identical(other.grab, grab) || other.grab == grab)&&(identical(other.direction, direction) || other.direction == direction)&&const DeepCollectionEquality().equals(other.memos, memos)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,stance,takeoff,axis,spin,grab,direction,const DeepCollectionEquality().hash(memos),createdAt);

@override
String toString() {
  return 'AirTrick(id: $id, stance: $stance, takeoff: $takeoff, axis: $axis, spin: $spin, grab: $grab, direction: $direction, memos: $memos, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AirTrickCopyWith<$Res>  {
  factory $AirTrickCopyWith(AirTrick value, $Res Function(AirTrick) _then) = _$AirTrickCopyWithImpl;
@useResult
$Res call({
 String id, Stance stance, Takeoff takeoff, String axis, int spin, String grab, Direction direction, List<TechMemo> memos, DateTime createdAt
});




}
/// @nodoc
class _$AirTrickCopyWithImpl<$Res>
    implements $AirTrickCopyWith<$Res> {
  _$AirTrickCopyWithImpl(this._self, this._then);

  final AirTrick _self;
  final $Res Function(AirTrick) _then;

/// Create a copy of AirTrick
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? stance = null,Object? takeoff = null,Object? axis = null,Object? spin = null,Object? grab = null,Object? direction = null,Object? memos = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stance: null == stance ? _self.stance : stance // ignore: cast_nullable_to_non_nullable
as Stance,takeoff: null == takeoff ? _self.takeoff : takeoff // ignore: cast_nullable_to_non_nullable
as Takeoff,axis: null == axis ? _self.axis : axis // ignore: cast_nullable_to_non_nullable
as String,spin: null == spin ? _self.spin : spin // ignore: cast_nullable_to_non_nullable
as int,grab: null == grab ? _self.grab : grab // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as Direction,memos: null == memos ? _self.memos : memos // ignore: cast_nullable_to_non_nullable
as List<TechMemo>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AirTrick].
extension AirTrickPatterns on AirTrick {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Trick value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Trick() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Trick value)  $default,){
final _that = this;
switch (_that) {
case _Trick():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Trick value)?  $default,){
final _that = this;
switch (_that) {
case _Trick() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  Stance stance,  Takeoff takeoff,  String axis,  int spin,  String grab,  Direction direction,  List<TechMemo> memos,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Trick() when $default != null:
return $default(_that.id,_that.stance,_that.takeoff,_that.axis,_that.spin,_that.grab,_that.direction,_that.memos,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  Stance stance,  Takeoff takeoff,  String axis,  int spin,  String grab,  Direction direction,  List<TechMemo> memos,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Trick():
return $default(_that.id,_that.stance,_that.takeoff,_that.axis,_that.spin,_that.grab,_that.direction,_that.memos,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  Stance stance,  Takeoff takeoff,  String axis,  int spin,  String grab,  Direction direction,  List<TechMemo> memos,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Trick() when $default != null:
return $default(_that.id,_that.stance,_that.takeoff,_that.axis,_that.spin,_that.grab,_that.direction,_that.memos,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Trick implements AirTrick {
  const _Trick({required this.id, required this.stance, required this.takeoff, required this.axis, required this.spin, required this.grab, required this.direction, required final  List<TechMemo> memos, required this.createdAt}): _memos = memos;
  factory _Trick.fromJson(Map<String, dynamic> json) => _$TrickFromJson(json);

@override final  String id;
@override final  Stance stance;
@override final  Takeoff takeoff;
@override final  String axis;
@override final  int spin;
@override final  String grab;
@override final  Direction direction;
 final  List<TechMemo> _memos;
@override List<TechMemo> get memos {
  if (_memos is EqualUnmodifiableListView) return _memos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memos);
}

@override final  DateTime createdAt;

/// Create a copy of AirTrick
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrickCopyWith<_Trick> get copyWith => __$TrickCopyWithImpl<_Trick>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrickToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Trick&&(identical(other.id, id) || other.id == id)&&(identical(other.stance, stance) || other.stance == stance)&&(identical(other.takeoff, takeoff) || other.takeoff == takeoff)&&(identical(other.axis, axis) || other.axis == axis)&&(identical(other.spin, spin) || other.spin == spin)&&(identical(other.grab, grab) || other.grab == grab)&&(identical(other.direction, direction) || other.direction == direction)&&const DeepCollectionEquality().equals(other._memos, _memos)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,stance,takeoff,axis,spin,grab,direction,const DeepCollectionEquality().hash(_memos),createdAt);

@override
String toString() {
  return 'AirTrick(id: $id, stance: $stance, takeoff: $takeoff, axis: $axis, spin: $spin, grab: $grab, direction: $direction, memos: $memos, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TrickCopyWith<$Res> implements $AirTrickCopyWith<$Res> {
  factory _$TrickCopyWith(_Trick value, $Res Function(_Trick) _then) = __$TrickCopyWithImpl;
@override @useResult
$Res call({
 String id, Stance stance, Takeoff takeoff, String axis, int spin, String grab, Direction direction, List<TechMemo> memos, DateTime createdAt
});




}
/// @nodoc
class __$TrickCopyWithImpl<$Res>
    implements _$TrickCopyWith<$Res> {
  __$TrickCopyWithImpl(this._self, this._then);

  final _Trick _self;
  final $Res Function(_Trick) _then;

/// Create a copy of AirTrick
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? stance = null,Object? takeoff = null,Object? axis = null,Object? spin = null,Object? grab = null,Object? direction = null,Object? memos = null,Object? createdAt = null,}) {
  return _then(_Trick(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,stance: null == stance ? _self.stance : stance // ignore: cast_nullable_to_non_nullable
as Stance,takeoff: null == takeoff ? _self.takeoff : takeoff // ignore: cast_nullable_to_non_nullable
as Takeoff,axis: null == axis ? _self.axis : axis // ignore: cast_nullable_to_non_nullable
as String,spin: null == spin ? _self.spin : spin // ignore: cast_nullable_to_non_nullable
as int,grab: null == grab ? _self.grab : grab // ignore: cast_nullable_to_non_nullable
as String,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as Direction,memos: null == memos ? _self._memos : memos // ignore: cast_nullable_to_non_nullable
as List<TechMemo>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
