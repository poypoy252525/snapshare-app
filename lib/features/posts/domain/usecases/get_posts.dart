import '../entities/post_response.dart';
import '../repositories/post_repository.dart';

class GetPosts {
  final PostRepository repository;

  GetPosts(this.repository);

  Future<PostResponse> call({int? limit, int? offset}) async {
    return await repository.getPosts(limit: limit, offset: offset);
  }
}
