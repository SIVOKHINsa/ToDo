import 'package:todo/domain/entities/img.dart';

class Task {
  final String id;
  String title;
  String? description;
  bool isCompleted;
  bool isFavourite;
  final String categoryId;
  final DateTime createdAt;
  List<Img> imgUrls;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    this.isFavourite = false,
    required this.categoryId,
    required this.createdAt,
    List<Img>? imgUrls,
  }) : imgUrls = imgUrls ?? [];

  void update({required String title, String? description, List<Img>? imgUrls}) {
    this.title = title;
    this.description = description;
    if (imgUrls != null) {
      this.imgUrls.clear();
      this.imgUrls.addAll(imgUrls);
    }
  }
}
