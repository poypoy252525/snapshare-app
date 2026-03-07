import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String userId;
  final String username;
  final String userImageUrl;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isVerified;
  final int likesCount;
  final int commentsCount;
  final int repostsCount;

  const Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.userImageUrl,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.isVerified = false,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.repostsCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    username,
    userImageUrl,
    content,
    imageUrl,
    createdAt,
    isVerified,
    likesCount,
    commentsCount,
    repostsCount,
  ];
}
