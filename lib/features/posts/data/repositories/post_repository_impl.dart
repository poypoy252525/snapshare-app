import '../../domain/entities/post.dart';
import '../../domain/entities/post_response.dart';
import '../../domain/repositories/post_repository.dart';
import '../datasources/post_remote_datasource.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<PostResponse> getPosts({int? limit, int? offset}) async {
    final response = await remoteDataSource.getPosts(limit: limit, offset: offset);
    return PostResponse(
      count: response.count,
      next: response.next,
      previous: response.previous,
      results: response.results,
    );
  }

  @override
  Future<Post> createPost(String content, {dynamic image}) async {
    return await remoteDataSource.createPost(content, image: image);
  }
}
