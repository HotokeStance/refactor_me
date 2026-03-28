// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_logs_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$deleteWorkoutLogHash() => r'294204140bd14ab29b0c1d131d4c5e9acf1bf33f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [deleteWorkoutLog].
@ProviderFor(deleteWorkoutLog)
const deleteWorkoutLogProvider = DeleteWorkoutLogFamily();

/// See also [deleteWorkoutLog].
class DeleteWorkoutLogFamily extends Family<AsyncValue<void>> {
  /// See also [deleteWorkoutLog].
  const DeleteWorkoutLogFamily();

  /// See also [deleteWorkoutLog].
  DeleteWorkoutLogProvider call(
    int id,
  ) {
    return DeleteWorkoutLogProvider(
      id,
    );
  }

  @override
  DeleteWorkoutLogProvider getProviderOverride(
    covariant DeleteWorkoutLogProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'deleteWorkoutLogProvider';
}

/// See also [deleteWorkoutLog].
class DeleteWorkoutLogProvider extends AutoDisposeFutureProvider<void> {
  /// See also [deleteWorkoutLog].
  DeleteWorkoutLogProvider(
    int id,
  ) : this._internal(
          (ref) => deleteWorkoutLog(
            ref as DeleteWorkoutLogRef,
            id,
          ),
          from: deleteWorkoutLogProvider,
          name: r'deleteWorkoutLogProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$deleteWorkoutLogHash,
          dependencies: DeleteWorkoutLogFamily._dependencies,
          allTransitiveDependencies:
              DeleteWorkoutLogFamily._allTransitiveDependencies,
          id: id,
        );

  DeleteWorkoutLogProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  Override overrideWith(
    FutureOr<void> Function(DeleteWorkoutLogRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DeleteWorkoutLogProvider._internal(
        (ref) => create(ref as DeleteWorkoutLogRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _DeleteWorkoutLogProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DeleteWorkoutLogProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DeleteWorkoutLogRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `id` of this provider.
  int get id;
}

class _DeleteWorkoutLogProviderElement
    extends AutoDisposeFutureProviderElement<void> with DeleteWorkoutLogRef {
  _DeleteWorkoutLogProviderElement(super.provider);

  @override
  int get id => (origin as DeleteWorkoutLogProvider).id;
}

String _$workoutLogDaysInMonthHash() =>
    r'51593a54e6e4a08b1fa5a94c51845e3659d9ebdd';

/// See also [workoutLogDaysInMonth].
@ProviderFor(workoutLogDaysInMonth)
const workoutLogDaysInMonthProvider = WorkoutLogDaysInMonthFamily();

/// See also [workoutLogDaysInMonth].
class WorkoutLogDaysInMonthFamily extends Family<AsyncValue<Set<DateTime>>> {
  /// See also [workoutLogDaysInMonth].
  const WorkoutLogDaysInMonthFamily();

  /// See also [workoutLogDaysInMonth].
  WorkoutLogDaysInMonthProvider call(
    DateTime month,
  ) {
    return WorkoutLogDaysInMonthProvider(
      month,
    );
  }

  @override
  WorkoutLogDaysInMonthProvider getProviderOverride(
    covariant WorkoutLogDaysInMonthProvider provider,
  ) {
    return call(
      provider.month,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workoutLogDaysInMonthProvider';
}

/// See also [workoutLogDaysInMonth].
class WorkoutLogDaysInMonthProvider
    extends AutoDisposeFutureProvider<Set<DateTime>> {
  /// See also [workoutLogDaysInMonth].
  WorkoutLogDaysInMonthProvider(
    DateTime month,
  ) : this._internal(
          (ref) => workoutLogDaysInMonth(
            ref as WorkoutLogDaysInMonthRef,
            month,
          ),
          from: workoutLogDaysInMonthProvider,
          name: r'workoutLogDaysInMonthProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workoutLogDaysInMonthHash,
          dependencies: WorkoutLogDaysInMonthFamily._dependencies,
          allTransitiveDependencies:
              WorkoutLogDaysInMonthFamily._allTransitiveDependencies,
          month: month,
        );

  WorkoutLogDaysInMonthProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.month,
  }) : super.internal();

  final DateTime month;

  @override
  Override overrideWith(
    FutureOr<Set<DateTime>> Function(WorkoutLogDaysInMonthRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkoutLogDaysInMonthProvider._internal(
        (ref) => create(ref as WorkoutLogDaysInMonthRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        month: month,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Set<DateTime>> createElement() {
    return _WorkoutLogDaysInMonthProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutLogDaysInMonthProvider && other.month == month;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, month.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WorkoutLogDaysInMonthRef on AutoDisposeFutureProviderRef<Set<DateTime>> {
  /// The parameter `month` of this provider.
  DateTime get month;
}

class _WorkoutLogDaysInMonthProviderElement
    extends AutoDisposeFutureProviderElement<Set<DateTime>>
    with WorkoutLogDaysInMonthRef {
  _WorkoutLogDaysInMonthProviderElement(super.provider);

  @override
  DateTime get month => (origin as WorkoutLogDaysInMonthProvider).month;
}

String _$workoutLogsByDateHash() => r'a2ad35f8113768632968aab04e4ee057cb530d0d';

/// See also [workoutLogsByDate].
@ProviderFor(workoutLogsByDate)
const workoutLogsByDateProvider = WorkoutLogsByDateFamily();

/// See also [workoutLogsByDate].
class WorkoutLogsByDateFamily extends Family<AsyncValue<List<WorkoutLogs>>> {
  /// See also [workoutLogsByDate].
  const WorkoutLogsByDateFamily();

  /// See also [workoutLogsByDate].
  WorkoutLogsByDateProvider call(
    DateTime date,
  ) {
    return WorkoutLogsByDateProvider(
      date,
    );
  }

  @override
  WorkoutLogsByDateProvider getProviderOverride(
    covariant WorkoutLogsByDateProvider provider,
  ) {
    return call(
      provider.date,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'workoutLogsByDateProvider';
}

/// See also [workoutLogsByDate].
class WorkoutLogsByDateProvider
    extends AutoDisposeFutureProvider<List<WorkoutLogs>> {
  /// See also [workoutLogsByDate].
  WorkoutLogsByDateProvider(
    DateTime date,
  ) : this._internal(
          (ref) => workoutLogsByDate(
            ref as WorkoutLogsByDateRef,
            date,
          ),
          from: workoutLogsByDateProvider,
          name: r'workoutLogsByDateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$workoutLogsByDateHash,
          dependencies: WorkoutLogsByDateFamily._dependencies,
          allTransitiveDependencies:
              WorkoutLogsByDateFamily._allTransitiveDependencies,
          date: date,
        );

  WorkoutLogsByDateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final DateTime date;

  @override
  Override overrideWith(
    FutureOr<List<WorkoutLogs>> Function(WorkoutLogsByDateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkoutLogsByDateProvider._internal(
        (ref) => create(ref as WorkoutLogsByDateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<WorkoutLogs>> createElement() {
    return _WorkoutLogsByDateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkoutLogsByDateProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin WorkoutLogsByDateRef on AutoDisposeFutureProviderRef<List<WorkoutLogs>> {
  /// The parameter `date` of this provider.
  DateTime get date;
}

class _WorkoutLogsByDateProviderElement
    extends AutoDisposeFutureProviderElement<List<WorkoutLogs>>
    with WorkoutLogsByDateRef {
  _WorkoutLogsByDateProviderElement(super.provider);

  @override
  DateTime get date => (origin as WorkoutLogsByDateProvider).date;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
