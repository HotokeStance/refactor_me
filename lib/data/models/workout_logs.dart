import 'package:isar/isar.dart';

part 'workout_logs.g.dart';

@collection
class WorkoutLogs {
  Id id = Isar.autoIncrement;

  // エクササイズ名
  late String exerciseName;

  // rep数
  late int reps;

  late int sets;

  late String menuName;

  late DateTime createdAt;
}
