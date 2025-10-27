import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'models/post.dart';
import 'models/comment.dart';
import 'providers/posts_provider.dart';
import 'screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PostAdapter());
  Hive.registerAdapter(CommentAdapter());
  await Hive.openBox<Post>('postsBox');
  await Hive.openBox('metaBox');
  runApp(const RoamFeedApp());
}

class RoamFeedApp extends StatelessWidget {
  const RoamFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PostsProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RoamFeed',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          primarySwatch: Colors.deepPurple,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
