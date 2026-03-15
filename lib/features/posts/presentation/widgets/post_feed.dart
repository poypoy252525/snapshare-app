import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshare/features/navigation/presentation/cubit/navigation_cubit.dart';
import 'package:snapshare/core/presentation/widgets/scroll_delta_listener.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';
import 'post_skeleton.dart';
import 'post_card.dart';

class PostFeed extends StatefulWidget {
  const PostFeed({super.key});

  @override
  State<PostFeed> createState() => _PostFeedState();
}

class _PostFeedState extends State<PostFeed> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PostBloc>().add(LoadMorePostsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return ScrollDeltaListener(
      onScrollDelta: (delta) {
        context.read<NavigationCubit>().updateOffset(delta, 60.0);
      },
      onScrollEnd: () {
        context.read<NavigationCubit>().snap();
      },
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostLoading) {
            return ListView.separated(
              itemCount: 5,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) => const PostSkeleton(),
            );
          } else if (state is PostLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<PostBloc>().add(GetPostsEvent());
                await context.read<PostBloc>().stream.firstWhere(
                  (s) => s is! PostLoaded,
                );
              },
              child: ListView.separated(
                controller: _scrollController,
                cacheExtent: 1000,
                padding: const EdgeInsets.symmetric(vertical: 0),
                itemCount:
                    state.hasReachedMax
                        ? state.posts.length
                        : state.posts.length + 1,
                separatorBuilder:
                    (context, index) => Divider(
                      color: Colors.grey.withValues(alpha: 0.2),
                      thickness: 0.5,
                      height: 1,
                    ),
                itemBuilder: (context, index) {
                  if (index >= state.posts.length) {
                    return const PostSkeleton();
                  }
                  return PostCard(post: state.posts[index]);
                },
              ),
            );
          } else if (state is PostError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PostBloc>().add(GetPostsEvent());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('Start exploring posts!'));
        },
      ),
    );
  }
}
