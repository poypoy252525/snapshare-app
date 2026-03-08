import '../../domain/entities/post.dart';
import 'author_model.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    super.title,
    required super.content,
    super.image,
    required super.createdAt,
    required super.updatedAt,
    required super.author,
    required super.authorUsername,
    required super.authorId,
    required super.commentsCount,
    required super.likesCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      image: json['image'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      author: AuthorModel.fromJson(json['author']),
      authorUsername: json['author_username'],
      authorId: json['author_id'],
      commentsCount: json['comments_count'] ?? 0,
      likesCount: json['likes_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'author': (author as AuthorModel).toJson(),
      'author_username': authorUsername,
      'author_id': authorId,
      'comments_count': commentsCount,
      'likes_count': likesCount,
    };
  }
}
