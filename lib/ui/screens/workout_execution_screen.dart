import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:refactor_me/data/models/exercise.dart';
import 'package:refactor_me/data/models/menu.dart';
import 'package:refactor_me/providers/database_provider.dart';
import 'package:refactor_me/providers/workout_provider.dart';

class WorkoutExecutionScreen extends ConsumerWidget {
  const WorkoutExecutionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workoutState = ref.watch(workoutControllerProvider);
    final workoutController = ref.read(workoutControllerProvider.notifier);

    if (!workoutState.isWorkoutActive) {
      return _MenuSelectionScreen(
        onMenuSelected: (menu, exercises) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('開始しました')));
          workoutController.startMenu(menu, exercises);
        },
      );
    }

    final exercise = workoutState.currentExercise!;
    final currentSet = workoutState.currentSet;
    final totalSets = workoutState.totalSets;
    final targetReps = workoutState.targetReps;

    return Scaffold(
      appBar: AppBar(
        title: Text('トレーニング: ${exercise.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('トレーニング終了'),
                      content: const Text('トレーニングを終了しますか？'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('キャンセル'),
                        ),
                        TextButton(
                          onPressed: () {
                            workoutController.stopWorkout();
                            Navigator.pop(context);
                          },
                          child: const Text('終了'),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                exercise.name,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Text(
                'セット $currentSet / $totalSets',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                '目標: $targetReps 回',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(color: Colors.grey[700]),
              ),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.widgets, size: 48, color: Colors.blue[700]),
                    const SizedBox(height: 16),
                    Text(
                      'ホームウィジェットから\n「セット完了」ボタンを\nタップしてください',
                      style: Theme.of(context).textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// メニューの一覧を表示
class _MenuSelectionScreen extends ConsumerWidget {
  final Function(Menu, List<Exercise>) onMenuSelected;
  const _MenuSelectionScreen({required this.onMenuSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbAsync = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('メニューを選択して開始')),
      body: dbAsync.when(
        data: (isar) {
          return StreamBuilder<List<Menu>>(
            stream: isar.menus.where().watch(fireImmediately: true),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final menus = snapshot.data!;
              if (menus.isEmpty) return const Center(child: Text("メニューがありません"));

              return ListView.builder(
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  final menu = menus[index];
                  return ListTile(
                    title: Text(menu.name),
                    subtitle: Text('${menu.exerciseIds.length} 種目'),
                    onTap: () async {
                      // メニューが持つexerciseIdsを元に、種目の存在チェックを行う
                      final exercises = await isar.exercises.getAll(
                        menu.exerciseIds,
                      );
                      final validExercises =
                          exercises.whereType<Exercise>().toList();
                      if (validExercises.isNotEmpty) {
                        onMenuSelected(menu, validExercises);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('有効な種目がメニューに存在しません')),
                        );
                      }
                    },
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, s) => Center(child: Text('エラー: $err')),
      ),
    );
  }
}
