import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../entities/Task.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  final Function(String, String) onDeleteTask;
  final Function(String, List<Task>) onUpdateTask;
  final List<Task> taskList;// Add onUpdateTask function

  TaskDetailsPage({
    required this.task,
    required this.onDeleteTask,
    required this.onUpdateTask,
    required this.taskList,
  });


  @override
  _TaskDetailsPageState createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Удалить задачу'),
          content: Text('Вы действительно хотите удалить эту задачу?'),
          actions: <Widget>[
            TextButton(
              child: Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Удалить'),
              onPressed: () {
                widget.onDeleteTask(widget.task.categoryId, widget.task.id);
                widget.onUpdateTask(widget.task.categoryId, widget.taskList);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              widget.task.title = value;
            });
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Дата создания:   '),
                      Text(DateFormat('dd.MM.yyyy').format(widget.task.createdAt)),
                      const SizedBox(width: 8),
                      Text(DateFormat.Hm().format(widget.task.createdAt)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      labelText: "Описание",
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                    ),
                    onChanged: (value) {
                      widget.task.description = value;
                    },
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