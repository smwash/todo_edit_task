import 'package:flutter/material.dart';

class Task {
  String task;
  String id;
  DateTime dueDate;
  TimeOfDay dueTime;
  //String category;
  bool isDone;
  Color color;

  Task(
      {this.task,
      this.id,
      //this.category,
      this.dueDate,
      this.color,
      this.dueTime,
      this.isDone = false});

  void toggleDone() {
    isDone = !isDone;
  }
}
