import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/post.dart';
import '../providers/posts_provider.dart';
import '../models/comment.dart';
import 'package:uuid/uuid.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final postsProvider = Provider.of<PostsProvider>(context);
    // Get updated post from provider (not the old one)
    final updatedPost = postsProvider.getPostById(post.id) ?? post;

    final date = DateFormat.yMMMd().add_jm().format(updatedPost.createdAt);
    Uint8List? imageBytes;
    if (updatedPost.imageBase64 != null) {
      imageBytes = base64Decode(updatedPost.imageBase64!);
    }

    final commentC = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text(updatedPost.title)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          if (imageBytes != null)
            Image.memory(imageBytes, height: 200, fit: BoxFit.cover)
          else
            Image.asset(
              'assets/placeholder.jpeg',
              height: 200,
              fit: BoxFit.cover,
            ),
          const SizedBox(height: 12),
          Text(updatedPost.description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: updatedPost.tags
                .map((t) => Chip(label: Text(t)))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up),
                onPressed: () {
                  postsProvider.toggleLike(updatedPost.id);
                },
              ),
              Text('${updatedPost.likes} likes'),
              const Spacer(),
              Text(
                'By ${updatedPost.author} • $date',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
          const Divider(),
          const Text('Comments', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (updatedPost.comments.isEmpty)
            const Text("No comments yet. Be the first!"),
          for (var c in updatedPost.comments)
            ListTile(title: Text(c.author), subtitle: Text(c.text)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentC,
                  decoration: const InputDecoration(hintText: 'Add a comment'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final text = commentC.text.trim();
                  if (text.isEmpty) return;
                  final comment = Comment(
                    id: const Uuid().v4(),
                    author: 'You',
                    text: text,
                  );
                  postsProvider.addComment(updatedPost.id, comment);
                  commentC.clear();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
