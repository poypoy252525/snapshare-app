import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class GetPostsEvent extends PostEvent {}

class CreatePostEvent extends PostEvent {
  final String content;
  final dynamic image;

  const CreatePostEvent({required this.content, this.image});

  @override
  List<Object?> get props => [content, image];
}

