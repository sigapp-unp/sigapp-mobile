import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sigapp/core/infrastructure/ui/widgets/error_state.dart';
import 'package:sigapp/core/infrastructure/ui/widgets/loading_state.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:sigapp/courses/infrastructure/pages/career/career_page_cubit.dart';
import 'package:sigapp/courses/infrastructure/pages/career/partials/academic_history.dart';
import 'package:sigapp/courses/infrastructure/pages/career/partials/program_curriculum.dart';
import 'package:sigapp/courses/infrastructure/pages/scheduled_courses/scheduled_courses_cubit.dart';
import 'package:sigapp/courses/infrastructure/pages/scheduled_courses/scheduled_courses_page.dart';
import 'package:sigapp/shared/infrastructure/partials/user_avatar_button.dart';

class CareerPageView extends StatefulWidget {
  const CareerPageView({super.key});

  @override
  State<CareerPageView> createState() => _CareerPageViewState();
}

class _CareerPageViewState extends State<CareerPageView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final CareerPageCubit _cubit;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _cubit = BlocProvider.of<CareerPageCubit>(context);
    _cubit.fetch();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CareerPageCubit, CareerPageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Carrera'), UserAvatarButtonWidget()],
            ),
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(icon: Icon(MdiIcons.book), text: 'Plan'),
                Tab(icon: Icon(MdiIcons.chartBar), text: 'Historial'),
                Tab(icon: Icon(MdiIcons.calendarSearch), text: 'Programación'),
              ],
            ),
          ),
          body: switch (state) {
            CareerPageLoadingState() => LoadingStateWidget(),
            CareerPageSuccessState() => _buildReadyState(state),
            CareerPageErrorState() => ErrorStateWidget.from(
              state.error,
              onRetry: () => _cubit.fetch(),
            ),
          },
        );
      },
    );
  }

  Widget _buildReadyState(CareerPageSuccessState state) {
    return TabBarView(
      controller: _tabController,
      children: [_Tab1(state), _Tab2(state), _Tab3(state)],
    );
  }
}

class _Tab2 extends StatefulWidget {
  final CareerPageSuccessState state;

  const _Tab2(this.state);

  @override
  State<_Tab2> createState() => _Tab2State();
}

class _Tab2State extends State<_Tab2> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CareerPageAcademicHistoryWidget(
      academicHistory: widget.state.programCurriculumProgress.academicHistory,
      report: widget.state.academicReport,
    );
  }
}

class _Tab3 extends StatefulWidget {
  final CareerPageSuccessState state;

  const _Tab3(this.state);

  @override
  State<_Tab3> createState() => _Tab3State();
}

class _Tab3State extends State<_Tab3> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider(
      create: (context) {
        final cubit = getIt<ScheduledCoursesPageCubit>();
        cubit.setup();
        return cubit;
      },
      child: ScheduledCoursesPage(),
    );
  }
}

class _Tab1 extends StatefulWidget {
  final CareerPageSuccessState state;

  const _Tab1(this.state);

  @override
  State<_Tab1> createState() => _Tab1State();
}

class _Tab1State extends State<_Tab1> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CareerPageProgramCurriculumWidget(
      programCurriculum:
          widget.state.programCurriculumProgress.programCurriculum,
      academicReport: widget.state.academicReport,
    );
  }
}
