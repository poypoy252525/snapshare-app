import 'package:flutter/material.dart';
import '../features/posts/presentation/widgets/post_feed.dart';
import '../features/posts/presentation/widgets/snapshare_top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: ThreadsTopBar(), body: PostFeed());
  }
}
