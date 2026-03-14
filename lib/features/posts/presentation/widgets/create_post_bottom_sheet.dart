import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshare/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:snapshare/features/posts/presentation/bloc/post_bloc.dart';
import 'package:snapshare/features/posts/presentation/bloc/post_event.dart';
import 'package:snapshare/features/posts/presentation/bloc/post_state.dart';
import 'package:snapshare/core/presentation/widgets/snapshare_image.dart';

class CreatePostBottomSheet extends StatefulWidget {
  const CreatePostBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreatePostBottomSheet(),
    );
  }

  @override
  State<CreatePostBottomSheet> createState() => _CreatePostBottomSheetState();
}

class _CreatePostBottomSheetState extends State<CreatePostBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  XFile? _selectedImage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color bgColor = isDarkMode ? const Color(0xFF101010) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color secondaryTextColor = isDarkMode
        ? Colors.grey[500]!
        : Colors.grey[600]!;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        String username = 'user';
        String? avatarUrl;

        if (authState is Authenticated) {
          username = authState.user.username;
          avatarUrl = authState.user.avatar;
        }

        return BlocListener<PostBloc, PostState>(
          listener: (context, state) {
            if (state is PostCreated) {
              Navigator.pop(context);
              context.read<PostBloc>().add(GetPostsEvent());
            } else if (state is PostError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Container(
            height:
                MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: textColor, fontSize: 16),
                        ),
                      ),
                      Text(
                        'New post',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(CupertinoIcons.square_list, size: 22),
                          SizedBox(width: 16),
                          Icon(CupertinoIcons.ellipsis_circle, size: 22),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 0.5),

                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // User Avatar & Line
                          Column(
                            children: [
                              if (avatarUrl != null)
                                SnapShareImage(
                                  imageUrl: avatarUrl,
                                  width: 36,
                                  height: 36,
                                  shape: SnapShareImageShape.circle,
                                )
                              else
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  child: Text(
                                    username.isNotEmpty
                                        ? username[0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      color: secondaryTextColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              Expanded(
                                child: Container(
                                  width: 2,
                                  color: isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.grey[300],
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4,
                                  ),
                                ),
                              ),
                              if (avatarUrl != null)
                                SnapShareImage(
                                  imageUrl: avatarUrl,
                                  width: 20,
                                  height: 20,
                                  shape: SnapShareImageShape.circle,
                                )
                              else
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: isDarkMode
                                      ? Colors.grey[800]
                                      : Colors.grey[200],
                                  child: Text(
                                    username.isNotEmpty
                                        ? username[0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      color: secondaryTextColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 12),

                          // Input Area
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      username,
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      CupertinoIcons.chevron_right,
                                      size: 12,
                                      color: secondaryTextColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Add a topic',
                                      style: TextStyle(
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ),
                                TextField(
                                  controller: _controller,
                                  maxLines: null,
                                  autofocus: true,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "What's new?",
                                    hintStyle: TextStyle(
                                      color: secondaryTextColor,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                  ),
                                ),
                                if (_selectedImage != null)
                                  Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: kIsWeb
                                              ? Image.network(
                                                  _selectedImage!.path,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.file(
                                                  File(_selectedImage!.path),
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 16,
                                        right: 8,
                                        child: GestureDetector(
                                          onTap: _removeImage,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black.withValues(alpha: 0.6),
                                              shape: BoxShape.circle,
                                            ),
                                            padding: const EdgeInsets.all(4),
                                            child: const Icon(
                                              CupertinoIcons.xmark,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _IconButton(
                                      icon: CupertinoIcons.photo,
                                      color: secondaryTextColor,
                                      onTap: _pickImage,
                                    ),
                                    _IconButton(
                                      icon: CupertinoIcons.smiley,
                                      color: secondaryTextColor,
                                    ),
                                    _IconButton(
                                      icon: CupertinoIcons.chart_bar,
                                      color: secondaryTextColor,
                                    ),
                                    _IconButton(
                                      icon: CupertinoIcons.location,
                                      color: secondaryTextColor,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Add to thread',
                                  style: TextStyle(
                                    color: secondaryTextColor.withAlpha(
                                      (255 * 0.6).toInt(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const Divider(height: 1, thickness: 0.5),
                // Bottom Bar
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    8,
                    16,
                    16 +
                        (MediaQuery.of(context).viewInsets.bottom > 0
                            ? MediaQuery.of(context).viewInsets.bottom
                            : MediaQuery.of(context).padding.bottom),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            CupertinoIcons.arrow_up_arrow_down,
                            size: 16,
                            color: secondaryTextColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Reply options',
                            style: TextStyle(color: secondaryTextColor),
                          ),
                        ],
                      ),
                      BlocBuilder<PostBloc, PostState>(
                        builder: (context, postState) {
                          final bool isLoading = postState is PostCreating;

                          return ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    final content = _controller.text.trim();
                                    if (content.isNotEmpty || _selectedImage != null) {
                                      context.read<PostBloc>().add(
                                        CreatePostEvent(
                                          content: content,
                                          image: _selectedImage,
                                        ),
                                      );
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              foregroundColor: isDarkMode
                                  ? Colors.black
                                  : Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8,
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.grey,
                                    ),
                                  )
                                : const Text(
                                    'Post',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _IconButton({required this.icon, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: onTap ?? () {},
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
