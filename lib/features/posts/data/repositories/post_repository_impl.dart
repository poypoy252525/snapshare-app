import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../models/post_model.dart';

class PostRepositoryImpl implements PostRepository {
  @override
  Future<List<Post>> getPosts() async {
    // Simulating API delay
    await Future.delayed(const Duration(milliseconds: 800));

    return [
      PostModel(
        id: '1',
        userId: 'u1',
        username: 'SnapShare',
        userImageUrl: 'https://i.pravatar.cc/150?u=snapshare',
        content:
            'Welcome to SnapShare! The cleanest way to share your moments. 🚀',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        isVerified: true,
        likesCount: 1240,
        commentsCount: 88,
        repostsCount: 45,
      ),
      PostModel(
        id: '2',
        userId: 'u2',
        username: 'mtchazlnut',
        userImageUrl: 'https://avatar.iran.liara.run/public/job/designer/male',
        content: 'mas nakakapagod pa sa school kesa ojt 🙄',
        createdAt: DateTime.now().subtract(const Duration(hours: 21)),
        isVerified: false,
        likesCount: 89,
        commentsCount: 12,
        repostsCount: 5,
      ),
      PostModel(
        id: '3',
        userId: 'u3',
        username: 'flutter_dev',
        userImageUrl:
            'https://avatar.iran.liara.run/public/job/operator/female',
        content:
            "Clean architecture makes Flutter apps so much more maintainable. What's your favorite design pattern?",
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        isVerified: true,
        likesCount: 816,
        commentsCount: 223,
        repostsCount: 45,
      ),
      PostModel(
        id: '4',
        userId: 'u4',
        username: 'poypoy25',
        userImageUrl: 'https://github.com/shadcn.png',
        content:
            "Clean architecture makes Flutter apps so much more maintainable. What's your favorite design pattern?",
        createdAt: DateTime.now().subtract(const Duration(hours: 18)),
        isVerified: true,
        likesCount: 816,
        commentsCount: 223,
        repostsCount: 45,
      ),
      PostModel(
        id: '5',
        userId: 'u5',
        username: 'carl',
        userImageUrl: 'https://github.com/shadcn.png',
        content: "Hello there!",
        createdAt: DateTime.now().subtract(const Duration(hours: 22)),
        isVerified: false,
        likesCount: 0,
        commentsCount: 0,
        repostsCount: 0,
      ),
      PostModel(
        id: '6',
        userId: 'u5',
        username: 'carl',
        userImageUrl: 'https://github.com/shadcn.png',
        content: "Hello there!",
        createdAt: DateTime.now().subtract(const Duration(hours: 22)),
        isVerified: false,
        likesCount: 0,
        commentsCount: 0,
        repostsCount: 0,
      ),
      PostModel(
        id: '7',
        userId: 'u5',
        username: 'carl',
        userImageUrl: 'https://github.com/shadcn.png',
        content: "Hello there!",
        createdAt: DateTime.now().subtract(const Duration(hours: 22)),
        isVerified: false,
        likesCount: 0,
        commentsCount: 0,
        repostsCount: 0,
      ),
    ];
  }
}
