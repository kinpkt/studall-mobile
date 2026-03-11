import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../data/models/task_model.dart';
import 'task_tile.dart';

List<TaskModel> filterPastThisWeekTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  final sevenDaysAgo = today.subtract(const Duration(days: 7));

  return tasks.where((task) =>
  task.endDateTime.isBefore(today) &&
      task.endDateTime.isAfter(sevenDaysAgo)
  ).toList();
}

List<TaskModel> filterPastLastWeekTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  final sevenDaysAgo = today.subtract(const Duration(days: 7));
  final fourteenDaysAgo = today.subtract(const Duration(days: 14));

  return tasks.where((task) =>
  (task.endDateTime.isBefore(sevenDaysAgo) || task.endDateTime.isAtSameMomentAs(sevenDaysAgo)) &&
      task.endDateTime.isAfter(fourteenDaysAgo)
  ).toList();
}

List<TaskModel> filterPastEarlierTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  final fourteenDaysAgo = today.subtract(const Duration(days: 14));

  return tasks.where((task) =>
  task.endDateTime.isBefore(fourteenDaysAgo) ||
      task.endDateTime.isAtSameMomentAs(fourteenDaysAgo)
  ).toList();
}

List<TaskModel> filterFutureThisWeekTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  final nextWeek = today.add(const Duration(days: 7));

  return tasks.where((task) =>
  (task.endDateTime.isAfter(today) || task.endDateTime.isAtSameMomentAs(today)) &&
      task.endDateTime.isBefore(nextWeek)
  ).toList();
}

List<TaskModel> filterFutureNextWeekTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  final nextWeek = today.add(const Duration(days: 7));
  final twoWeeks = today.add(const Duration(days: 14));

  return tasks.where((task) =>
  (task.endDateTime.isAfter(nextWeek) || task.endDateTime.isAtSameMomentAs(nextWeek)) &&
      task.endDateTime.isBefore(twoWeeks)
  ).toList();
}

List<TaskModel> filterFutureLaterTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  final twoWeeks = today.add(const Duration(days: 14));

  return tasks.where((task) =>
  task.endDateTime.isAfter(twoWeeks) ||
      task.endDateTime.isAtSameMomentAs(twoWeeks)
  ).toList();
}

List<TaskModel> filterDoneBeforeDueTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  return tasks.where((task) =>
  task.endDateTime.isAfter(today) && task.isDone
  ).toList();
}

class ExpansionTaskList extends StatefulWidget {
  final String title;
  final List<TaskModel> tasks;
  final bool? initiallyExpanded;
  final int? previewCount;

  const ExpansionTaskList({
    required this.title,
    required this.tasks,
    this.initiallyExpanded,
    this.previewCount = 3,
    super.key,
  });

  @override
  State<ExpansionTaskList> createState() => _ExpansionTaskListState();
}

class _ExpansionTaskListState extends State<ExpansionTaskList> {
  late bool _showAll;

  @override
  void initState() {
    super.initState();
    _showAll = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final displayTasks = _showAll
        ? widget.tasks
        : widget.tasks.take(widget.previewCount ?? 3).toList();
    final hasMore = widget.tasks.length > (widget.previewCount ?? 3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
      child: ExpansionTile(
        initiallyExpanded: widget.initiallyExpanded ?? false,
        minTileHeight: 24.0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: textTheme.custom['medium']?.copyWith(
                color: colorScheme.foreground,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              widget.tasks.length.toString(),
              style: textTheme.custom['medium']?.copyWith(
                color: colorScheme.mutedForeground,
                height: 20 / 16,
              ),
            ),
          ],
        ),
        childrenPadding: const EdgeInsets.only(bottom: 6.0),
        children: [
          ...displayTasks.map((task) => TaskTile(task: task)),
          if (hasMore && !_showAll)
            TextButton(
              onPressed: () => setState(() => _showAll = true),
              child: Text(
                'ดูเพิ่ม',
                style: textTheme.small.copyWith(
                  color: colorScheme.mutedForeground,
                ),
              ),
            ),
        ],
      ),
    );
  }
}