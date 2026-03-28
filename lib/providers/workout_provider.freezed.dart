// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workout_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$WorkoutState {
  bool get isWorkoutActive => throw _privateConstructorUsedError;
  Exercise? get currentExercise => throw _privateConstructorUsedError;
  int get currentSet => throw _privateConstructorUsedError;
  int get targetReps => throw _privateConstructorUsedError;
  int get totalSets => throw _privateConstructorUsedError;
  int? get currentMenuId => throw _privateConstructorUsedError;
  List<Exercise> get remainingExercises => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $WorkoutStateCopyWith<WorkoutState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WorkoutStateCopyWith<$Res> {
  factory $WorkoutStateCopyWith(
          WorkoutState value, $Res Function(WorkoutState) then) =
      _$WorkoutStateCopyWithImpl<$Res, WorkoutState>;
  @useResult
  $Res call(
      {bool isWorkoutActive,
      Exercise? currentExercise,
      int currentSet,
      int targetReps,
      int totalSets,
      int? currentMenuId,
      List<Exercise> remainingExercises});
}

/// @nodoc
class _$WorkoutStateCopyWithImpl<$Res, $Val extends WorkoutState>
    implements $WorkoutStateCopyWith<$Res> {
  _$WorkoutStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isWorkoutActive = null,
    Object? currentExercise = freezed,
    Object? currentSet = null,
    Object? targetReps = null,
    Object? totalSets = null,
    Object? currentMenuId = freezed,
    Object? remainingExercises = null,
  }) {
    return _then(_value.copyWith(
      isWorkoutActive: null == isWorkoutActive
          ? _value.isWorkoutActive
          : isWorkoutActive // ignore: cast_nullable_to_non_nullable
              as bool,
      currentExercise: freezed == currentExercise
          ? _value.currentExercise
          : currentExercise // ignore: cast_nullable_to_non_nullable
              as Exercise?,
      currentSet: null == currentSet
          ? _value.currentSet
          : currentSet // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: null == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as int,
      totalSets: null == totalSets
          ? _value.totalSets
          : totalSets // ignore: cast_nullable_to_non_nullable
              as int,
      currentMenuId: freezed == currentMenuId
          ? _value.currentMenuId
          : currentMenuId // ignore: cast_nullable_to_non_nullable
              as int?,
      remainingExercises: null == remainingExercises
          ? _value.remainingExercises
          : remainingExercises // ignore: cast_nullable_to_non_nullable
              as List<Exercise>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WorkoutStateImplCopyWith<$Res>
    implements $WorkoutStateCopyWith<$Res> {
  factory _$$WorkoutStateImplCopyWith(
          _$WorkoutStateImpl value, $Res Function(_$WorkoutStateImpl) then) =
      __$$WorkoutStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isWorkoutActive,
      Exercise? currentExercise,
      int currentSet,
      int targetReps,
      int totalSets,
      int? currentMenuId,
      List<Exercise> remainingExercises});
}

/// @nodoc
class __$$WorkoutStateImplCopyWithImpl<$Res>
    extends _$WorkoutStateCopyWithImpl<$Res, _$WorkoutStateImpl>
    implements _$$WorkoutStateImplCopyWith<$Res> {
  __$$WorkoutStateImplCopyWithImpl(
      _$WorkoutStateImpl _value, $Res Function(_$WorkoutStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isWorkoutActive = null,
    Object? currentExercise = freezed,
    Object? currentSet = null,
    Object? targetReps = null,
    Object? totalSets = null,
    Object? currentMenuId = freezed,
    Object? remainingExercises = null,
  }) {
    return _then(_$WorkoutStateImpl(
      isWorkoutActive: null == isWorkoutActive
          ? _value.isWorkoutActive
          : isWorkoutActive // ignore: cast_nullable_to_non_nullable
              as bool,
      currentExercise: freezed == currentExercise
          ? _value.currentExercise
          : currentExercise // ignore: cast_nullable_to_non_nullable
              as Exercise?,
      currentSet: null == currentSet
          ? _value.currentSet
          : currentSet // ignore: cast_nullable_to_non_nullable
              as int,
      targetReps: null == targetReps
          ? _value.targetReps
          : targetReps // ignore: cast_nullable_to_non_nullable
              as int,
      totalSets: null == totalSets
          ? _value.totalSets
          : totalSets // ignore: cast_nullable_to_non_nullable
              as int,
      currentMenuId: freezed == currentMenuId
          ? _value.currentMenuId
          : currentMenuId // ignore: cast_nullable_to_non_nullable
              as int?,
      remainingExercises: null == remainingExercises
          ? _value._remainingExercises
          : remainingExercises // ignore: cast_nullable_to_non_nullable
              as List<Exercise>,
    ));
  }
}

/// @nodoc

class _$WorkoutStateImpl implements _WorkoutState {
  const _$WorkoutStateImpl(
      {this.isWorkoutActive = false,
      this.currentExercise,
      this.currentSet = 1,
      this.targetReps = 10,
      this.totalSets = 3,
      this.currentMenuId,
      final List<Exercise> remainingExercises = const []})
      : _remainingExercises = remainingExercises;

  @override
  @JsonKey()
  final bool isWorkoutActive;
  @override
  final Exercise? currentExercise;
  @override
  @JsonKey()
  final int currentSet;
  @override
  @JsonKey()
  final int targetReps;
  @override
  @JsonKey()
  final int totalSets;
  @override
  final int? currentMenuId;
  final List<Exercise> _remainingExercises;
  @override
  @JsonKey()
  List<Exercise> get remainingExercises {
    if (_remainingExercises is EqualUnmodifiableListView)
      return _remainingExercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_remainingExercises);
  }

  @override
  String toString() {
    return 'WorkoutState(isWorkoutActive: $isWorkoutActive, currentExercise: $currentExercise, currentSet: $currentSet, targetReps: $targetReps, totalSets: $totalSets, currentMenuId: $currentMenuId, remainingExercises: $remainingExercises)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WorkoutStateImpl &&
            (identical(other.isWorkoutActive, isWorkoutActive) ||
                other.isWorkoutActive == isWorkoutActive) &&
            (identical(other.currentExercise, currentExercise) ||
                other.currentExercise == currentExercise) &&
            (identical(other.currentSet, currentSet) ||
                other.currentSet == currentSet) &&
            (identical(other.targetReps, targetReps) ||
                other.targetReps == targetReps) &&
            (identical(other.totalSets, totalSets) ||
                other.totalSets == totalSets) &&
            (identical(other.currentMenuId, currentMenuId) ||
                other.currentMenuId == currentMenuId) &&
            const DeepCollectionEquality()
                .equals(other._remainingExercises, _remainingExercises));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      isWorkoutActive,
      currentExercise,
      currentSet,
      targetReps,
      totalSets,
      currentMenuId,
      const DeepCollectionEquality().hash(_remainingExercises));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WorkoutStateImplCopyWith<_$WorkoutStateImpl> get copyWith =>
      __$$WorkoutStateImplCopyWithImpl<_$WorkoutStateImpl>(this, _$identity);
}

abstract class _WorkoutState implements WorkoutState {
  const factory _WorkoutState(
      {final bool isWorkoutActive,
      final Exercise? currentExercise,
      final int currentSet,
      final int targetReps,
      final int totalSets,
      final int? currentMenuId,
      final List<Exercise> remainingExercises}) = _$WorkoutStateImpl;

  @override
  bool get isWorkoutActive;
  @override
  Exercise? get currentExercise;
  @override
  int get currentSet;
  @override
  int get targetReps;
  @override
  int get totalSets;
  @override
  int? get currentMenuId;
  @override
  List<Exercise> get remainingExercises;
  @override
  @JsonKey(ignore: true)
  _$$WorkoutStateImplCopyWith<_$WorkoutStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
