import 'package:equatable/equatable.dart';

class Author extends Equatable {
  final String id;
  final String user;
  final String? bio;
  final String? avatar;

  const Author({required this.id, required this.user, this.bio, this.avatar});

  @override
  List<Object?> get props => [id, user, bio, avatar];
}
