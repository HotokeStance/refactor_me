import 'package:isar/isar.dart';

part 'exercise.g.dart';

@collection
class Exercise {
  Id id = Isar.autoIncrement;

  // 種目名
  late String name;

  // デフォルトRep回数
  int defaultReps = 10;
  // デフォルトセット回数
  int defaultSets = 3;
}
