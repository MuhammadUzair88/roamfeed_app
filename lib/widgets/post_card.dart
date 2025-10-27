import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/post.dart';
import 'package:intl/intl.dart';
import '../screens/post_detail.dart';
import 'dart:typed_data';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().format(post.createdAt);
    Uint8List? imageBytes;
    if (post.imageBase64 != null) {
      imageBytes = base64Decode(post.imageBase64!);
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PostDetailScreen(post: post)),
        ),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            if (imageBytes != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.memory(
                  imageBytes,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            else
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.asset(
                  'assets/placeholder.jpeg',
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ListTile(
              title: Text(post.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    post.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: post.tags
                        .take(3)
                        .map(
                          (t) => Chip(
                            label: Text(t),
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '$date • ${post.author}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const Spacer(),
                      const Icon(Icons.thumb_up, size: 16),
                      const SizedBox(width: 4),
                      Text('${post.likes}'),
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
            ),
          ],
        ),
      ),
    );
  }
}
