import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_posts.dart';
import 'post_event.dart';
import 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPosts getPosts;

  PostBloc({required this.getPosts}) : super(PostInitial()) {
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
  }
}
