import 'post_model.dart';

class PostResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<PostModel> results;

  const PostResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PostResponseModel.fromJson(Map<String, dynamic> json) {
    return PostResponseModel(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((post) => PostModel.fromJson(post))
          .toList(),
    );
  }
}
