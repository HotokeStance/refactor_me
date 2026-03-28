import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:refactor_me/data/models/body_weight.dart';
import 'package:refactor_me/data/models/exercise.dart';
import 'package:refactor_me/data/models/menu.dart';
import 'package:refactor_me/data/models/workout_logs.dart';
import 'package:refactor_me/ui/screens/home_screen.dart';

@pragma('vm:entry-point')
Future<void> backgroundCallback(Uri? uri) async {
  // ウィジェットから処理が行われた時に動作する
  debugPrint("[BACKGROUND] Callback invoked の URI: $uri");
  debugPrint("[BACKGROUND] URI host: ${uri?.host}, scheme: ${uri?.scheme}");

  if (uri?.host == 'logset') {
    // クエリパラメータの取得例
    final exerciseId = int.tryParse(uri?.queryParameters['exerciseId'] ?? '0');
    final menuId = int.tryParse(uri?.queryParameters['menuId'] ?? '0');

    debugPrint("[BACKGROUND] Params: exerciseId=$exerciseId, menuId=$menuId");

    // カレンダーデータの作成
    final dir = await getApplicationDocumentsDirectory();
    final isar =
        Isar.instanceNames.isEmpty
            ? await Isar.open([
              ExerciseSchema,
              MenuSchema,
              BodyWeightSchema,
              WorkoutLogsSchema,
            ], directory: dir.path)
            : Isar.getInstance()!;

    if (exerciseId == null) {
      debugPrint("[BACKGROUND] ExerciseIdが見つかりませんでした: id=$exerciseId");
      return;
    }
    if (menuId == null) {
      debugPrint("[BACKGROUND] MenuIdが見つかりませんでした id=$menuId");
      return;
    }

    final exercise = await isar.exercises.get(exerciseId);
    if (exercise == null) {
      debugPrint("[BACKGROUND] Exerciseが見つかりませんでした: id=$exerciseId");
      return;
    }
    final menu = await isar.menus.get(menuId);
    if (menu == null) {
      debugPrint("[BACKGROUND] Menuが見つかりませんでした id=$menuId");
      return;
    }

    final log =
        WorkoutLogs()
          ..exerciseName = exercise.name
          ..reps = exercise.defaultReps
          ..sets = exercise.defaultSets
          ..menuName = menu.name
          ..createdAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.workoutLogs.put(log);
    });

    debugPrint(
      "[BACKGROUND] WorkoutLogに保存しました: exercise=${exercise.name}, menu=${menu.name}",
    );
  } else if (uri?.host == 'completeset') {
    debugPrint("[BACKGROUND] セット完了 'completeset'");
    // NOTE: 必要に応じて処理を追加
  } else {
    debugPrint("[BACKGROUND] URI host がどれにもマッチしません");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // バックグラウンドからインテントを受信するためのコールバックを登録
  // これがないとウィジェットの操作を受けてDBに保存できない
  await HomeWidget.registerInteractivityCallback(backgroundCallback);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Muscle Counter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
