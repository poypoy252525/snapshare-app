import '../entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<Post> createPost(String content, {dynamic image});
}
