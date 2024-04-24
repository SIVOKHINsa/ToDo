import 'package:flutter/material.dart';
import './screens/CategoriesPage.dart';

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

