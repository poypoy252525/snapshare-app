import '../entities/post.dart';
import '../repositories/post_repository.dart';

class CreatePost {
  final PostRepository repository;

  CreatePost(this.repository);

  Future<Post> call(String content) async {
    return await repository.createPost(content);
  }
}
