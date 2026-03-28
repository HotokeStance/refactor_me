import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/exercise.dart';
import '../data/models/menu.dart';
import '../data/models/body_weight.dart';
import '../data/models/workout_logs.dart';

// 同一のインスタンスを返すため、シングルトン
final databaseProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  if (Isar.instanceNames.isEmpty) {
    return await Isar.open([
      ExerciseSchema,
      MenuSchema,
      BodyWeightSchema,
      WorkoutLogsSchema,
    ], directory: dir.path);
  }
  return Isar.getInstance()!;
});
