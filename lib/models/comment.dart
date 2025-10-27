import 'package:hive/hive.dart';
part 'comment.g.dart';

@HiveType(typeId: 1)
class Comment extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String author;

  @HiveField(2)
  String text;

  Comment({
    required this.id,
    required this.author,
    required this.text,
  });
}
