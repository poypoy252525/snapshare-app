import '../entities/post.dart';
import '../entities/post_response.dart';

abstract class PostRepository {
  Future<PostResponse> getPosts({int? limit, int? offset});
  Future<Post> createPost(String content, {dynamic image});
}
