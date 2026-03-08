import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshare/features/auth/presentation/bloc/auth_bloc.dart';

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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      builder: (context, state) {
        String username = 'user';
        String avatarUrl = 'https://i.pravatar.cc/150?u=user';

        if (state is Authenticated) {
          username = state.user.username;
          avatarUrl = 'https://i.pravatar.cc/150?u=$username';
        }

        return Container(
          height:
              MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
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
                      'New posts',
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
                            CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(avatarUrl),
                            ),
                            Expanded(
                              child: Container(
                                width: 2,
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[300],
                                margin: const EdgeInsets.symmetric(vertical: 4),
                              ),
                            ),
                            CircleAvatar(
                              radius: 10,
                              backgroundImage: NetworkImage(avatarUrl),
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
                                    style: TextStyle(color: secondaryTextColor),
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
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _IconButton(
                                    icon: CupertinoIcons.photo,
                                    color: secondaryTextColor,
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
                    ElevatedButton(
                      onPressed: () {
                        // Post action
                        Navigator.pop(context);
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
                      child: const Text(
                        'Post',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _IconButton extends StatelessWidget {
  final IconData icon;
  final Color color;

  const _IconButton({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () {},
        child: Icon(icon, color: color, size: 18),
      ),
    );
  }
}
