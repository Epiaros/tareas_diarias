import 'package:flutter/material.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';

class TaskForm extends StatefulWidget {
  final Task? task; 
  final Function(Task) onSave;

  const TaskForm({super.key, this.task, required this.onSave});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? _selectedDate;
  String _priority = "Media";

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? "");
    _descriptionController = TextEditingController(text: widget.task?.description ?? "");
    _priority = widget.task?.priority ?? "Media";

    if (widget.task?.date != null) {
      _selectedDate = DateTime.tryParse(widget.task!.date);
    } else {
      _selectedDate = DateTime.now(); // 👈 valor por defecto
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? "Nueva Tarea" : "Editar Tarea"),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: "Título"),
                validator: (value) => value == null || value.isEmpty ? "Ingrese un título" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Descripción"),
                validator: (value) => value == null || value.isEmpty ? "Ingrese una descripción" : null,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? "Sin fecha seleccionada"
                          : "Fecha: ${DateFormat('yyyy-MM-dd').format(_selectedDate!)}",
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  )
                ],
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _priority,
                items: const [
                  DropdownMenuItem(value: "Alta", child: Text("Alta")),
                  DropdownMenuItem(value: "Media", child: Text("Media")),
                  DropdownMenuItem(value: "Baja", child: Text("Baja")),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _priority = value;
                    });
                  }
                },
                decoration: const InputDecoration(labelText: "Prioridad"),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text("Guardar"),
          onPressed: () {
            if (_formKey.currentState!.validate() && _selectedDate != null) {
              widget.onSave(Task(
                id: widget.task?.id,
                title: _titleController.text,
                description: _descriptionController.text,
                date: DateFormat('yyyy-MM-dd').format(_selectedDate!),
                priority: _priority,
              ));
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
