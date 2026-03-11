import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../models/post_model.dart';
import '../models/post_response_model.dart';

abstract class PostRemoteDataSource {
  Future<PostResponseModel> getPosts({int? limit, int? offset});
  Future<PostModel> createPost(String content, {dynamic image});
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio dio;

  PostRemoteDataSourceImpl({required this.dio});

  @override
  Future<PostModel> createPost(String content, {dynamic image}) async {
    try {
      dynamic data;
      
      if (image != null) {
        data = FormData.fromMap({
          'content': content,
          'image': await MultipartFile.fromBytes(
            await image.readAsBytes(),
            filename: image.name,
          ),
        });
      } else {
        data = {'content': content, 'image': null};
      }

      final response = await dio.post(
        ApiConstants.postsEndpoint,
        data: data,
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return PostModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to create post');
      }
    } on DioException catch (e) {
      if (e.response != null && e.response!.statusCode == 400) {
        final data = e.response!.data;
        if (data is Map && data.containsKey('content')) {
          throw ServerException(data['content'][0]);
        }
      }
      throw ServerException(
        e.message ?? 'An error occurred while creating post',
      );
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }

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
