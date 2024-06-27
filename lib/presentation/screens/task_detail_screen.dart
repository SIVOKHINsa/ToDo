import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:todo/domain/entities/task.dart';
import 'package:todo/domain/entities/img.dart';
import 'package:todo/presentation/widgets/delete_task_taskdetail_confirmation_dialog.dart';

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
  List<String> _photoUrls = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _photoUrls.addAll(widget.task.imgUrls.map((img) => img.url));
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

  Future<List<String>> _searchPhotosFromFlickr(String query) async {
    String flickrApiKey = '550d14fe53023610649a0dbf839b498e';
    String flickrBaseUrl = 'https://www.flickr.com/services/rest/';
    String method = 'flickr.photos.search';

    String url = '$flickrBaseUrl?method=$method&api_key=$flickrApiKey&text=$query&format=json&nojsoncallback=1';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var photos = data['photos']['photo'];
        return photos.map<String>((photo) {
          var farmId = photo['farm'];
          var serverId = photo['server'];
          var photoId = photo['id'];
          var secret = photo['secret'];
          return 'https://farm$farmId.staticflickr.com/$serverId/${photoId}_$secret.jpg';
        }).toList();
      } else {
        print('Failed to search photos: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error searching photos: $e');
      return [];
    }
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
                  List<String> photos = await _searchPhotosFromFlickr(searchController.text);
                  Navigator.of(context).pop();
                  _showPhotoGridDialog(context, photos);
                },
                child: const Text('Поиск'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPhotoGridDialog(BuildContext context, List<String> photos) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Выберите изображение'),
        content: Container(
          width: double.maxFinite,
          child: photos.isNotEmpty
              ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: photos.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _photoUrls.add(photos[index]);
                  });
                  Navigator.of(context).pop();
                },
                child: Image.network(photos[index], fit: BoxFit.cover),
              );
            },
          )
              : const Center(child: Text('Нет изображений')),
        ),
      ),
    );
  }

  void _removePhoto(int index) {
    setState(() {
      _photoUrls.removeAt(index);
    });
  }

  void _saveChanges() {
    List<Img> updatedImgUrls = _photoUrls.map((url) =>
        Img(id: const Uuid().v4(),
            url: url,
            taskId: widget.task.id)
    ).toList();
    Task updatedTask = Task(
      id: widget.task.id,
      title: _titleController.text,
      description: _descriptionController.text,
      isCompleted: widget.task.isCompleted,
      isFavourite: widget.task.isFavourite,
      categoryId: widget.task.categoryId,
      createdAt: widget.task.createdAt,
      imgUrls: updatedImgUrls,
    );
    widget.onUpdate(updatedTask);
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
              _saveChanges();
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
                    children: _photoUrls.isNotEmpty
                        ? _photoUrls.map((url) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Stack(
                          children: [
                            Image.network(url, width: double.infinity, height: 200, fit: BoxFit.cover),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: GestureDetector(
                                onTap: () => _removePhoto(_photoUrls.indexOf(url)),
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
