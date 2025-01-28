import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart';

import 'package:todo/utils/dialogbox.dart';
import 'package:todo/utils/drawer.dart';

import '../utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hIve box
  final myBox = Hive.box("myBox");
  ToDoDataBase db = ToDoDataBase();
  bool switchVal = false;

  @override
  void initState() {
    //if first time
    if (myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  final TextEditingController _controller = TextEditingController();

  void valueChanged(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewTask() {
    setState(() {
      showDialog(
        context: context,
        builder: (context) {
          return Dialogbox(
            controller: _controller,
            onSaved: saveNewTask,
            onCancelled: () => Navigator.of(context).pop(),
          );
        },
      );
    });
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          title: const Text(
            'Tasks',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          elevation: 0,
        ),
        drawer: DrawerPage(),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          elevation: 0,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: db.toDoList.length,
          itemBuilder: (context, index) {
            return ToDoTile(
              taskName: db.toDoList[index][0],
              taskCompleted: db.toDoList[index][1],
              onChanged: (value) => valueChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },
        ));
  }
}
