import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:refactor_me/providers/database_provider.dart';
import 'package:refactor_me/data/models/workout_logs.dart';

part 'workout_logs_provider.g.dart';

@riverpod
Future<void> deleteWorkoutLog(DeleteWorkoutLogRef ref, Id id) async {
  final isar = await ref.read(databaseProvider.future);
  await isar.writeTxn(() async {
    await isar.workoutLogs.delete(id);
  });
}

// データが存在する日付を返す
// 重複排除のためSetを指定
@riverpod
Future<Set<DateTime>> workoutLogDaysInMonth(
  WorkoutLogDaysInMonthRef ref,
  DateTime month,
) async {
  final isar = await ref.read(databaseProvider.future);
  final start = DateTime(month.year, month.month, 1);
  final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

  final logs =
      await isar.workoutLogs.filter().createdAtBetween(start, end).findAll();

  return logs
      .map(
        (log) => DateTime(
          log.createdAt.year,
          log.createdAt.month,
          log.createdAt.day,
        ),
      )
      .toSet();
}

// 日付選択時にワークアウト一覧を返す
@riverpod
Future<List<WorkoutLogs>> workoutLogsByDate(
  WorkoutLogsByDateRef ref,
  DateTime date,
) async {
  final isar = await ref.read(databaseProvider.future);
  final start = DateTime(date.year, date.month, date.day);
  final end = DateTime(date.year, date.month, date.day, 23, 59, 59);

  return isar.workoutLogs.filter().createdAtBetween(start, end).findAll();
}
