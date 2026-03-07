import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Avatar with + button
          Column(
            children: [
              Stack(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                    child: ClipOval(
                      child: Image.network(
                        post.userImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Text(
                            post.username[0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: textColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode ? Colors.black : Colors.white,
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 10,
                        color: isDarkMode ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Right Column: Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Username, Verification, Time, Menu
                Row(
                  children: [
                    Text(
                      post.username,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    if (post.isVerified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, size: 14, color: Colors.blue),
                    ],
                    const Spacer(),
                    Text(
                      _formatTime(post.createdAt),
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.more_horiz, color: Colors.grey, size: 18),
                  ],
                ),
                const SizedBox(height: 4),
                // Post Content
                Text(
                  post.content,
                  style: TextStyle(fontSize: 14, color: textColor, height: 1.3),
                ),
                if (post.imageUrl != null) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      post.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                // Action Icons
                Row(
                  children: [
                    _ActionButton(icon: CupertinoIcons.heart, onTap: () {}),
                    const SizedBox(width: 16),
                    _ActionButton(
                      icon: CupertinoIcons.chat_bubble,
                      onTap: () {},
                    ),
                    const SizedBox(width: 16),
                    _ActionButton(
                      icon: CupertinoIcons.arrow_2_squarepath,
                      onTap: () {},
                    ),
                    const SizedBox(width: 16),
                    _ActionButton(
                      icon: CupertinoIcons.paperplane,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Stats
                Text(
                  '${post.commentsCount} replies · ${post.likesCount} likes',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    if (difference.inMinutes < 60) return '${difference.inMinutes}m';
    if (difference.inHours < 24) return '${difference.inHours}h';
    return '${difference.inDays}d';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        icon,
        size: 20,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black,
      ),
    );
  }
}
