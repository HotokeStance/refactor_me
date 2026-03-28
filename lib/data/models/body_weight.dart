import 'package:isar/isar.dart';

part 'body_weight.g.dart';

@collection
class BodyWeight {
  // intをラップしている。Idはintのみ
  Id id = Isar.autoIncrement;

  late DateTime date;

  double weight = 0.0;
}
