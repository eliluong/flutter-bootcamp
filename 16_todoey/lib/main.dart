import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:collection';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Data>(
      create: (context) => Data(),
      child: MaterialApp(
        home: TasksScreen()
      ),
    );
  }
}

class Data extends ChangeNotifier {
  List<Task> _tasks = [
    Task(task: 'lame task v2'),
    Task(task: 'boring task v2'),
    Task(task: 'illegal task v2')
  ];

  UnmodifiableListView<Task> get tasks {
    return UnmodifiableListView(_tasks);
  }

  int get numTasks {
    return _tasks.length;
  }

  void addTask(String s) {
    _tasks.add(Task(task: s));
    notifyListeners();
  }

  void toggleCompleted(int i) {
    _tasks[i].toggleComplete();
    notifyListeners();
  }

  void removeTask(int i) {
    _tasks.removeAt(i);
    notifyListeners();
  }
}

class TasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String input = ''; // for input field

    return Scaffold(
      backgroundColor: Color(0xff89cff0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff89cff0),
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context, 
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                color: Color.fromRGBO(117, 117, 117, 1),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)
                    )
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Add Task',
                        style: TextStyle(
                          color: Color(0xff89cff0),
                          fontSize: 30
                        )
                      ),
                      SizedBox(height: 5),
                      TextField(
                        autofocus: true,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          // hintText: 'enter your task',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xff89cff0),
                              width: 3)
                          ),
                          isDense: true, // enable to use contentPadding
                          contentPadding: EdgeInsets.symmetric(vertical: 5),
                        ),
                        style: TextStyle(fontSize: 22),
                        onChanged: (value) {
                          input = value;
                        },
                      ),
                      SizedBox(height: 20,),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {
                            // addTask(input);
                            Provider.of<Data>(context, listen: false).addTask(input);
                            Navigator.pop(context);
                          }, 
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xff89cff0),
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero
                            )
                          ),
                          child: Text('Add', style: TextStyle(fontSize: 24))),
                      )
                    ],
                  )
                ),
              ),
            )
          );
        }
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(top: 60, left: 30, right: 30, bottom: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  child: Icon(Icons.list, size: 30, color: Color(0xff89cff0)),
                  backgroundColor: Colors.white,
                  radius: 30,
                ),
                SizedBox(height: 10),
                Text(
                  'Todoey',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 50)
                ),
                Text(
                  // '${Provider.of<Data>(context).tasks.length} tasks',
                  '${Provider.of<Data>(context).numTasks} tasks',
                  style: TextStyle(color: Colors.white, fontSize: 18)
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              ),
              // child: TasksList(tasks: tasks),
              // child: TasksList(tasks: Provider.of<Data>(context).tasks),
              child: TasksList(),
            ),
          )
        ],
      )
    );
  }
}

class TasksList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Data>(
      builder: (context, data, child) {
        return ListView.builder(itemBuilder: (context, index) {
          return Dismissible(
            key: Key(data.tasks[index].task),
            child: TaskItem(
              isCompleted: data.tasks[index].isCompleted,
              task: data.tasks[index].task,
              checkboxCallback: (value) {
                // setState(() {
                //   widget.tasks[index].toggleComplete();
                // });
                data.toggleCompleted(index);
              }
            ),
            onDismissed: (d) {
              data.removeTask(index);
            },
            background: Container(color: Colors.red),
          );
        }, itemCount: data.numTasks);
      },
    );
  }
}

// object w/task name and default isCompleted = false
class Task {
  final String task;
  bool isCompleted;

  Task({required this.task, this.isCompleted = false});

  void toggleComplete() {
    isCompleted = !isCompleted;
  }
}

class TaskItem extends StatelessWidget {
  final bool isCompleted;
  final String task;
  final Function(bool?)? checkboxCallback;

  TaskItem({required this.isCompleted, required this.task, required this.checkboxCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Checkbox(
        activeColor: Color(0xff89cff0),
        value: isCompleted, 
        onChanged: checkboxCallback
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      title: Text(
        task,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null
        )),
    );
  }
}
