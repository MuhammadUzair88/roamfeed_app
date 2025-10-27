import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/posts_provider.dart';
import '../widgets/post_card.dart';
import 'add_post.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';
  final _tagController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final postsProv = Provider.of<PostsProvider>(context);
    final posts = postsProv.search(_query,
        tags: _tagController.text.isEmpty
            ? null
            : _tagController.text.split(',').map((s) => s.trim()).toList());
    return Scaffold(
      appBar: AppBar(
        title: const Text('RoamFeed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(86),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search posts, places, tips...'),
                  onChanged: (v) => setState(()=>_query=v),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _tagController,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.label), hintText: 'Filter by tags (comma separated)'),
                  onChanged: (v) => setState((){}),
                )
              ],
            ),
          ),
        ),
      ),
      body: posts.isEmpty ? const Center(child: Text('No posts yet — share your adventure!')) : ListView.builder(
        padding: const EdgeInsets.only(top: 8),
        itemCount: posts.length,
        itemBuilder: (_, i) => PostCard(post: posts[i]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPostScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }
}
