import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:refactor_me/data/models/exercise.dart';
import 'package:refactor_me/providers/database_provider.dart';

class ExerciseMasterScreen extends ConsumerWidget {
  const ExerciseMasterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbAsync = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('種目管理')),
      body: dbAsync.when(
        data: (isar) {
          return StreamBuilder<List<Exercise>>(
            stream: isar.exercises.where().watch(fireImmediately: true),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final list = snapshot.data!;
              if (list.isEmpty) {
                return const Center(child: Text("種目がありません"));
              }
              return _ExerciseList(
                exercises: list,
                onDelete: (exercise) async {
                  await isar.writeTxn(() async {
                    await isar.exercises.delete(exercise.id);
                  });
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラー: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 種目追加のダイアログ
  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final repsController = TextEditingController(text: '10');
    final setsController = TextEditingController(text: '3');

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('種目追加'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: '種目名'),
                ),
                TextField(
                  controller: repsController,
                  decoration: const InputDecoration(labelText: 'デフォルト回数'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: setsController,
                  decoration: const InputDecoration(labelText: 'デフォルトセット数'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('キャンセル'),
              ),
              TextButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    // DBに入力内容を保存する
                    final isar = await ref.read(databaseProvider.future);
                    final exercise =
                        Exercise()
                          ..name = name
                          ..defaultReps =
                              int.tryParse(repsController.text) ?? 10
                          ..defaultSets =
                              int.tryParse(setsController.text) ?? 3;

                    await isar.writeTxn(() async {
                      await isar.exercises.put(exercise);
                    });
                    // TODO: contextの扱いがよろしくないので、修正予定
                    Navigator.pop(context);
                  }
                },
                child: const Text('保存'),
              ),
            ],
          ),
    );
  }
}

class _ExerciseList extends StatelessWidget {
  final List<Exercise> exercises;
  final void Function(Exercise) onDelete;
  const _ExerciseList({required this.exercises, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: exercises.length,
      itemBuilder: (context, index) {
        final item = exercises[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text('${item.defaultSets} セット x ${item.defaultReps} 回'),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => onDelete(item),
          ),
        );
      },
    );
  }
}
