import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required super.id,
    required super.userId,
    required super.username,
    required super.userImageUrl,
    required super.content,
    super.imageUrl,
    required super.createdAt,
    super.isVerified,
    super.likesCount,
    super.commentsCount,
    super.repostsCount,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      userId: json['userId'],
      username: json['username'],
      userImageUrl: json['userImageUrl'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      isVerified: json['isVerified'] ?? false,
      likesCount: json['likesCount'] ?? 0,
      commentsCount: json['commentsCount'] ?? 0,
      repostsCount: json['repostsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'username': username,
      'userImageUrl': userImageUrl,
      'content': content,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
      'isVerified': isVerified,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'repostsCount': repostsCount,
    };
  }
}
