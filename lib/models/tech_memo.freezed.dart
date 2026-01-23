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
TechMemo _$TechMemoFromJson(
  Map<String, dynamic> json
) {
        switch (json['type']) {
                  case 'air':
          return AirTechMemo.fromJson(
            json
          );
                case 'jib':
          return JibTechMemo.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'type',
  'TechMemo',
  'Invalid union type "${json['type']}"!'
);
        }
      
}

/// @nodoc
mixin _$TechMemo {

 String get id; String get focus; String get outcome; int get likeCount; bool get likedByMe; DateTime get updatedAt; DateTime get createdAt;
/// Create a copy of TechMemo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TechMemoCopyWith<TechMemo> get copyWith => _$TechMemoCopyWithImpl<TechMemo>(this as TechMemo, _$identity);

  /// Serializes this TechMemo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TechMemo&&(identical(other.id, id) || other.id == id)&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.likedByMe, likedByMe) || other.likedByMe == likedByMe)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,focus,outcome,likeCount,likedByMe,updatedAt,createdAt);

@override
String toString() {
  return 'TechMemo(id: $id, focus: $focus, outcome: $outcome, likeCount: $likeCount, likedByMe: $likedByMe, updatedAt: $updatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TechMemoCopyWith<$Res>  {
  factory $TechMemoCopyWith(TechMemo value, $Res Function(TechMemo) _then) = _$TechMemoCopyWithImpl;
@useResult
$Res call({
 String id, String focus, String outcome, int likeCount, bool likedByMe, DateTime updatedAt, DateTime createdAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? focus = null,Object? outcome = null,Object? likeCount = null,Object? likedByMe = null,Object? updatedAt = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,likedByMe: null == likedByMe ? _self.likedByMe : likedByMe // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( AirTechMemo value)?  air,TResult Function( JibTechMemo value)?  jib,required TResult orElse(),}){
final _that = this;
switch (_that) {
case AirTechMemo() when air != null:
return air(_that);case JibTechMemo() when jib != null:
return jib(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( AirTechMemo value)  air,required TResult Function( JibTechMemo value)  jib,}){
final _that = this;
switch (_that) {
case AirTechMemo():
return air(_that);case JibTechMemo():
return jib(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( AirTechMemo value)?  air,TResult? Function( JibTechMemo value)?  jib,}){
final _that = this;
switch (_that) {
case AirTechMemo() when air != null:
return air(_that);case JibTechMemo() when jib != null:
return jib(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String id,  String focus,  String outcome,  MemoCondition condition,  MemoSize size,  int likeCount,  bool likedByMe,  DateTime updatedAt,  DateTime createdAt)?  air,TResult Function( String id,  String focus,  String outcome,  int likeCount,  bool likedByMe,  DateTime updatedAt,  DateTime createdAt)?  jib,required TResult orElse(),}) {final _that = this;
switch (_that) {
case AirTechMemo() when air != null:
return air(_that.id,_that.focus,_that.outcome,_that.condition,_that.size,_that.likeCount,_that.likedByMe,_that.updatedAt,_that.createdAt);case JibTechMemo() when jib != null:
return jib(_that.id,_that.focus,_that.outcome,_that.likeCount,_that.likedByMe,_that.updatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String id,  String focus,  String outcome,  MemoCondition condition,  MemoSize size,  int likeCount,  bool likedByMe,  DateTime updatedAt,  DateTime createdAt)  air,required TResult Function( String id,  String focus,  String outcome,  int likeCount,  bool likedByMe,  DateTime updatedAt,  DateTime createdAt)  jib,}) {final _that = this;
switch (_that) {
case AirTechMemo():
return air(_that.id,_that.focus,_that.outcome,_that.condition,_that.size,_that.likeCount,_that.likedByMe,_that.updatedAt,_that.createdAt);case JibTechMemo():
return jib(_that.id,_that.focus,_that.outcome,_that.likeCount,_that.likedByMe,_that.updatedAt,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String id,  String focus,  String outcome,  MemoCondition condition,  MemoSize size,  int likeCount,  bool likedByMe,  DateTime updatedAt,  DateTime createdAt)?  air,TResult? Function( String id,  String focus,  String outcome,  int likeCount,  bool likedByMe,  DateTime updatedAt,  DateTime createdAt)?  jib,}) {final _that = this;
switch (_that) {
case AirTechMemo() when air != null:
return air(_that.id,_that.focus,_that.outcome,_that.condition,_that.size,_that.likeCount,_that.likedByMe,_that.updatedAt,_that.createdAt);case JibTechMemo() when jib != null:
return jib(_that.id,_that.focus,_that.outcome,_that.likeCount,_that.likedByMe,_that.updatedAt,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class AirTechMemo implements TechMemo {
  const AirTechMemo({required this.id, required this.focus, required this.outcome, required this.condition, required this.size, required this.likeCount, required this.likedByMe, required this.updatedAt, required this.createdAt, final  String? $type}): $type = $type ?? 'air';
  factory AirTechMemo.fromJson(Map<String, dynamic> json) => _$AirTechMemoFromJson(json);

@override final  String id;
@override final  String focus;
@override final  String outcome;
 final  MemoCondition condition;
 final  MemoSize size;
@override final  int likeCount;
@override final  bool likedByMe;
@override final  DateTime updatedAt;
@override final  DateTime createdAt;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of TechMemo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AirTechMemoCopyWith<AirTechMemo> get copyWith => _$AirTechMemoCopyWithImpl<AirTechMemo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AirTechMemoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AirTechMemo&&(identical(other.id, id) || other.id == id)&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.condition, condition) || other.condition == condition)&&(identical(other.size, size) || other.size == size)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.likedByMe, likedByMe) || other.likedByMe == likedByMe)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,focus,outcome,condition,size,likeCount,likedByMe,updatedAt,createdAt);

@override
String toString() {
  return 'TechMemo.air(id: $id, focus: $focus, outcome: $outcome, condition: $condition, size: $size, likeCount: $likeCount, likedByMe: $likedByMe, updatedAt: $updatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AirTechMemoCopyWith<$Res> implements $TechMemoCopyWith<$Res> {
  factory $AirTechMemoCopyWith(AirTechMemo value, $Res Function(AirTechMemo) _then) = _$AirTechMemoCopyWithImpl;
@override @useResult
$Res call({
 String id, String focus, String outcome, MemoCondition condition, MemoSize size, int likeCount, bool likedByMe, DateTime updatedAt, DateTime createdAt
});




}
/// @nodoc
class _$AirTechMemoCopyWithImpl<$Res>
    implements $AirTechMemoCopyWith<$Res> {
  _$AirTechMemoCopyWithImpl(this._self, this._then);

  final AirTechMemo _self;
  final $Res Function(AirTechMemo) _then;

/// Create a copy of TechMemo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? focus = null,Object? outcome = null,Object? condition = null,Object? size = null,Object? likeCount = null,Object? likedByMe = null,Object? updatedAt = null,Object? createdAt = null,}) {
  return _then(AirTechMemo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as MemoCondition,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as MemoSize,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,likedByMe: null == likedByMe ? _self.likedByMe : likedByMe // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class JibTechMemo implements TechMemo {
  const JibTechMemo({required this.id, required this.focus, required this.outcome, required this.likeCount, required this.likedByMe, required this.updatedAt, required this.createdAt, final  String? $type}): $type = $type ?? 'jib';
  factory JibTechMemo.fromJson(Map<String, dynamic> json) => _$JibTechMemoFromJson(json);

@override final  String id;
@override final  String focus;
@override final  String outcome;
@override final  int likeCount;
@override final  bool likedByMe;
@override final  DateTime updatedAt;
@override final  DateTime createdAt;

@JsonKey(name: 'type')
final String $type;


/// Create a copy of TechMemo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JibTechMemoCopyWith<JibTechMemo> get copyWith => _$JibTechMemoCopyWithImpl<JibTechMemo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JibTechMemoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JibTechMemo&&(identical(other.id, id) || other.id == id)&&(identical(other.focus, focus) || other.focus == focus)&&(identical(other.outcome, outcome) || other.outcome == outcome)&&(identical(other.likeCount, likeCount) || other.likeCount == likeCount)&&(identical(other.likedByMe, likedByMe) || other.likedByMe == likedByMe)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,focus,outcome,likeCount,likedByMe,updatedAt,createdAt);

@override
String toString() {
  return 'TechMemo.jib(id: $id, focus: $focus, outcome: $outcome, likeCount: $likeCount, likedByMe: $likedByMe, updatedAt: $updatedAt, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $JibTechMemoCopyWith<$Res> implements $TechMemoCopyWith<$Res> {
  factory $JibTechMemoCopyWith(JibTechMemo value, $Res Function(JibTechMemo) _then) = _$JibTechMemoCopyWithImpl;
@override @useResult
$Res call({
 String id, String focus, String outcome, int likeCount, bool likedByMe, DateTime updatedAt, DateTime createdAt
});




}
/// @nodoc
class _$JibTechMemoCopyWithImpl<$Res>
    implements $JibTechMemoCopyWith<$Res> {
  _$JibTechMemoCopyWithImpl(this._self, this._then);

  final JibTechMemo _self;
  final $Res Function(JibTechMemo) _then;

/// Create a copy of TechMemo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? focus = null,Object? outcome = null,Object? likeCount = null,Object? likedByMe = null,Object? updatedAt = null,Object? createdAt = null,}) {
  return _then(JibTechMemo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,focus: null == focus ? _self.focus : focus // ignore: cast_nullable_to_non_nullable
as String,outcome: null == outcome ? _self.outcome : outcome // ignore: cast_nullable_to_non_nullable
as String,likeCount: null == likeCount ? _self.likeCount : likeCount // ignore: cast_nullable_to_non_nullable
as int,likedByMe: null == likedByMe ? _self.likedByMe : likedByMe // ignore: cast_nullable_to_non_nullable
as bool,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
