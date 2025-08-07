import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sigapp/courses/domain/entities/course_chain_preferences.dart';
import 'package:sigapp/courses/domain/entities/course_type.dart';
import 'package:sigapp/courses/domain/entities/program_curriculum_course_term.dart';
import 'package:sigapp/courses/infrastructure/pages/course_prerequisite_chain/course_chain_preferences_cubit.dart';
import 'package:sigapp/courses/infrastructure/pages/course_prerequisite_chain/partials/view_options_sheet.dart';
import 'package:sigapp/courses/infrastructure/pages/course_prerequisite_chain/partials/view_options_button.dart';
import 'package:sigapp/courses/infrastructure/pages/course_prerequisite_chain/partials/tab_section.dart';
import 'package:sigapp/core/injection/get_it.dart';

class CoursePrerequisiteChainPage extends StatelessWidget {
  const CoursePrerequisiteChainPage({
    super.key,
    required this.programCurriculum,
    required this.course,
  });

  final ProgramCurriculumCourse course;
  final List<ProgramCurriculumTerm> programCurriculum;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<CourseChainPreferencesCubit>(),
      child: _CoursePrerequisiteChainPageContent(
        course: course,
        programCurriculum: programCurriculum,
      ),
    );
  }
}

class _CoursePrerequisiteChainPageContent extends StatefulWidget {
  const _CoursePrerequisiteChainPageContent({
    required this.programCurriculum,
    required this.course,
  });

  final ProgramCurriculumCourse course;
  final List<ProgramCurriculumTerm> programCurriculum;

  @override
  State<_CoursePrerequisiteChainPageContent> createState() =>
      _CoursePrerequisiteChainPageContentState();
}

class _CoursePrerequisiteChainPageContentState
    extends State<_CoursePrerequisiteChainPageContent>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Filter state for prerequisites tab
  bool _showMandatoryReq = true;
  bool _showElectiveReq = true;
  String _approvalFilterReq = 'todos';

  // Filter state for dependents tab
  bool _showMandatoryDep = true;
  bool _showElectiveDep = true;
  String _approvalFilterDep = 'todos';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _setupInitialTabIfNeeded();

    // Load preferences using the cubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentTree = widget.course.getPrerequisiteCoursesTree(
        programCurriculum: widget.programCurriculum,
      );
      BlocProvider.of<CourseChainPreferencesCubit>(
        context,
      ).loadPreferences(currentTree: currentTree);
    });
  }

  void _setupInitialTabIfNeeded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prerequisiteCoursesTree = widget.course.getPrerequisiteCoursesTree(
        programCurriculum: widget.programCurriculum,
      );
      if (prerequisiteCoursesTree == null) {
        _tabController.index = 1;
        setState(() {});
      }
    });
  }

  // --- Ruta crítica ---

  void _toggleCriticalPath(CourseTreeNode? root) async {
    await BlocProvider.of<CourseChainPreferencesCubit>(
      context,
    ).toggleCriticalPath(
      currentTree: root,
      isCriticalPathUseful: _isCriticalPathUseful,
    );
  }

  bool _isCriticalPathUseful(CourseTreeNode? root) {
    if (root == null) return false;

    final totalNodes = _countNodes(root);
    final criticalPath = _findCriticalPath(root);
    final criticalNodes = criticalPath.length;
    final branchingNodes = _countBranchingNodes(root);

    // Critical path is useful if:
    // 1. At least 3 total nodes
    // 2. Critical path doesn't represent more than 75% of the tree
    // 3. At least 1 node with multiple children (alternatives exist)
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- UI Builders ---
  Widget _buildLoading() =>
      const Scaffold(body: Center(child: CircularProgressIndicator()));

  PreferredSizeWidget _buildAppBar(TabController tabController) => AppBar(
    title: const Text('Cadena de requisitos'),
    bottom: TabBar(
      controller: tabController,
      tabs: const [Tab(text: 'Requisitos'), Tab(text: 'Dependientes')],
    ),
  );
  Widget _buildMainScaffold(
    BuildContext context,
    TabController tabController,
    CourseTreeNode? prerequisiteCoursesTree,
    CourseTreeNode? dependentCoursesTree,
    CourseChainPreferencesState preferencesState,
  ) {
    return Scaffold(
      appBar: _buildAppBar(tabController),
      body: TabBarView(
        controller: tabController,
        children: [
          TabSectionWidget(
            tree: prerequisiteCoursesTree,
            showMandatory: _showMandatoryReq,
            showElective: _showElectiveReq,
            approvalFilter: _approvalFilterReq,
            onMandatoryChanged: (v) {
              setState(() => _showMandatoryReq = v);
              _checkCriticalPathAfterFilterChange();
            },
            onElectiveChanged: (v) {
              setState(() => _showElectiveReq = v);
              _checkCriticalPathAfterFilterChange();
            },
            onApprovalChanged: (v) {
              setState(() => _approvalFilterReq = v);
              _checkCriticalPathAfterFilterChange();
            },
            onResetFilters: () => _resetFilters(isRequirements: true),
            isTreeView: preferencesState.viewMode == CourseViewMode.tree,
            highlightCriticalPath: preferencesState.highlightCriticalPath,
            criticalPathIds: preferencesState.criticalPathIds,
          ),
          TabSectionWidget(
            tree: dependentCoursesTree,
            showMandatory: _showMandatoryDep,
            showElective: _showElectiveDep,
            approvalFilter: _approvalFilterDep,
            onMandatoryChanged: (v) {
              setState(() => _showMandatoryDep = v);
              _checkCriticalPathAfterFilterChange();
            },
            onElectiveChanged: (v) {
              setState(() => _showElectiveDep = v);
              _checkCriticalPathAfterFilterChange();
            },
            onApprovalChanged: (v) {
              setState(() => _approvalFilterDep = v);
              _checkCriticalPathAfterFilterChange();
            },
            onResetFilters: () => _resetFilters(isRequirements: false),
            isTreeView: preferencesState.viewMode == CourseViewMode.tree,
            highlightCriticalPath: preferencesState.highlightCriticalPath,
            criticalPathIds: preferencesState.criticalPathIds,
          ),
        ],
      ),
      floatingActionButton: _buildFab(context, preferencesState),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<
      CourseChainPreferencesCubit,
      CourseChainPreferencesState
    >(
      builder: (context, preferencesState) {
        if (preferencesState.isLoading) return _buildLoading();

        final prerequisiteCoursesTree = widget.course
            .getPrerequisiteCoursesTree(
              programCurriculum: widget.programCurriculum,
            );
        final dependentCoursesTree = widget.course.getDependentCoursesTree(
          programCurriculum: widget.programCurriculum,
        );

        return _buildMainScaffold(
          context,
          _tabController,
          prerequisiteCoursesTree,
          dependentCoursesTree,
          preferencesState,
        );
      },
    );
  }

  Widget _buildFab(
    BuildContext context,
    CourseChainPreferencesState preferencesState,
  ) {
    return ViewOptionsButton(
      viewMode: preferencesState.viewMode,
      highlightCriticalPath: preferencesState.highlightCriticalPath,
      onPressed: () => _showViewOptionsSheet(context, preferencesState),
    );
  }

  Future<void> _showViewOptionsSheet(
    BuildContext context,
    CourseChainPreferencesState preferencesState,
  ) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildViewOptionsSheet(preferencesState),
    );

    await _handleViewOptionSelection(selected);
  }

  Widget _buildViewOptionsSheet(CourseChainPreferencesState preferencesState) {
    final currentTree = _getCurrentTabTree();
    final filteredTree = _getFilteredTree(currentTree);

    return ViewOptionsSheetWidget(
      viewMode: preferencesState.viewMode,
      highlightCriticalPath: preferencesState.highlightCriticalPath,
      currentTree: filteredTree,
      onTree: () => Navigator.pop(context, 'tree'),
      onList: () => Navigator.pop(context, 'list'),
      onCritical: () => Navigator.pop(context, 'critical'),
    );
  }

  CourseTreeNode? _getCurrentTabTree() {
    return _tabController.index == 0
        ? widget.course.getPrerequisiteCoursesTree(
          programCurriculum: widget.programCurriculum,
        )
        : widget.course.getDependentCoursesTree(
          programCurriculum: widget.programCurriculum,
        );
  }

  Future<void> _handleViewOptionSelection(String? selected) async {
    switch (selected) {
      case 'tree':
        await BlocProvider.of<CourseChainPreferencesCubit>(
          context,
        ).setViewMode(CourseViewMode.tree);
        break;
      case 'list':
        await BlocProvider.of<CourseChainPreferencesCubit>(
          context,
        ).setViewMode(CourseViewMode.list);
        break;
      case 'critical':
        final currentTree = _getCurrentTabTree();
        final filteredTree = _getFilteredTree(currentTree);
        _toggleCriticalPath(filteredTree);
        break;
    }
  }

  // --- Filter Management ---
  void _resetFilters({required bool isRequirements}) {
    setState(() {
      if (isRequirements) {
        _showMandatoryReq = true;
        _showElectiveReq = true;
        _approvalFilterReq = 'todos';
      } else {
        _showMandatoryDep = true;
        _showElectiveDep = true;
        _approvalFilterDep = 'todos';
      }
    });
    _checkCriticalPathAfterFilterChange();
  }

  void _checkCriticalPathAfterFilterChange() {
    final currentTree = _getCurrentTabTree();
    final filteredTree = _getFilteredTree(currentTree);

    BlocProvider.of<CourseChainPreferencesCubit>(context).updateCriticalPath(
      currentTree: filteredTree,
      isCriticalPathUseful: _isCriticalPathUseful,
    );
  }

  // --- Tree Filtering ---
  CourseTreeNode? _getFilteredTree(CourseTreeNode? tree) {
    if (tree == null) return null;

    final isRequirements = _tabController.index == 0;
    final filters = _getFiltersForCurrentTab(isRequirements);

    return _filterTreeInPage(
      tree,
      filters.showMandatory,
      filters.showElective,
      filters.approvalFilter,
    );
  }

  ({bool showMandatory, bool showElective, String approvalFilter})
  _getFiltersForCurrentTab(bool isRequirements) {
    return isRequirements
        ? (
          showMandatory: _showMandatoryReq,
          showElective: _showElectiveReq,
          approvalFilter: _approvalFilterReq,
        )
        : (
          showMandatory: _showMandatoryDep,
          showElective: _showElectiveDep,
          approvalFilter: _approvalFilterDep,
        );
  }

  CourseTreeNode? _filterTreeInPage(
    CourseTreeNode node,
    bool showMandatory,
    bool showElective,
    String approvalFilter,
  ) {
    final matchesType = _nodeMatchesTypeFilter(
      node,
      showMandatory,
      showElective,
    );
    final matchesApproval = _nodeMatchesApprovalFilter(node, approvalFilter);

    final filteredChildren =
        node.children
            .map(
              (child) => _filterTreeInPage(
                child,
                showMandatory,
                showElective,
                approvalFilter,
              ),
            )
            .whereType<CourseTreeNode>()
            .toList();

    if (matchesType && matchesApproval) {
      return CourseTreeNode(course: node.course, children: filteredChildren);
    } else if (filteredChildren.isNotEmpty) {
      return CourseTreeNode(course: node.course, children: filteredChildren);
    } else {
      return null;
    }
  }

  bool _nodeMatchesTypeFilter(
    CourseTreeNode node,
    bool showMandatory,
    bool showElective,
  ) {
    return (node.course.info.courseType == CourseType.mandatory &&
            showMandatory) ||
        (node.course.info.courseType == CourseType.elective && showElective);
  }

  bool _nodeMatchesApprovalFilter(CourseTreeNode node, String approvalFilter) {
    return approvalFilter == 'todos' ||
        (approvalFilter == 'aprobado' && node.course.isApproved == true) ||
        (approvalFilter == 'no_aprobado' && node.course.isApproved == false);
  }
}
