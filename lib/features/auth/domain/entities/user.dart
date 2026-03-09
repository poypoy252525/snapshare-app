import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final String? avatar;
  final String? bio;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
    this.avatar,
    this.bio,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    firstName,
    lastName,
    username,
    avatar,
    bio,
  ];
}
