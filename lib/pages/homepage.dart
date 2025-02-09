import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo/data/database.dart'; // Ensure this is the correct path to your database file

import 'package:todo/utils/dialogbox.dart';
import 'package:todo/utils/drawer.dart';
import '../utils/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the Hive box
  final myBox = Hive.box("myBox");
  ToDoDataBase db = ToDoDataBase();
  bool switchVal = false;
  String searchQuery = "";
  bool showCompletedTasks = false;
  bool showIncompleteTasks = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    // if first time
    if (myBox.get("TODOLIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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

  void editTask(BuildContext context, int index) {
    _controller.text = db.toDoList[index][0];
    showDialog(
      context: context,
      builder: (context) {
        return Dialogbox(
          controller: _controller,
          onSaved: () {
            setState(() {
              db.toDoList[index][0] = _controller.text;
              _controller.clear();
            });
            Navigator.of(context).pop();
            db.updateDataBase();
          },
          onCancelled: () {
            _controller.clear();
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void reorderTasks(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = db.toDoList.removeAt(oldIndex);
      db.toDoList.insert(newIndex, item);
    });
    db.updateDataBase();
  }

  void updateSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void toggleShowCompletedTasks() {
    setState(() {
      showCompletedTasks = !showCompletedTasks;
      showIncompleteTasks = false;
    });
  }

  void toggleShowIncompleteTasks() {
    setState(() {
      showIncompleteTasks = !showIncompleteTasks;
      showCompletedTasks = false;
    });
  }

  void showAllTasks() {
    setState(() {
      showCompletedTasks = false;
      showIncompleteTasks = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List filteredList = db.toDoList.where((task) {
      final matchesQuery = task[0].toLowerCase().contains(searchQuery.toLowerCase());
      final matchesFilter = (showCompletedTasks && task[1] == true) ||
          (showIncompleteTasks && task[1] == false) ||
          (!showCompletedTasks && !showIncompleteTasks);
      return matchesQuery && matchesFilter;
    }).toList();

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
      drawer: const DrawerPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        elevation: 0,
        child: const Icon(Icons.add),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Focus(
                focusNode: _focusNode,
                onFocusChange: (hasFocus) {
                  setState(() {});
                },
                child: TextField(
                  onChanged: updateSearchQuery,
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary, // Border color
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary, // Border color
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary, // Border color
                      ),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.secondary,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: PopupMenuButton<String>(
                      icon: Icon(
                        Icons.filter_list,
                        color: showCompletedTasks || showIncompleteTasks ? Colors.red : Theme.of(context).iconTheme.color,
                      ),
                      onSelected: (String result) {
                        switch (result) {
                          case 'completed':
                            toggleShowCompletedTasks();
                            break;
                          case 'incomplete':
                            toggleShowIncompleteTasks();
                            break;
                          case 'all':
                            showAllTasks();
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'completed',
                          child: Text('Show Completed Tasks'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'incomplete',
                          child: Text('Show Incomplete Tasks'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'all',
                          child: Text('Show All Tasks'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ReorderableListView(
                onReorder: reorderTasks,
                children: [
                  for (int index = 0; index < filteredList.length; index++)
                    ToDoTile(
                      key: ValueKey(filteredList[index]),
                      taskName: filteredList[index][0],
                      taskCompleted: filteredList[index][1],
                      onChanged: (value) => valueChanged(value, index),
                      deleteFunction: (context) => deleteTask(index),
                      editFunction: (context) => editTask(context, index),
                      index: index,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}