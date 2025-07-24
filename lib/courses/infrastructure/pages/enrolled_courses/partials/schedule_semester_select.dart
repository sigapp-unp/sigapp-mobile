import 'package:flutter/material.dart';
import 'package:sigapp/shared/domain/value_objects/scheduled_term_identifier.dart';

class ScheduleSemesterSelect extends StatefulWidget {
  const ScheduleSemesterSelect({
    super.key,
    required this.semesterList,
    required this.selectedSemester,
    required this.onSemesterSelected,
  });

  final List<ScheduledTermIdentifier> semesterList;
  final ScheduledTermIdentifier selectedSemester;
  final void Function(ScheduledTermIdentifier semester) onSemesterSelected;

  @override
  State<ScheduleSemesterSelect> createState() => _ScheduleSemesterSelectState();
}

class _ScheduleSemesterSelectState extends State<ScheduleSemesterSelect> {
  final ScrollController _scrollController = ScrollController();
  late List<ScheduledTermIdentifier> _sortedSemesters;

  final listTileHeight = 8.0 * 8;

  @override
  void initState() {
    super.initState();
    _sortedSemesters = [...widget.semesterList]
      ..sort((a, b) => a.id.compareTo(b.id));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelected();
    });
  }

  @override
  void didUpdateWidget(covariant ScheduleSemesterSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedSemester.id != oldWidget.selectedSemester.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelected();
      });
    }
  }

  void _scrollToSelected() {
    final index = _sortedSemesters.indexWhere(
      (s) => s.id == widget.selectedSemester.id,
    );
    if (index != -1 && _scrollController.hasClients) {
      // Calculamos el offset aproximado
      final itemHeight = listTileHeight; // Aproximamos altura de cada item
      final targetOffset =
          itemHeight * index -
          (_scrollController.position.viewportDimension / 2) +
          (itemHeight / 2);

      _scrollController.animateTo(
        targetOffset.clamp(
          _scrollController.position.minScrollExtent,
          _scrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_sortedSemesters.isEmpty) {
      return const Center(child: Text('No hay semestres disponibles'));
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: _sortedSemesters.length,
      itemExtent: listTileHeight,
      itemBuilder: (context, index) {
        final semester = _sortedSemesters[index];
        final isSelected = semester.id == widget.selectedSemester.id;

        return ListTile(
          title: Text(
            semester.name,
            textAlign: TextAlign.center,
            style:
                isSelected
                    ? TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    )
                    : null,
          ),
          onTap:
              isSelected
                  ? null
                  : () {
                    widget.onSemesterSelected(semester);
                  },
        );
      },
    );
  }
}
