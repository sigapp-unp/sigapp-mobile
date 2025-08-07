import 'package:flutter/material.dart';
import 'package:sigapp/courses/domain/entities/course_chain_preferences.dart';
import 'package:sigapp/courses/domain/entities/program_curriculum_course_term.dart';

class ViewOptionsSheetWidget extends StatelessWidget {
  final CourseViewMode viewMode;
  final bool highlightCriticalPath;
  final CourseTreeNode? currentTree;
  final VoidCallback onTree;
  final VoidCallback onList;
  final VoidCallback onCritical;

  const ViewOptionsSheetWidget({
    super.key,
    required this.viewMode,
    required this.highlightCriticalPath,
    required this.currentTree,
    required this.onTree,
    required this.onList,
    required this.onCritical,
  });

  // Calcular estadísticas del árbol
  Map<String, int> _calculateTreeStats(CourseTreeNode? tree) {
    if (tree == null) return {'total': 0, 'criticalPath': 0, 'levels': 0};

    int totalCourses = 0;
    Set<int> levels = {};

    void traverse(CourseTreeNode node, int level) {
      totalCourses++;
      levels.add(level);
      for (final child in node.children) {
        traverse(child, level + 1);
      }
    }

    traverse(tree, 0);

    // Calcular ruta crítica
    List<CourseTreeNode> criticalPath = _findCriticalPath(tree);

    return {
      'total': totalCourses,
      'criticalPath': criticalPath.length,
      'levels': levels.length,
    };
  }

  List<CourseTreeNode> _findCriticalPath(CourseTreeNode? node) {
    if (node == null) return [];
    if (node.children.isEmpty) return [node];
    List<CourseTreeNode> longest = [];
    for (final child in node.children) {
      final path = _findCriticalPath(child);
      if (path.length > longest.length) longest = path;
    }
    return [node, ...longest];
  }

  bool _isCriticalPathUseful(CourseTreeNode? root) {
    if (root == null) return false;

    // Contar total de nodos en el árbol
    int totalNodes = _countNodes(root);

    // Contar nodos en la ruta crítica
    List<CourseTreeNode> criticalPath = _findCriticalPath(root);
    int criticalNodes = criticalPath.length;

    // Contar nodos con múltiples hijos (ramificaciones)
    int branchingNodes = _countBranchingNodes(root);

    // La ruta crítica es útil si:
    // 1. Hay al menos 3 nodos totales
    // 2. La ruta crítica no representa más del 75% del árbol
    // 3. Hay al menos 1 nodo con ramificaciones (alternativas)
    return totalNodes >= 3 &&
        (criticalNodes / totalNodes) <= 0.75 &&
        branchingNodes >= 1;
  }

  int _countNodes(CourseTreeNode? node) {
    if (node == null) return 0;
    int count = 1;
    for (final child in node.children) {
      count += _countNodes(child);
    }
    return count;
  }

  int _countBranchingNodes(CourseTreeNode? node) {
    if (node == null) return 0;
    int count = node.children.length > 1 ? 1 : 0;
    for (final child in node.children) {
      count += _countBranchingNodes(child);
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stats = _calculateTreeStats(currentTree);
    final totalCourses = stats['total']!;
    final criticalPathLength = stats['criticalPath']!;
    final maxLevels = stats['levels']!;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Opciones de visualización',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (totalCourses > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      '$totalCourses cursos • $maxLevels niveles de profundidad',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Divider(height: 1),

            // View mode options
            Column(
              children: [
                _ViewModeOption(
                  icon: Icons.account_tree,
                  title: 'Vista árbol',
                  subtitle: 'Estructura jerárquica con conexiones',
                  isSelected: viewMode == CourseViewMode.tree,
                  onTap: onTree,
                  badge: maxLevels > 0 ? '$maxLevels niveles' : null,
                ),
                _ViewModeOption(
                  icon: Icons.view_list,
                  title: 'Vista lista',
                  subtitle: 'Lista plana agrupada por ciclos',
                  isSelected: viewMode == CourseViewMode.list,
                  onTap: onList,
                  badge: totalCourses > 0 ? '$totalCourses cursos' : null,
                ),
              ],
            ),

            const Divider(height: 1), // Critical path option
            _CriticalPathOption(
              isActive: highlightCriticalPath,
              criticalPathLength: criticalPathLength,
              isUseful: _isCriticalPathUseful(currentTree),
              onTap: onCritical,
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _ViewModeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;

  const _ViewModeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? theme.colorScheme.primaryContainer
                  : theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color:
              isSelected
                  ? theme.colorScheme.onPrimaryContainer
                  : theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? theme.colorScheme.primary : null,
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer.withValues(
                  alpha: 0.7,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      selected: isSelected,
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _CriticalPathOption extends StatelessWidget {
  final bool isActive;
  final int criticalPathLength;
  final bool isUseful;
  final VoidCallback onTap;

  const _CriticalPathOption({
    required this.isActive,
    required this.criticalPathLength,
    required this.isUseful,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      enabled: isUseful, // Desactivar si no es útil
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color:
              !isUseful
                  ? theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.1,
                  )
                  : isActive
                  ? Colors.orange.withValues(alpha: 0.2)
                  : theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.3,
                  ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          !isUseful
              ? Icons.block
              : isActive
              ? Icons.visibility_off
              : Icons.alt_route,
          color:
              !isUseful
                  ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
                  : isActive
                  ? Colors.orange
                  : theme.colorScheme.onSurfaceVariant,
          size: 20,
        ),
      ),
      title: Row(
        children: [
          Text(
            !isUseful
                ? 'Ruta crítica no disponible'
                : isActive
                ? 'Ocultar ruta crítica'
                : 'Mostrar ruta crítica',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color:
                  !isUseful
                      ? theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.4,
                      )
                      : isActive
                      ? Colors.orange
                      : null,
            ),
          ),
          if (criticalPathLength > 0 && isUseful) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$criticalPathLength cursos',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.orange.shade700,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ],
      ),
      subtitle: Text(
        !isUseful
            ? 'Solo hay una secuencia de cursos o muy pocas alternativas'
            : isActive
            ? 'Los cursos críticos se mostrarán normalmente'
            : 'Resalta la cadena más larga de prerrequisitos',
        style: theme.textTheme.bodySmall?.copyWith(
          color:
              !isUseful
                  ? theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)
                  : theme.colorScheme.onSurfaceVariant,
        ),
      ),
      onTap: isUseful ? onTap : null, // Desactivar tap si no es útil
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
