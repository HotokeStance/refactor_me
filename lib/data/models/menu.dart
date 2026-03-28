import 'package:isar/isar.dart';

part 'menu.g.dart';

@collection
class Menu {
  Id id = Isar.autoIncrement;

  // メニュー名
  late String name;

  // Exerciseのids
  List<int> exerciseIds = [];
}
