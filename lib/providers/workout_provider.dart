import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refactor_me/providers/database_provider.dart';
import '../data/models/exercise.dart';
import '../data/models/menu.dart';

part 'workout_provider.freezed.dart';
part 'workout_provider.g.dart';

@freezed
class WorkoutState with _$WorkoutState {
  const factory WorkoutState({
    @Default(false) bool isWorkoutActive,
    Exercise? currentExercise,
    @Default(1) int currentSet,
    @Default(10) int targetReps,
    @Default(3) int totalSets,
    int? currentMenuId,
    @Default([]) List<Exercise> remainingExercises,
  }) = _WorkoutState;
}

@riverpod
class WorkoutController extends _$WorkoutController {
  @override
  WorkoutState build() {
    // 初期状態作成 と 状態復元
    // microtaskでUIの構築を邪魔せず、データをSharedPreferencesから復元、反映を行う
    Future.microtask(() => _restoreStateFromWidget());
    return const WorkoutState();
  }

  /// ウィジェットで更新された値を取得、アプリに反映する
  Future<void> _restoreStateFromWidget() async {
    try {
      // FlutterSharedPreferencesから状態を読み取る（Kotlin側と共有）
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload(); // Kotlin側の変更を反映

      final isActive = prefs.getBool('isActive') ?? false;

      if (isActive) {
        final exerciseName = prefs.getString('exerciseName');
        final currentSet = prefs.getInt('currentSet') ?? 1;
        final totalSets = prefs.getInt('totalSets') ?? 3;
        final targetReps = prefs.getInt('targetReps') ?? 10;
        final exerciseId = prefs.getInt('currentExerciseId');
        final menuId = prefs.getInt('currentMenuId');

        print(
          "[DEBUG] SharedPreferencesから取得した情報: exercise=$exerciseName, set=$currentSet/$totalSets, exerciseId=$exerciseId",
        );

        Exercise? exercise;
        if (exerciseId != null) {
          final isar = await ref.read(databaseProvider.future);
          exercise = await isar.exercises.get(exerciseId);
        }

        // SharedPreferencesから取得できたら画面の状態を更新する
        if (exercise != null || exerciseName != null) {
          state = state.copyWith(
            isWorkoutActive: isActive,
            currentExercise: exercise,
            currentSet: currentSet,
            totalSets: totalSets,
            targetReps: targetReps,
            currentMenuId: menuId,
          );
        } else {
          print("[DEBUG] exerciseが存在しない");
        }
      } else {
        // ウィジェット側でワークアウトをすべて完了した際はこのelseに入る
        if (state.isWorkoutActive) {
          // 常に実行する方針でも問題ないが、一応ワークアウトの状態を見る
          state = state.copyWith(
            isWorkoutActive: false,
            currentExercise: null,
            remainingExercises: [],
          );
        }
      }
    } catch (e) {
      debugPrint("[ERROR] SharedPreferencesの復元でエラー: $e");
    }
  }

  Future<void> startWorkout(
    Exercise exercise, {
    int? menuId,
    List<Exercise> queue = const [],
  }) async {
    state = state.copyWith(
      isWorkoutActive: true,
      currentExercise: exercise,
      currentSet: 1,
      targetReps: exercise.defaultReps,
      totalSets: exercise.defaultSets,
      currentMenuId: menuId,
      remainingExercises: queue,
    );
    await _updateWidget();
  }

  // メニューを順番に実行する
  Future<void> startMenu(Menu menu, List<Exercise> exercises) async {
    if (exercises.isEmpty) return;
    final first = exercises.first;
    final rest = exercises.skip(1).toList();
    await startWorkout(first, menuId: menu.id, queue: rest);
  }

  Future<void> stopWorkout() async {
    state = state.copyWith(
      isWorkoutActive: false,
      currentExercise: null,
      remainingExercises: [],
    );
    await _updateWidget();
  }

  /// アプリがフォアグラウンドに戻った際の処理
  /// SharedPreferencesからデータを復元し、Stateに反映する
  Future<void> refreshStateFromStorage() async {
    await _restoreStateFromWidget();
  }

  Future<void> _updateWidget() async {
    // SharedPreferencesに全データを保存（Kotlin側と共有するため）
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'exerciseName',
        state.currentExercise?.name ?? "ワークアウトに名前がありません",
      );
      await prefs.setInt('currentSet', state.currentSet);
      await prefs.setInt('totalSets', state.totalSets);
      await prefs.setInt('targetReps', state.targetReps);
      await prefs.setBool('isActive', state.isWorkoutActive);

      if (state.currentExercise != null) {
        await prefs.setInt('currentExerciseId', state.currentExercise!.id);
      }
      if (state.currentMenuId != null) {
        await prefs.setInt('currentMenuId', state.currentMenuId!);
      }

      // 残りExerciseキュー（種目切り替え用）
      // それぞれを配列で渡す
      if (state.remainingExercises.isNotEmpty) {
        await prefs.setString(
          'remainingExerciseIds',
          state.remainingExercises.map((e) => e.id.toString()).join('|'),
        );
        await prefs.setString(
          'remainingExerciseNames',
          state.remainingExercises.map((e) => e.name).join('|'),
        );
        await prefs.setString(
          'remainingTotalSets',
          state.remainingExercises
              .map((e) => e.defaultSets.toString())
              .join('|'),
        );
        await prefs.setString(
          'remainingTargetReps',
          state.remainingExercises
              .map((e) => e.defaultReps.toString())
              .join('|'),
        );
      } else {
        await prefs.remove('remainingExerciseIds');
        await prefs.remove('remainingExerciseNames');
        await prefs.remove('remainingTotalSets');
        await prefs.remove('remainingTargetReps');
      }
    } catch (e) {
      // TODO: Snackbarにした方が良さそう
      debugPrint("[ERROR] _updateWidget SharedPreferencesへの保存に失敗しました: $e");
    }

    // メソッドチャンネルの処理
    try {
      const platform = MethodChannel('com.example.refactor_me/glance');
      final widgetData = {
        'exerciseName': state.currentExercise?.name ?? "ワークアウトに名前がありません",
        'currentSet': state.currentSet,
        'totalSets': state.totalSets,
        'targetReps': state.targetReps,
        'isActive': state.isWorkoutActive,
        'currentExerciseId': state.currentExercise?.id ?? 0,
        'currentMenuId': state.currentMenuId ?? 0,
      };
      await platform.invokeMethod('update', widgetData);
      print("[DEBUG] MethodChannelの操作に成功しました: $widgetData");
    } catch (e) {
      debugPrint("[ERROR] MethodChannelの操作に失敗しました: $e");
    }

    print(
      "[DEBUG] _updateWidgetの処理が全て成功: ${state.currentExercise?.name}, active=${state.isWorkoutActive}, set=${state.currentSet}/${state.totalSets}",
    );
  }
}
