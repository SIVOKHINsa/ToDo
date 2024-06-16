import 'package:flutter/material.dart';
import 'package:todo/domain/entities/category.dart';
import 'package:todo/presentation/screens/task_screen.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final Function() onDismissed;
  final Function(String) onEdit;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.onDismissed,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TasksScreen(category: category),
          ),
        );
      },
      child: Dismissible(
        key: Key(category.name),
        direction: DismissDirection.horizontal,
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                final TextEditingController nameController =
                TextEditingController(text: category.name);
                return AlertDialog(
                  title: Text('Редактировать категорию'),
                  content: TextField(
                    onChanged: (newValue) {
                      onEdit(newValue);
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: 'Новое название категории',
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Сохранить'),
                    ),
                  ],
                );
              },
            );
          } else {
            return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Удалить категорию'),
                  content: Text(
                      'Вы уверены, что хотите удалить категорию "${category.name}"?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: const Text('Удалить'),
                    ),
                  ],
                );
              },
            );
          }
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            onDismissed();
          }
        },
        background: Container(
          color: Colors.orange,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
        ),
        secondaryBackground: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(left: 20.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.chrome_reader_mode),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      category.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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