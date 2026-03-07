import 'package:flutter/material.dart';

typedef ScrollDeltaCallback = void Function(double delta);

class ScrollDeltaListener extends StatelessWidget {
  final Widget child;
  final ScrollDeltaCallback onScrollDelta;
  final VoidCallback? onScrollEnd;

  const ScrollDeltaListener({
    super.key,
    required this.child,
    required this.onScrollDelta,
    this.onScrollEnd,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (notification.scrollDelta != null &&
              notification.scrollDelta != 0) {
            onScrollDelta(notification.scrollDelta!);
          }
        } else if (notification is ScrollEndNotification) {
          onScrollEnd?.call();
        }
        return false;
      },
      child: child,
    );
  }
}
