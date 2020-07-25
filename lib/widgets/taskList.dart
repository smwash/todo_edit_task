import 'package:clone_todo/model/provider/task_provider.dart';
import 'package:clone_todo/screens/addtask_screen.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TasksList extends StatefulWidget {
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    final task = Provider.of<TaskData>(context);
    return Container(
      child: ListView.builder(
          itemCount: task.taskCount,
          itemBuilder: (context, index) {
            final tasks = task.tasks[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              color: Colors.grey[100],
              child: Row(
                children: [
                  Container(
                    width: 15.0,
                    height: 65.0,
                    color: tasks.color,
                  ),
                  Expanded(
                    child: Dismissible(
                      key: ValueKey(tasks.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        task.deleteTask(tasks.id);
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: tasks.isDone,
                          onChanged: (value) => task.changeStatus(tasks),
                        ),
                        title: Text(
                          tasks.task,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                            decoration: tasks.isDone
                                ? TextDecoration.lineThrough
                                : null,
                            decorationThickness: 2,
                          ),
                        ),
                        subtitle: Text(tasks.dueDate == null
                            ? null
                            : 'Due Date: ${DateFormat.yMMMd().format(tasks.dueDate)} ${tasks.dueTime.format(context)}'),
                        trailing: !tasks.isDone
                            ? IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddTaskScreen(
                                        isEditMode: true,
                                        id: tasks.id,
                                      ),
                                    ),
                                  );
                                },
                              )
                            : null,
                      ),
                      background: Container(
                        padding: EdgeInsets.all(15.0),
                        color: Colors.red[200],
                        alignment: Alignment.centerRight,
                        child: Column(
                          children: [
                            Icon(Icons.delete, color: Colors.white),
                            SizedBox(height: 2.0),
                            Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
