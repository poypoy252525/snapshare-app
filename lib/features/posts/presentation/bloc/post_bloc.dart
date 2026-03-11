import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_posts.dart';
import '../../domain/usecases/create_post.dart';

import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;
  final CreatePost createPost;

  PostBloc({required this.getPosts, required this.createPost})
    : super(PostInitial()) {
    on<GetPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        final posts = await getPosts();
        emit(PostLoaded(posts: posts));
      } catch (e) {
        emit(
          const PostError(message: 'Failed to fetch posts. Please try again.'),
        );
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
