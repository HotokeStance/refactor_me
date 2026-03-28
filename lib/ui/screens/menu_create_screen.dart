import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:refactor_me/data/models/exercise.dart';
import 'package:refactor_me/data/models/menu.dart';
import 'package:refactor_me/providers/database_provider.dart';

class MenuCreateScreen extends ConsumerWidget {
  const MenuCreateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dbAsync = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('メニュー管理')),
      body: dbAsync.when(
        data: (isar) {
          return StreamBuilder<List<Menu>>(
            stream: isar.menus.where().watch(fireImmediately: true),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('エラー: ${snapshot.error}'));
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final menus = snapshot.data!;
              if (menus.isEmpty) {
                return const Center(child: Text('メニューがありません'));
              }
              return ListView.builder(
                itemCount: menus.length,
                itemBuilder: (context, index) {
                  final menu = menus[index];
                  return ListTile(
                    title: Text(menu.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('メニュー削除'),
                                content: Text('${menu.name} を削除しますか？'),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, false),
                                    child: const Text('キャンセル'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, true),
                                    child: const Text('削除'),
                                  ),
                                ],
                              ),
                        );
                        if (confirm == true) {
                          await isar.writeTxn(() async {
                            await isar.menus.delete(menu.id);
                          });
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, s) => Center(child: Text('エラー: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const _MenuAddScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _MenuAddScreen extends ConsumerStatefulWidget {
  const _MenuAddScreen();

  @override
  ConsumerState<_MenuAddScreen> createState() => _MenuAddScreenState();
}

class _MenuAddScreenState extends ConsumerState<_MenuAddScreen> {
  final _nameController = TextEditingController();
  final List<Exercise> _selectedExercises = [];

  @override
  Widget build(BuildContext context) {
    final dbAsync = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('メニュー作成')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'メニュー名'),
            ),
          ),
          Expanded(
            child: dbAsync.when(
              data: (isar) {
                return StreamBuilder<List<Exercise>>(
                  stream: isar.exercises.where().watch(fireImmediately: true),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final allExercises = snapshot.data!;
                    return ListView.builder(
                      itemCount: allExercises.length,
                      itemBuilder: (context, index) {
                        final exercise = allExercises[index];
                        final isSelected = _selectedExercises.any(
                          (e) => e.id == exercise.id,
                        );
                        return ListTile(
                          title: Text(exercise.name),
                          trailing:
                              isSelected
                                  ? const Icon(Icons.check, color: Colors.green)
                                  : null,
                          onTap: () {
                            setState(() {
                              if (isSelected) {
                                _selectedExercises.removeWhere(
                                  (e) => e.id == exercise.id,
                                );
                              } else {
                                _selectedExercises.add(exercise);
                              }
                            });
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
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveMenu,
                child: const Text('保存'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMenu() async {
    if (_nameController.text.isEmpty || _selectedExercises.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('名前を入力、または種目を選択してください')));
      return;
    }

    final isar = await ref.read(databaseProvider.future);
    final menu =
        Menu()
          ..name = _nameController.text
          ..exerciseIds = _selectedExercises.map((e) => e.id).toList();

    await isar.writeTxn(() async {
      await isar.menus.put(menu);
    });

    if (mounted) Navigator.pop(context);
  }
}
