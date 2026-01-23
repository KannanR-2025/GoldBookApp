import 'package:flutter/material.dart';
import 'package:goldbook_desktop/config/theme.dart';
import 'package:goldbook_desktop/core/widgets/top_navigation_bar.dart';

class MainLayoutTopNav extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const MainLayoutTopNav({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Column(
        children: [
          // Top Navigation Bar
          TopNavigationBar(currentPath: currentPath),

          // Main Content Area
          Expanded(child: child),
        ],
      ),
    );
  }
}
