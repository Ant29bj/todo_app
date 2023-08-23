import 'package:flutter/material.dart';
import 'package:todo_list/app/model/task.dart';
import 'package:todo_list/app/repository/task_repository.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _taskList = [];

  final TaskRepository _taskRepository = TaskRepository();

  Future<void> fetchTask() async {
    _taskList = await _taskRepository.getTasks();
    notifyListeners();
  }

  List<Task> get taskList => _taskList;

  onTaskDoneChange(Task task) {
    task.done = !task.done;
    _taskRepository.saveTasks(_taskList);
    notifyListeners();
  }

  void addNewTask(Task task) {
    _taskRepository.addTask(task);
    fetchTask();
  }

  void onTaskDelete(int index) {
    _taskList.removeAt(index);
    _taskRepository.saveTasks(_taskList);
    fetchTask();
  }
}
