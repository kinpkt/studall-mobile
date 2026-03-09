import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../data/models/task_model.dart';
import 'task_tile.dart';

List<TaskModel> filterThisWeekTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  final nextWeek = today.add(const Duration(days: 7));
  return tasks
      .where(
        (task) =>
            task.endDateTime.isAfter(today) &&
            task.endDateTime.isBefore(nextWeek),
      )
      .toList();
}

List<TaskModel> filterNextWeekTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  final nextWeeks = today.add(const Duration(days: 7));
  return tasks
      .where((task) => task.endDateTime.isAfter(nextWeeks))
      .toList();
}

List<TaskModel> filterLaterTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  final nextTwoWeeks = today.add(const Duration(days: 14));
  return tasks.where((task) => task.endDateTime.isAfter(nextTwoWeeks)).toList();
}

List<TaskModel> filterLastWeekTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  final lastWeek = today.subtract(const Duration(days: 7));
  final lastTwoWeeks = today.subtract(const Duration(days: 14));
  return tasks
      .where(
        (task) =>
            task.endDateTime.isBefore(lastWeek) &&
            task.endDateTime.isAfter(lastTwoWeeks),
      )
      .toList();
}

List<TaskModel> filterEarlierTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  final lastTwoWeeks = today.subtract(const Duration(days: 14));
  return tasks
      .where((task) => task.endDateTime.isBefore(lastTwoWeeks))
      .toList();
}

List<TaskModel> filterDoneBeforeDueTasks(List<TaskModel> tasks) {
  final today = DateTime.now();
  return tasks
      .where((task) => task.endDateTime.isAfter(today) && task.isDone)
      .toList();
}

Widget buildExpansionTaskList(
  BuildContext context,
  String title,
  List<TaskModel> tasks,
) {
  final theme = ShadTheme.of(context);
  final colorScheme = theme.colorScheme;
  final textTheme = theme.textTheme;
  return Padding(
    padding: const EdgeInsets.fromLTRB(0, 4, 0, 10),
    child: ExpansionTile(
      minTileHeight: 24.0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textTheme.custom['medium']?.copyWith(
              color: colorScheme.foreground,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            tasks.length.toString(),
            style: textTheme.custom['medium']?.copyWith(
              color: colorScheme.mutedForeground,
              height: 20 / 16,
            ),
          ),
        ],
      ),
      childrenPadding: const EdgeInsets.only(bottom: 6.0),
      children: tasks.map((task) => TaskTile(task: task)).toList(),
    ),
  );
}
