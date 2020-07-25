import 'package:clone_todo/model/provider/task_provider.dart';
import 'package:clone_todo/widgets/taskList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'addtask_screen.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('My tasks'),
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            alignment: Alignment.centerLeft,
            child: Text(
              'Completed Tasks: ${Provider.of<TaskData>(context).completedTasks.length} of ${Provider.of<TaskData>(context).taskCount}',
              style: TextStyle(fontSize: 20.0, color: Colors.white),
            ),
          ),
        ),
      ),
      body: TasksList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskScreen(
                isEditMode: false,
              ),
            ),
          );
        },
      ),
    );
  }
}
