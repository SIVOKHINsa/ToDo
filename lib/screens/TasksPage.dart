import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../entities/Task.dart';
import '../entities/Catagory.dart';

enum Filter {
  all,
  completed,
  notCompleted,
  favourite,
}

class CategoryDetailsPage extends StatefulWidget {
  final Category category;
  final Map<String, List<Task>> tasksByCategory;

  CategoryDetailsPage({required this.category, required this.tasksByCategory});

  @override
  _CategoryDetailsPageState createState() => _CategoryDetailsPageState(tasksByCategory: tasksByCategory);
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  Filter filter = Filter.all;

  final Map<String, List<Task>> tasksByCategory;

  _CategoryDetailsPageState({required this.tasksByCategory});

  void _filterTasks(Filter newFilter) {
    setState(() {
      filter = newFilter;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void deleteTask(String categoryId, String taskId) {
    tasksByCategory[categoryId]?.removeWhere((task) => task.id == taskId);
  }

  void addTaskToCategory(String categoryId, String taskTitle) {
    Task newTask = Task(
      id: Uuid().v4(),
      title: taskTitle,
      description: '',
      createdAt: DateTime.now(),
      categoryId: categoryId,
    );

    setState(() {
      tasksByCategory[categoryId]?.add(newTask);
    });
  }

  void updateTask(Task task, String newTitle, String newDescription, bool newIsCompleted, bool newIsFavourite) {
    Task? updatedTask = tasksByCategory[task.categoryId]?.firstWhere((t) => t.id == task.id);
    if (updatedTask != null) {
      updatedTask.title = newTitle;
      updatedTask.description = newDescription;
      updatedTask.isCompleted = newIsCompleted;
      updatedTask.isFavourite = newIsFavourite;
    }
  }

  void _showEditTaskDialog(Task task) {
    String updatedTitle = task.title;
    String updatedDescription = task.description;
    bool updatedIsCompleted = task.isCompleted;
    bool updatedIsFavourite = task.isFavourite;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактировать задачу'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  updatedTitle = value;
                },
                controller: TextEditingController(text: task.title),
                decoration: const InputDecoration(labelText: 'Новое название:'),
              ),
              TextField(
                onChanged: (value) {
                  updatedDescription = value;
                },
                controller: TextEditingController(text: task.description),
                decoration: const InputDecoration(labelText: 'Новое описание:'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                if (updatedTitle.isNotEmpty) {
                  updateTask(task, updatedTitle, updatedDescription,
                      updatedIsCompleted, updatedIsFavourite);
                  Navigator.of(context).pop();
                  setState(() {});
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить задачу?'),
          content: const Text('Вы уверены, что хотите удалить эту задачу?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Удалить'),
              onPressed: () {
                deleteTask(task.categoryId, task.id);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddTaskDialog() {
    String taskTitle = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Название новой задачи:'),
          content: TextField(
            onChanged: (value) {
              taskTitle = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Отмена'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Сохранить'),
              onPressed: () {
                if (taskTitle.trim().isNotEmpty) {
                  addTaskToCategory(widget.category.id, taskTitle);
                } else {
                  addTaskToCategory(
                      widget.category.id, 'Новая задача');
                }
                setState(() {});
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
    List<Task> tasks =
    List<Task>.from(tasksByCategory[widget.category.id] ?? []);

    if (filter == Filter.completed) {
      tasks = tasks.where((task) => task.isCompleted).toList();
    } else if (filter == Filter.notCompleted) {
      tasks = tasks.where((task) => !task.isCompleted).toList();
    } else if (filter == Filter.favourite) {
      tasks = tasks.where((task) => task.isFavourite).toList();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.name,
          style: const TextStyle(color: Colors.white),
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
          PopupMenuButton<Filter>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: _filterTasks,
            itemBuilder: (BuildContext context) {
              return Filter.values.map((Filter value) {
                return PopupMenuItem<Filter>(
                  value: value,
                  child: Text(_getFilterText(value)),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              tasks.isEmpty ? 'Список задач пуст' : 'Задачи:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final Task task = tasks[index];
                return Dismissible(
                  key: Key(task.id),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      _showEditTaskDialog(task);
                      return false;
                    }
                    if (direction == DismissDirection.endToStart) {
                      _deleteTask(task);
                      return false;
                    }
                    return true;
                  },
                  background: Container(
                    color: Colors.yellow,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20.0),
                    child: Icon(Icons.edit, color: Colors.white),
                  ),
                  secondaryBackground: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  direction: DismissDirection.horizontal,
                  child: ListTile(
                    leading: Checkbox(
                      value: task.isCompleted,
                      onChanged: (value) {
                        setState(() {
                          task.isCompleted = value ?? false;
                        });
                      },
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              task.isFavourite = !task.isFavourite;
                            });
                          },
                          child: Icon(
                            task.isFavourite ? Icons.star : Icons.star_border,
                            color:
                            task.isFavourite ? Colors.amber : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  String _getFilterText(Filter filter) {
    switch(filter) {
      case Filter.all:
        return 'Все';
      case Filter.completed:
        return 'Выполненные';
      case Filter.notCompleted:
        return 'Не выполненные';
      case Filter.favourite:
        return 'Избранные';
      default:
        return '';
    }
  }
}
