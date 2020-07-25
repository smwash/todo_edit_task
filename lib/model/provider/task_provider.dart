import 'dart:collection';

import 'package:clone_todo/model/taskmodel.dart';
import 'package:flutter/cupertino.dart';

class TaskData with ChangeNotifier {
  List<Task> _tasks = [];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  void addTask(Task task) {
    final newTask = Task(
      id: task.id,
      task: task.task,
      dueDate: task.dueDate,
      dueTime: task.dueTime,
      color: task.color,
    );
    _tasks.add(newTask);
    notifyListeners();
  }

  // Color get taskColor {
  //   return
  // }

  //get tasks count
  int get taskCount {
    return _tasks.length;
  }

  List<Task> get completedTasks =>
      _tasks.where((task) => task.isDone == true).toList();

  List<Task> get uncompletedTasks =>
      _tasks.where((task) => task.isDone == false).toList();

  void changeStatus(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  Task findById(String id) {
    return _tasks.firstWhere((taskId) => taskId.id == id, orElse: () => null);
  }

  void deleteTask(String id) {
    _tasks.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void editTask(Task task) {
    deleteTask(task.id);
    addTask(task);
    //notifyListeners();
  }
}
