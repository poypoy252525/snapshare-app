import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_flutter_project/features/navigation/presentation/cubit/navigation_cubit.dart';
import 'package:my_flutter_project/core/presentation/widgets/scroll_delta_listener.dart';
import '../bloc/post_bloc.dart';
import '../bloc/post_state.dart';
import 'post_card.dart';

class PostFeed extends StatelessWidget {
  const PostFeed({super.key});

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
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostLoaded) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 0),
              itemCount: state.posts.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey.withValues(alpha: 0.2),
                thickness: 0.5,
                height: 1,
              ),
              itemBuilder: (context, index) {
                return PostCard(post: state.posts[index]);
              },
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
                      // Logic for retry could go here if event is accessible
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
