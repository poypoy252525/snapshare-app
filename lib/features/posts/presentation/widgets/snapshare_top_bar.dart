import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class ThreadsTopBar extends StatelessWidget implements PreferredSizeWidget {
  const ThreadsTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: true,
      title: Text(
        'SnapShare',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(CupertinoIcons.search),
          onPressed: () {
            // Logic for search
          },
          color: Colors.grey.withAlpha(255),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
