import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:snapshare/features/navigation/presentation/cubit/navigation_cubit.dart';
import 'package:snapshare/injection_container.dart';
import 'pages/home_page.dart';
import 'pages/messages_page.dart';
import 'pages/notifications_page.dart';
import 'pages/profile_page.dart';
import 'features/posts/presentation/widgets/create_post_bottom_sheet.dart';

class BottomNavBarPage extends StatefulWidget {
  const BottomNavBarPage({super.key});

  @override
  State<BottomNavBarPage> createState() => _BottomNavBarPageState();
}

class _BottomNavBarPageState extends State<BottomNavBarPage> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const MessagesPage(),
    const SizedBox.shrink(), // Placeholder for the middle button
    const NotificationsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      CreatePostBottomSheet.show(context);
      return;
    }
    // Show navigation bar when changing tabs
    sl<NavigationCubit>().show();
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color activeColor = isDarkMode ? Colors.white : Colors.black;

    return BlocProvider.value(
      value: sl<NavigationCubit>(),
      child: BlocBuilder<NavigationCubit, NavigationState>(
        builder: (context, state) {
          final double progress =
              state.progress; // 0.0 (visible) to 1.0 (hidden)
          final double bottomPadding =
              MediaQuery.of(context).padding.bottom +
              MediaQuery.of(context).viewInsets.bottom;
          const double totalHeight = 60.0; // Consistent height for stable math

          final Duration animationDuration = state.animate
              ? const Duration(milliseconds: 300)
              : Duration.zero;

          return Scaffold(
            extendBody: true,
            body: Stack(
              children: [
                IndexedStack(index: _selectedIndex, children: _pages),
                AnimatedPositioned(
                  duration: animationDuration,
                  curve: Curves.easeOutCubic,
                  right: 16,
                  bottom: progress == 0
                      ? -100 // Fully hide below screen when not needed
                      : 16 + bottomPadding,
                  child: AnimatedSlide(
                    duration: animationDuration,
                    curve: Curves.easeOutCubic,
                    offset: Offset(0, 1 - progress),
                    child: AnimatedScale(
                      duration: animationDuration,
                      curve: Curves.easeOutCubic,
                      scale: (0.5 + (progress * 0.5)).clamp(0.5, 1.0),
                      alignment: Alignment.center,
                      child: FloatingActionButton(
                        heroTag: null,
                        onPressed: () => CreatePostBottomSheet.show(context),
                        elevation: 0,
                        backgroundColor: isDarkMode
                            ? Colors.grey[900]
                            : Colors.grey[200],
                        child: Icon(
                          CupertinoIcons.add,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: AnimatedContainer(
              duration: animationDuration,
              curve: Curves.easeOutCubic,
              height: (1 - progress) * (totalHeight + bottomPadding),
              child: OverflowBox(
                minHeight: totalHeight + bottomPadding,
                maxHeight: totalHeight + bottomPadding,
                alignment: Alignment.topCenter,
                child: Container(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey.withAlpha(51),
                        width: 0.5,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        0,
                        CupertinoIcons.house,
                        CupertinoIcons.house_fill,
                        activeColor,
                      ),
                      _buildNavItem(
                        1,
                        CupertinoIcons.paperplane,
                        CupertinoIcons.paperplane_fill,
                        activeColor,
                      ),
                      _buildCreateItem(isDarkMode),
                      _buildNavItem(
                        3,
                        CupertinoIcons.heart,
                        CupertinoIcons.heart_fill,
                        activeColor,
                      ),
                      _buildNavItem(
                        4,
                        CupertinoIcons.person,
                        CupertinoIcons.person_fill,
                        activeColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    IconData activeIcon,
    Color activeColor,
  ) {
    final bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onItemTapped(index),
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Icon(
            isSelected ? activeIcon : icon,
            color: isSelected ? activeColor : Colors.grey.withAlpha(80),
            size: 26,
          ),
        ),
      ),
    );
  }

  Widget _buildCreateItem(bool isDarkMode) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onItemTapped(2),
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                CupertinoIcons.add,
                size: 20,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
