import 'package:equatable/equatable.dart';
import '../../domain/entities/post.dart';

abstract class PostState extends Equatable {
  const PostState();

  @override
  List<Object?> get props => [];
}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;
  final bool isLoadingMore;

  const PostLoaded({
    required this.posts,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
  });

  PostLoaded copyWith({
    List<Post>? posts,
    bool? hasReachedMax,
    bool? isLoadingMore,
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [posts, hasReachedMax, isLoadingMore];
}

class PostError extends PostState {
  final String message;

  const PostError({required this.message});

  @override
  List<Object?> get props => [message];
}

class PostCreating extends PostState {}

class PostCreated extends PostState {
  final Post post;

  const PostCreated({required this.post});

  @override
  List<Object?> get props => [post];
}
