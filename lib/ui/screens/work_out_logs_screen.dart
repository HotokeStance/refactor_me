import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:refactor_me/providers/workout_logs_provider.dart';

class WorkoutLogsScreen extends ConsumerStatefulWidget {
  const WorkoutLogsScreen({super.key});

  @override
  ConsumerState<WorkoutLogsScreen> createState() => _WorkoutLogsScreenState();
}

class _WorkoutLogsScreenState extends ConsumerState<WorkoutLogsScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final logsAsync = ref.watch(workoutLogsByDateProvider(_selectedDay));
    final logDaysAsync = ref.watch(workoutLogDaysInMonthProvider(_focusedDay));
    final logDays = logDaysAsync.valueOrNull ?? {};

    return Scaffold(
      appBar: AppBar(title: const Text('ワークアウト履歴')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2050),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            calendarFormat: CalendarFormat.month,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                final normalizedDay = DateTime(day.year, day.month, day.day);
                if (logDays.contains(normalizedDay)) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: logsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('エラー: $error')),
              data: (logs) {
                if (logs.isEmpty) {
                  return const Center(child: Text('この日のログはありません'));
                }
                return ListView.builder(
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return ListTile(
                      title: Text(log.exerciseName),
                      subtitle: Text('メニュー: ${log.menuName}'),
                      trailing: Text('${log.sets}セット × ${log.reps}レップ'),
                      onLongPress: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('ログを削除'),
                                content: const Text('このログを削除しますか？'),
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
                          await ref.read(
                            deleteWorkoutLogProvider(log.id).future,
                          );
                          ref.invalidate(workoutLogsByDateProvider);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
