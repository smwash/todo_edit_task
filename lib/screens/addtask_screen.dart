import 'package:clone_todo/model/provider/task_provider.dart';
import 'package:clone_todo/model/taskmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTaskScreen extends StatefulWidget {
  final bool isEditMode;
  final String id;

  const AddTaskScreen({Key key, @required this.isEditMode, this.id})
      : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String newTask;
  DateTime pickedDueDate;
  TimeOfDay pickedDueTime;
  Task origTask;
  Color pickedColor;

  void _submitForm() {
    FocusScope.of(context).unfocus();
    final task = Provider.of<TaskData>(context, listen: false);
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (pickedDueDate == null && pickedDueTime != null) {
        pickedDueDate = DateTime.now();
      }
      if (pickedDueDate == null && pickedDueTime == null) {
        pickedDueDate = DateTime.now();
        pickedDueTime = TimeOfDay.now();
      }

      if (pickedColor == null) {
        pickedColor = Colors.white;
      }
      if (!widget.isEditMode) {
        task.addTask(
          Task(
            id: DateTime.now().toString(),
            task: newTask,
            dueTime: pickedDueTime,
            dueDate: pickedDueDate,
            color: pickedColor,
          ),
        );
      } else {
        Provider.of<TaskData>(context, listen: false).editTask(
          Task(
            id: origTask.id,
            task: newTask,
            dueTime: pickedDueTime,
            dueDate: pickedDueDate,
            color: pickedColor,
          ),
        );
      }
      Navigator.pop(context);
    }
  }

  void _pickedDueDate() {
    showDatePicker(
      context: context,
      initialDate: widget.isEditMode ? pickedDueDate : DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        pickedDueDate = pickedDate;
        print(pickedDueDate);
      });
    });
  }

  void _pickTaskColor() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Pick Task Color'),
          content: MaterialColorPicker(
            selectedColor: pickedColor,
            allowShades: false,
            onMainColorChange: (color) {
              setState(() {
                pickedColor = color;
              });
            },
          ),
          actions: [
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            FlatButton(
              child: Text('Submit'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  void _pickedDueTime() {
    showTimePicker(
      context: context,
      initialTime: widget.isEditMode ? pickedDueTime : TimeOfDay.now(),
    ).then(
      (time) {
        if (time == null) {
          return;
        }
        setState(() {
          pickedDueTime = time;
          print(pickedDueTime);
        });
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      if (widget.id != null) {
        origTask =
            Provider.of<TaskData>(context, listen: false).findById(widget.id);
        newTask = origTask.task;
        pickedDueDate = origTask.dueDate;
        pickedDueTime = origTask.dueTime;
        pickedColor = origTask.color;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        //padding:
        //EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Task Title',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  TextFormField(
                    initialValue: newTask == null ? null : newTask,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Task Title',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a task name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      newTask = value;
                    },
                  ),
                  Text(
                    'Due Date',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  TextFormField(
                    onTap: _pickedDueDate,
                    decoration: InputDecoration(
                      hintText: pickedDueDate == null
                          ? 'Pick Due Date'
                          : DateFormat.yMMMd().format(pickedDueDate),
                    ),
                  ),
                  Text(
                    'Due Time',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  TextFormField(
                    onTap: _pickedDueTime,
                    decoration: InputDecoration(
                      hintText: pickedDueTime == null
                          ? 'Pick Due time'
                          : pickedDueTime.format(context),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Pick Task Color:',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: pickedColor,
                          ),
                          IconButton(
                            icon: Icon(Icons.colorize, size: 30.0),
                            onPressed: _pickTaskColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Center(
                    child: RaisedButton(
                      onPressed: _submitForm,
                      child: Text(
                        !widget.isEditMode ? 'Create Task' : 'Update Task',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
