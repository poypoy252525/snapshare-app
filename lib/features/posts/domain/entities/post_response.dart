import 'post.dart';

class PostResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Post> results;

  const PostResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });
}
