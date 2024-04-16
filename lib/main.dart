import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'data_model.dart';
import 'tasks_details_screen.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CategoriesPage(),
    );
  }
}

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  void initState() {
    super.initState();
  }

  void _showAddCategoryDialog() {
    String categoryName = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Название новой категории:'),
          content: TextField(
            onChanged: (value) {
              categoryName = value;
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
                if (categoryName.trim().isNotEmpty) {
                  // Проверка, что название не пустое после удаления начальных и конечных пробелов
                  dataModel.addCategory(categoryName);
                } else {
                  dataModel.addCategory('Новая категория');
                }
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(Category category) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить категорию'),
          content: Text('Вы уверены, что хотите удалить "${category.name}"?'),
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
                dataModel.deleteCategory(category.id);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToCategoryDetails(Category category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsPage(category),
      ),
    );
  }

  void _showEditCategoryDialog(Category category) {
    String updatedName = category.name;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Редактировать категорию'),
          content: TextField(
            onChanged: (value) {
              updatedName = value;
            },
            controller: TextEditingController(text: category.name),
            decoration: const InputDecoration(labelText: 'Новое название:'),
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
                if (updatedName.isNotEmpty) {
                  dataModel.updateCategoryName(category, updatedName);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 10),
            Icon(Icons.school, size: 30, color: Colors.white),
            SizedBox(width: 10),
            Text(
              'FEFU ToDo app',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              dataModel.categories.isEmpty
                  ? 'Список категорий пуст'
                  : 'Категории:',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: dataModel.categories.length,
              itemBuilder: (context, index) {
                final Category category = dataModel.categories[index];
                return Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade600),
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                  child: Slidable(
                    actionPane: SlidableStrechActionPane(),
                    actionExtentRatio: 0.25,
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Редактировать',
                        color: Colors.yellow,
                        icon: Icons.edit,
                        onTap: () => _showEditCategoryDialog(category),
                      )
                    ],
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        caption: 'Удалить',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => _showDeleteConfirmationDialog(category),
                      )
                    ],
                    child: ListTile(
                      title: Text(category.name),
                      onTap: () {
                        _navigateToCategoryDetails(category);
                      },
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
          _showAddCategoryDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
