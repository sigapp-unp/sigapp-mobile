import 'package:flutter/material.dart';
import 'package:sigapp/courses/domain/entities/grade_tracking.dart';
import 'package:sigapp/courses/infrastructure/pages/course_detail/partials/grade_tracker_section_cubit.dart';

void showHelpDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('¿Cómo funciona?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Puedes anticipar tu promedio final en el curso al registrar tus notas y los pesos ponderados de cada categoría:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('• La suma de los pesos ponderados debe ser 100%'),
            Text(
              '• Puedes activar/desactivar notas específicas para simular su impacto en tu promedio',
            ),
            SizedBox(height: 16),
            Text(
              'Este cálculo no tiene validez oficial y es solo una herramienta de referencia.',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}

void showAddCategoryDialog(
  BuildContext context,
  GradeTrackerSectionCubit cubit,
) {
  final formKey = GlobalKey<FormState>();
  String name = '';
  double weight = 0;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Añadir categoría'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Peso (%)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un peso';
                  }
                  try {
                    final weight = double.parse(value);
                    if (weight <= 0 || weight > 100) {
                      return 'El peso debe estar entre 1 y 100';
                    }
                  } catch (_) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
                onSaved: (value) => weight = double.parse(value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                cubit.addCategory(name: name, weight: weight);
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}

void showEditCategoryDialog(
  BuildContext context,
  GradeCategory category,
  GradeTrackerSectionCubit cubit,
) {
  final formKey = GlobalKey<FormState>();
  String name = category.name;
  double weight = category.weight;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar categoría'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                initialValue: category.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Peso (%)'),
                initialValue: category.weight.toString(),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un peso';
                  }
                  try {
                    final weight = double.parse(value);
                    if (weight <= 0 || weight > 100) {
                      return 'El peso debe estar entre 1 y 100';
                    }
                  } catch (_) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
                onSaved: (value) => weight = double.parse(value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                cubit.updateCategory(
                  categoryId: category.id!,
                  newName: name,
                  newWeight: weight,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}

void showDeleteCategoryDialog(
  BuildContext context,
  GradeCategory category,
  GradeTrackerSectionCubit cubit,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Eliminar categoría'),
        content: Text(
          '¿Estás seguro que deseas eliminar la categoría "${category.name}" y todas sus notas?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              cubit.deleteCategory(categoryId: category.id!);
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );
}

void showAddGradeDialog(
  BuildContext context,
  String categoryId,
  GradeTrackerSectionCubit cubit,
) {
  final formKey = GlobalKey<FormState>();
  String name = '';
  double score = 0;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Añadir nota'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nota (0-20)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una nota';
                  }
                  try {
                    final score = double.parse(value);
                    if (score < 0 || score > 20) {
                      return 'La nota debe estar entre 0 y 20';
                    }
                  } catch (_) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
                onSaved: (value) => score = double.parse(value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                cubit.addGrade(
                  categoryId: categoryId,
                  name: name,
                  score: score,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}

void showEditGradeDialog(
  BuildContext context,
  String categoryId,
  Grade grade,
  GradeTrackerSectionCubit cubit,
) {
  final formKey = GlobalKey<FormState>();
  String name = grade.name;
  double score = grade.score;
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Editar nota'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre'),
                initialValue: grade.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un nombre';
                  }
                  return null;
                },
                onSaved: (value) => name = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nota (0-20)'),
                initialValue: grade.score.toString(),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una nota';
                  }
                  try {
                    final score = double.parse(value);
                    if (score < 0 || score > 20) {
                      return 'La nota debe estar entre 0 y 20';
                    }
                  } catch (_) {
                    return 'Por favor ingresa un número válido';
                  }
                  return null;
                },
                onSaved: (value) => score = double.parse(value!),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                formKey.currentState!.save();
                cubit.updateGrade(
                  categoryId: categoryId,
                  gradeId: grade.id!,
                  newName: name,
                  newScore: score,
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      );
    },
  );
}

void showDeleteGradeDialog(
  BuildContext context,
  String categoryId,
  Grade grade,
  GradeTrackerSectionCubit cubit,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Eliminar nota'),
        content: Text(
          '¿Estás seguro que deseas eliminar la nota "${grade.name}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              cubit.deleteGrade(categoryId: categoryId, gradeId: grade.id!);
              Navigator.pop(context);
            },
            child: const Text('Eliminar'),
          ),
        ],
      );
    },
  );
}
