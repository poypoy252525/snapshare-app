import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/posts/presentation/bloc/post_bloc.dart';
import '../features/posts/presentation/bloc/post_event.dart';
import '../features/posts/presentation/widgets/post_feed.dart';
import '../features/posts/presentation/widgets/snapshare_top_bar.dart';
import '../injection_container.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PostBloc>()..add(GetPostsEvent()),
      child: Scaffold(appBar: const ThreadsTopBar(), body: const PostFeed()),
    );
  }
}
