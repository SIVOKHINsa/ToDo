import 'package:flutter/material.dart';
import 'data_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CategoryDetailsPage extends StatefulWidget {
  final Category category;

  CategoryDetailsPage(this.category);

  @override
  _CategoryDetailsPageState createState() => _CategoryDetailsPageState();
}

class _CategoryDetailsPageState extends State<CategoryDetailsPage> {
  String filter = 'Все'; // По умолчанию показываем все задачи

  void _filterTasks(String newFilter) {
    setState(() {
      filter = newFilter;
    });
  }

  @override
  void initState() {
    super.initState();
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
              Checkbox(
                value: updatedIsCompleted,
                onChanged: (value) {
                  updatedIsCompleted = value ?? false;
                },
              ),
              Checkbox(
                value: updatedIsFavourite,
                onChanged: (value) {
                  updatedIsFavourite = value ?? false;
                },
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
                  dataModel.updateTask(task, updatedTitle, updatedDescription,
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
                dataModel.deleteTask(task.categoryId, task.id);
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
                  dataModel.addTaskToCategory(widget.category.id, taskTitle);
                } else {
                  dataModel.addTaskToCategory(
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
        List<Task>.from(dataModel.tasksByCategory[widget.category.id] ?? []);

    if (filter == 'Выполненные') {
      tasks = tasks.where((task) => task.isCompleted).toList();
    } else if (filter == 'Не выполненные') {
      tasks = tasks.where((task) => !task.isCompleted).toList();
    } else if (filter == 'Избранные') {
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
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu, color: Colors.white),
            onSelected: _filterTasks,
            itemBuilder: (BuildContext context) {
              return ['Все', 'Выполненные', 'Не выполненные', 'Избранные']
                  .map((String value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
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
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Редактировать',
                      color: Colors.yellow,
                      icon: Icons.edit,
                      onTap: () => _showEditTaskDialog(task),
                    )
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Удалить',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () => _deleteTask(task),
                    )
                  ],
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
}
