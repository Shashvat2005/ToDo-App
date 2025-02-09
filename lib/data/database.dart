import 'package:hive/hive.dart';

class ToDoDataBase {
  List toDoList = [];

  // reference the Hive box
  final _myBox = Hive.box('myBox');

  void createInitialData() {
    toDoList = [
      ["Task 1", false],
      ["Task 2", false],
    ];
    _myBox.put("TODOLIST", toDoList);
  }

  void loadData() {
    toDoList = _myBox.get("TODOLIST");
  }

  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
