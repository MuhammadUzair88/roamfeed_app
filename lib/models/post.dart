import 'package:hive/hive.dart';
import 'comment.dart';
import 'dart:convert';
part 'post.g.dart';

@HiveType(typeId: 0)
class Post extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  // Base64 image string
  @HiveField(3)
  String? imageBase64;

  @HiveField(4)
  List<String> tags;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  List<Comment> comments;

  @HiveField(7)
  int likes;

  @HiveField(8)
  String author;

  Post({
    required this.id,
    required this.title,
    required this.description,
    this.imageBase64,
    this.tags = const [],
    DateTime? createdAt,
    this.comments = const [],
    this.likes = 0,
    this.author = 'Anonymous',
  }) : createdAt = createdAt ?? DateTime.now();
}
