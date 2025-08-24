import 'package:flutter/material.dart';
import '../controllers/main_controller.dart';
import '../models/task.dart';
import 'create_button.dart';
import 'edit_delete_button.dart';
import 'task_form.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final MainController controller = MainController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final data = await controller.getTasks();
    setState(() {
      tasks = data;
    });
  }

  void _showForm({Task? task}) {
    showDialog(
      context: context,
      builder: (_) => TaskForm(
        task: task,
        onSave: (newTask) async {
          if (newTask.id == null) {
            await controller.addTask(newTask);
          } else {
            await controller.updateTask(newTask);
          }
          _loadTasks();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("CRUD con SQLite (MVC) - Tareas Diarias")),
      body: tasks.isEmpty
          ? const Center(child: Text("No hay tareas aún"))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text("${task.description}\nFecha: ${task.date} | Prioridad: ${task.priority}"),
                  isThreeLine: true,
                  trailing: EditDeleteButton(
                    onEdit: () => _showForm(task: task),
                    onDelete: () async {
                      await controller.deleteTask(task.id!);
                      _loadTasks();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: CreateButton(
        onPressed: () => _showForm(),
      ),
    );
  }
}
