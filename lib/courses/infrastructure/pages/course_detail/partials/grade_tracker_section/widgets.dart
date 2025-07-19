import 'package:flutter/material.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/partials/grade_tracker_section/dialogs.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/partials/grade_tracker_section_cubit.dart';

class FinalGradeCardWidget extends StatelessWidget {
  const FinalGradeCardWidget({super.key, required this.tracking});

  final CourseTracking tracking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Promedio ponderado', style: textTheme.titleMedium),
                Text(
                  tracking.finalGrade.toStringAsFixed(2),
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _getColorForGrade(tracking.finalGrade),
                  ),
                ),
              ],
            ),
            if (!tracking.isWeightValid) ...[
              SizedBox(height: 8),
              Text(
                '${tracking.weightDifference > 0 ? 'Falta ${tracking.weightDifference.toStringAsFixed(2)}% para completar los pesos ponderados' : ' Los pesos ponderados exceden el 100% en ${tracking.weightDifference.abs().toStringAsFixed(2)}%'}. El cálculo no es correcto.',
                style: textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class CategoryCardWidget extends StatelessWidget {
  const CategoryCardWidget({
    super.key,
    required this.category,
    required this.cubit,
    this.processingGradeIds = const {},
  });

  final GradeCategory category;
  final GradeTrackerSectionCubit cubit;
  final Set<String> processingGradeIds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(category.name, style: textTheme.titleMedium),
                ),
                Text(
                  'Peso: ${category.weight.toStringAsFixed(0)}%',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(width: 8),
                _CategoryPopupMenuWidget(category: category, cubit: cubit),
              ],
            ),
            const Divider(),
            if (category.grades.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('No hay notas registradas'),
              )
            else
              ...category.grades.map((grade) {
                return _GradeItemWidget(
                  categoryId: category.id!,
                  grade: grade,
                  cubit: cubit,
                  processingGradeIds: processingGradeIds,
                );
              }),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: textTheme.titleMedium,
                    children: [
                      TextSpan(text: 'Promedio: '),
                      TextSpan(
                        text: category.averagePercentage.toStringAsFixed(2),
                        style: TextStyle(
                          color: _getColorForGrade(category.averagePercentage),
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    showAddGradeDialog(context, category.id!, cubit);
                  },
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Añadir nota'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GradeItemWidget extends StatelessWidget {
  const _GradeItemWidget({
    required this.categoryId,
    required this.grade,
    required this.cubit,
    this.processingGradeIds = const {},
  });

  final String categoryId;
  final Grade grade;
  final GradeTrackerSectionCubit cubit;
  final Set<String> processingGradeIds;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isProcessing = processingGradeIds.contains(grade.id);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          grade.name,
          style: textTheme.bodyLarge?.copyWith(
            color: isProcessing ? Colors.grey.shade600 : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              grade.score.toStringAsFixed(2),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color:
                    isProcessing
                        ? Colors.grey.shade400
                        : (grade.enabled
                            ? _getColorForGrade(grade.score)
                            : Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            if (!grade.enabled)
              Text(
                'No considerar',
                style: textTheme.bodyMedium?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
          ],
        ),
        leading: Switch(
          value: grade.enabled,
          onChanged:
              isProcessing
                  ? null
                  : (value) {
                    cubit.toggleGradeEnabled(
                      categoryId: categoryId,
                      gradeId: grade.id!,
                      enabled: value,
                    );
                  },
        ),
        trailing:
            isProcessing
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () {
                        showEditGradeDialog(context, categoryId, grade, cubit);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20),
                      onPressed: () {
                        showDeleteGradeDialog(
                          context,
                          categoryId,
                          grade,
                          cubit,
                        );
                      },
                    ),
                  ],
                ),
      ),
    );
  }
}

class _CategoryPopupMenuWidget extends StatelessWidget {
  const _CategoryPopupMenuWidget({required this.category, required this.cubit});

  final GradeCategory category;
  final GradeTrackerSectionCubit cubit;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'edit') {
          showEditCategoryDialog(context, category, cubit);
        } else if (value == 'delete') {
          showDeleteCategoryDialog(context, category, cubit);
        }
      },
      itemBuilder:
          (context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Editar'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Eliminar'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
    );
  }
}

class AddCategoryButtonWidget extends StatelessWidget {
  const AddCategoryButtonWidget({super.key, required this.cubit});

  final GradeTrackerSectionCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          showAddCategoryDialog(context, cubit);
        },
        icon: const Icon(Icons.add),
        label: const Text('Añadir categoría'),
      ),
    );
  }
}

class HelpButtonWidget extends StatelessWidget {
  const HelpButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.help_outline),
      color: Theme.of(context).colorScheme.primary,
      onPressed: () {
        showHelpDialog(context);
      },
    );
  }
}

// Función de utilidad para determinar el color de la nota
Color _getColorForGrade(double grade) {
  if (grade >= 14) {
    return Colors.green;
  } else if (grade >= 11) {
    return Colors.amber.shade800;
  } else {
    return Colors.red;
  }
}
