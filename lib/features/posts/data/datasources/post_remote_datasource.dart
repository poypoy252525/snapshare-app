import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/post_response_model.dart';

abstract class PostRemoteDataSource {
  Future<PostResponseModel> getPosts({int? limit, int? offset});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio dio;

  PostRemoteDataSourceImpl({required this.dio});

  @override
  Future<PostResponseModel> getPosts({int? limit, int? offset}) async {
    try {
      final response = await dio.get(
        ApiConstants.postsEndpoint,
        queryParameters: {
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
        },
      );

      if (response.statusCode == 200) {
        return PostResponseModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      throw Exception('Failed to load posts: $e');
    }
  }
}
