import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_posts.dart';
import '../../domain/usecases/create_post.dart';

import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;
  final CreatePost createPost;
  static const _limit = 10;

  PostBloc({required this.getPosts, required this.createPost})
    : super(PostInitial()) {
    on<GetPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        final response = await getPosts(limit: _limit, offset: 0);
        emit(
          PostLoaded(
            posts: response.results,
            hasReachedMax: response.next == null,
          ),
        );
      } catch (e) {
        emit(
          const PostError(message: 'Failed to fetch posts. Please try again.'),
        );
      }
    });

    on<LoadMorePostsEvent>((event, emit) async {
      final currentState = state;
      if (currentState is PostLoaded &&
          !currentState.hasReachedMax &&
          !currentState.isLoadingMore) {
        emit(currentState.copyWith(isLoadingMore: true));
        try {
          final response = await getPosts(
            limit: _limit,
            offset: currentState.posts.length,
          );
          emit(
            response.results.isEmpty
                ? currentState.copyWith(hasReachedMax: true, isLoadingMore: false)
                : currentState.copyWith(
                  posts: List.of(currentState.posts)..addAll(response.results),
                  hasReachedMax: response.next == null,
                  isLoadingMore: false,
                ),
          );
        } catch (_) {
          emit(currentState.copyWith(isLoadingMore: false));
        }
      }
    });

    on<CreatePostEvent>((event, emit) async {
      emit(PostCreating());
      try {
        final post = await createPost(event.content, image: event.image);
        emit(PostCreated(post: post));
      } catch (e) {
        emit(PostError(message: e.toString()));
      }
    });
  }
}
