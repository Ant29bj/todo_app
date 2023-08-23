import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/app/model/task.dart';
import 'package:todo_list/app/view/components/h1.dart';
import 'package:todo_list/app/view/components/shape.dart';
import 'package:todo_list/app/view/task_list/task_provider.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskProvider()..fetchTask(),
      child: Scaffold(
        body: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(),
            Expanded(
              child: _TaskList(),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () => _showNewTaskModal(context),
            child: const Icon(
              Icons.add,
              size: 50,
            ),
          ),
        ),
      ),
    );
  }

  void _showNewTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<TaskProvider>(),
        child: _NewTaskModal(),
      ),
    );
  }
}

class _NewTaskModal extends StatefulWidget {
  _NewTaskModal({super.key});

  @override
  State<_NewTaskModal> createState() => _NewTaskModalState();
}

class _NewTaskModalState extends State<_NewTaskModal> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 23),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(21),
          ),
          color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const H1(text: 'Nueva Tarea'),
          const SizedBox(
            height: 26,
          ),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                hintText: 'Descripcion de la tarea'),
          ),
          const SizedBox(
            height: 26,
          ),
          ElevatedButton(
            onPressed: () {
              if (_controller.text.isNotEmpty) {
                final task = Task(_controller.text);
                context.read<TaskProvider>().addNewTask(task);
                Navigator.of(context).pop();
              }
            },
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const H1(text: 'Tareas'),
          Expanded(
            child: Consumer<TaskProvider>(
              builder: (_, provider, __) {
                if (provider.taskList.isEmpty) {
                  return const Center(
                    child: Text('No hay tareas'),
                  );
                }
                return (ListView.separated(
                  itemCount: provider.taskList.length,
                  separatorBuilder: (_, __) => const SizedBox(
                    height: 16,
                  ),
                  itemBuilder: (_, index) => _TaskItem(
                    provider.taskList[index],
                    onTap: () => provider.onTaskDoneChange(
                      provider.taskList[index],
                    ),
                    taskIndex: index,
                  ),
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        children: [
          const Row(
            children: [Shape()],
          ),
          Column(
            children: [
              Image.asset(
                'assets/images/tasks-list-image.png',
                width: 120,
                height: 120,
              )
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: H1(
              text: 'Completa tus tareas',
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskItem extends StatelessWidget {
  const _TaskItem(this.task, {super.key, this.onTap, required this.taskIndex});

  final Task task;
  final int taskIndex;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Consumer<TaskProvider>(
        builder: (_, provider, __) => Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(21)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(children: [
                    Icon(
                      task.done
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(task.title),
                  ]),
                  GestureDetector(
                    onTap: () {
                      print(taskIndex);
                      provider.onTaskDelete(taskIndex);
                    },
                    child: Icon(
                      Icons.delete,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
