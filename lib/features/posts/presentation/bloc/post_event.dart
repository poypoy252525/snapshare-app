import 'package:equatable/equatable.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object?> get props => [];
}

class GetPostsEvent extends PostEvent {}

class CreatePostEvent extends PostEvent {
  final String content;

  const CreatePostEvent({required this.content});

  @override
  List<Object?> get props => [content];
}
