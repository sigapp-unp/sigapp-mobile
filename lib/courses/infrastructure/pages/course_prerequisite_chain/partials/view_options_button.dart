import 'package:flutter/material.dart';
import 'package:sigapp/courses/domain/entities/course_chain_preferences.dart';

class ViewOptionsButton extends StatelessWidget {
  final CourseViewMode viewMode;
  final bool highlightCriticalPath;
  final VoidCallback onPressed;

  const ViewOptionsButton({
    super.key,
    required this.viewMode,
    required this.highlightCriticalPath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          tooltip: 'Opciones de visualización',
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                viewMode == CourseViewMode.tree
                    ? Icons.account_tree
                    : Icons.view_list,
                size: 24,
              ),
            ],
          ),
        ),
        if (highlightCriticalPath)
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
