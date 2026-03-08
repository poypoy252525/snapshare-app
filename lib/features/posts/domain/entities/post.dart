import 'package:equatable/equatable.dart';
import 'author.dart';

class Post extends Equatable {
  final String id;
  final String? title;
  final String content;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Author author;
  final String authorUsername;
  final String authorId;
  final int commentsCount;
  final int likesCount;

  const Post({
    required this.id,
    this.title,
    required this.content,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.author,
    required this.authorUsername,
    required this.authorId,
    required this.commentsCount,
    required this.likesCount,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    image,
    createdAt,
    updatedAt,
    author,
    authorUsername,
    authorId,
    commentsCount,
    likesCount,
  ];
}
