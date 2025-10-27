import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/post.dart';
import '../models/comment.dart';
import 'package:uuid/uuid.dart';

class PostsProvider extends ChangeNotifier {
  final Box<Post> _box = Hive.box<Post>('postsBox');
  final _meta = Hive.box('metaBox');

  PostsProvider() {
    _seedIfNeeded();
  }

  List<Post> get posts => _box.values.toList().reversed.toList();

  // ✅ Get single post by id
  Post? getPostById(String postId) {
    return _box.get(postId);
  }

  void _seedIfNeeded() {
    final seeded = _meta.get('seeded', defaultValue: false);
    if (!seeded) {
      final now = DateTime.now();
      final p1 = Post(
        id: const Uuid().v4(),
        title: 'Hidden Beach near Porto',
        description:
            'A tiny cove with turquoise water. Bring water and snacks.',
        tags: ['beach', 'portugal', 'hidden'],
        likes: 12,
        author: 'Lena',
        createdAt: now.subtract(const Duration(days: 10)),
        comments: [
          Comment(
            id: const Uuid().v4(),
            author: 'Mike',
            text: 'Stunning photos!',
          ),
        ],
      );
      final p2 = Post(
        id: const Uuid().v4(),
        title: 'Night Market Eats',
        description:
            'Best street food on 3rd lane — don\'t miss the dumplings.',
        tags: ['food', 'nightmarket', 'local'],
        likes: 34,
        author: 'Ravi',
        createdAt: now.subtract(const Duration(days: 4)),
      );
      _box.put(p1.id, p1);
      _box.put(p2.id, p2);
      _meta.put('seeded', true);
    }
  }

  void addPost(Post post) {
    _box.put(post.id, post);
    notifyListeners();
  }

  // ✅ Single update call (no duplicates)
  void addComment(String postId, Comment comment) {
    final post = _box.get(postId);
    if (post == null) return;
    post.comments = List.from(post.comments)..add(comment);
    post.save();
    notifyListeners();
  }

  // ✅ Toggle like correctly (no double increment)
  void toggleLike(String postId) {
    final post = _box.get(postId);
    if (post == null) return;
    post.likes++;
    post.save();
    notifyListeners();
  }

  List<Post> search(String q, {List<String>? tags}) {
    final lower = q.toLowerCase();
    return posts.where((p) {
      final matchesQ =
          q.isEmpty ||
          p.title.toLowerCase().contains(lower) ||
          p.description.toLowerCase().contains(lower);
      final matchesTags =
          tags == null || tags.isEmpty || tags.any((t) => p.tags.contains(t));
      return matchesQ && matchesTags;
    }).toList();
  }
}
