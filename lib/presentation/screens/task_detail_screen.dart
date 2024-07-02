import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo/domain/entities/task.dart';
import 'package:todo/domain/entities/img.dart';
import 'package:todo/presentation/widgets/delete_task_taskdetail_confirmation_dialog.dart';
import 'package:todo/presentation/cubits/task_cubit.dart';
import 'package:todo/presentation/cubits/task_state.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onUpdate;
  final Function(Task) onDelete;

  const TaskDetailScreen({
    Key? key,
    required this.task,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: 'Удалить задачу',
        content: 'Вы действительно хотите удалить эту задачу?',
        onDelete: () {
          widget.onDelete(widget.task);
          Navigator.pop(context);
        },
      ),
    );
  }


  void _showPhotoSelectionDialog(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Выберите изображение'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Тема для поиска изображений',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  await context.read<TaskCubit>().searchPhotosFromFlickr(searchController.text);
                  Navigator.of(context).pop();
                  _showPhotoGridDialog(context);
                },
                child: const Text('Поиск'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPhotoGridDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<TaskCubit, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              return AlertDialog(
                title: const Text('Выберите изображение'),
                content: Container(
                  width: double.maxFinite,
                  child: state.photoUrls.isNotEmpty
                      ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemCount: state.photoUrls.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.read<TaskCubit>().removePhoto(index);
                          Navigator.of(context).pop();
                        },
                        child: Image.network(state.photoUrls[index]),
                      );
                    },
                  )
                      : const Text('Изображений не найдено.'),
                ),
              );
            } else if (state is TaskError) {
              return AlertDialog(
                title: const Text('Ошибка'),
                content: Text(state.message),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Закрыть'),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
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
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              _showDeleteConfirmationDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.save, color: Colors.white),
            onPressed: () {
              context.read<TaskCubit>().saveChanges(widget.task);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.blue,
              padding: const EdgeInsets.all(16.0),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('Дата создания:   '),
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
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: IconButton(
                            icon: const Icon(Icons.attach_file, color: Colors.white),
                            onPressed: () {
                              _showPhotoSelectionDialog(context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.task.imgUrls.isNotEmpty
                        ? widget.task.imgUrls.map((url) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Stack(
                          children: [
                            Image.network(url as String, width: double.infinity, height: 200, fit: BoxFit.cover),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: GestureDetector(
                                onTap: () => context.read<TaskCubit>().removePhoto(widget.task.imgUrls.indexOf(url)),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  color: Colors.red,
                                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList()
                        : const [Text('Нет выбранных фотографий')],
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
