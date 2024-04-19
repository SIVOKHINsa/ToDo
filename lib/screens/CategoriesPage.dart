import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'TasksPage.dart';
import '../entities/Task.dart';
import '../entities/Catagory.dart';




class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> categories = [];
  Map<String, List<Task>> tasksByCategory = {};
  @override
  void initState() {
    super.initState();
  }

  void addCategory(String categoryName) {
    String categoryId = Uuid().v4();
    Category newCategory = Category(id: categoryId,
      name: categoryName,
      createdAt: DateTime.now(),);
    categories.add(newCategory);
    tasksByCategory[categoryId] = [];
  }

  void deleteCategory(String categoryId) {
    categories.removeWhere((category) => category.id == categoryId);
    tasksByCategory.remove(categoryId);
  }

  void updateCategoryName(Category category, String newName) {
    Category updatedCategory = categories.firstWhere((c) => c.id == category.id);
    if (updatedCategory != null) {
      updatedCategory.name = newName;
    }
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
                  addCategory(categoryName);
                } else {
                  addCategory('Новая категория');
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
                deleteCategory(category.id);
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
        builder: (context) => CategoryDetailsPage(category: category, tasksByCategory: tasksByCategory),
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
                  updateCategoryName(category, updatedName);
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
              categories.isEmpty
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
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final Category category = categories[index];
                return Dismissible(
                  key: Key(category.id),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      _showEditCategoryDialog(category);
                      return false;
                    }
                    if (direction == DismissDirection.endToStart) {
                      _showDeleteConfirmationDialog(category);
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
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade600),
                      borderRadius: BorderRadius.circular(0.0),
                    ),
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