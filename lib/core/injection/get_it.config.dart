// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:go_router/go_router.dart' as _i583;
import 'package:injectable/injectable.dart' as _i526;
import 'package:logger/logger.dart' as _i974;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:sigapp/auth/application/managers/authentication_manager.dart'
    as _i767;
import 'package:sigapp/auth/application/managers/authentication_manager/async_operation_guard.dart'
    as _i465;
import 'package:sigapp/auth/application/services/api_gateway_auth_service.dart'
    as _i391;
import 'package:sigapp/auth/application/usecases/get_stored_credentials_usecase.dart'
    as _i193;
import 'package:sigapp/auth/application/usecases/keep_session_alive_usecase.dart'
    as _i908;
import 'package:sigapp/auth/application/usecases/siga_authentication_usecase.dart'
    as _i568;
import 'package:sigapp/auth/application/usecases/sign_in_usecase.dart' as _i365;
import 'package:sigapp/auth/application/usecases/sign_out_usecase.dart' as _i48;
import 'package:sigapp/auth/domain/repositories/auth_repository.dart' as _i10;
import 'package:sigapp/auth/domain/repositories/shared_preferences_auth_repository.dart'
    as _i1010;
import 'package:sigapp/auth/domain/services/navigation_service.dart' as _i528;
import 'package:sigapp/auth/domain/services/session_lifecycle_service.dart'
    as _i679;
import 'package:sigapp/auth/domain/services/toast_service.dart' as _i873;
import 'package:sigapp/auth/infrastructure/pages/login_cubit.dart' as _i41;
import 'package:sigapp/auth/infrastructure/repositories/auth_repository.dart'
    as _i127;
import 'package:sigapp/auth/infrastructure/repositories/shared_preferences_auth_repository.dart'
    as _i247;
import 'package:sigapp/auth/infrastructure/services/api_gateway_auth_service.dart'
    as _i417;
import 'package:sigapp/auth/infrastructure/services/navigation_service.dart'
    as _i561;
import 'package:sigapp/auth/infrastructure/services/session_lifecycle_service.dart'
    as _i649;
import 'package:sigapp/auth/infrastructure/services/toast_service.dart'
    as _i804;
import 'package:sigapp/core/infrastructure/app/app_initializer.dart' as _i576;
import 'package:sigapp/core/infrastructure/database/database_health_manager.dart'
    as _i199;
import 'package:sigapp/core/infrastructure/database/sqlite_client_manager.dart'
    as _i139;
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart'
    as _i200;
import 'package:sigapp/core/infrastructure/http/regeva_client.dart' as _i986;
import 'package:sigapp/core/infrastructure/http/siga_client.dart' as _i857;
import 'package:sigapp/core/infrastructure/services/update_service.dart'
    as _i897;
import 'package:sigapp/core/infrastructure/ui/utils/mail_utils.dart' as _i382;
import 'package:sigapp/core/injection/register_module.dart' as _i799;
import 'package:sigapp/courses/application/use_cases/get_sync_metrics_use_case.dart'
    as _i262;
import 'package:sigapp/courses/application/usecases/create_grade_tracking_usecase.dart'
    as _i733;
import 'package:sigapp/courses/application/usecases/delete_grade_tracking_usecase.dart'
    as _i362;
import 'package:sigapp/courses/application/usecases/get_all_hidden_courses_preferences_usecase.dart'
    as _i323;
import 'package:sigapp/courses/application/usecases/get_class_schedule_usecase.dart'
    as _i315;
import 'package:sigapp/courses/application/usecases/get_course_grade_usecase.dart'
    as _i504;
import 'package:sigapp/courses/application/usecases/get_course_view_mode_preferences_usecase.dart'
    as _i186;
import 'package:sigapp/courses/application/usecases/get_enrolled_courses_usecase.dart'
    as _i650;
import 'package:sigapp/courses/application/usecases/get_grade_tracking_usecase.dart'
    as _i409;
import 'package:sigapp/courses/application/usecases/get_highlight_critical_path_preferences_usecase.dart'
    as _i127;
import 'package:sigapp/courses/application/usecases/get_program_curriculum_progress_usecase.dart'
    as _i504;
import 'package:sigapp/courses/application/usecases/get_scheduled_courses_usecase.dart'
    as _i154;
import 'package:sigapp/courses/application/usecases/get_syllabus_file_usecase.dart'
    as _i445;
import 'package:sigapp/courses/application/usecases/manage_grade_tracking_categories_usecase.dart'
    as _i1033;
import 'package:sigapp/courses/application/usecases/manage_grade_tracking_grades_usecase.dart'
    as _i811;
import 'package:sigapp/courses/application/usecases/set_course_view_mode_preferences_usecase.dart'
    as _i857;
import 'package:sigapp/courses/application/usecases/set_course_visibility_preferences_usecase.dart'
    as _i733;
import 'package:sigapp/courses/application/usecases/set_highlight_critical_path_preferences_usecase.dart'
    as _i131;
import 'package:sigapp/courses/domain/repositories/courses_repository.dart'
    as _i986;
import 'package:sigapp/courses/domain/repositories/grade_tracking_category_repository.dart'
    as _i325;
import 'package:sigapp/courses/domain/repositories/grade_tracking_course_repository.dart'
    as _i786;
import 'package:sigapp/courses/domain/repositories/grade_tracking_grade_repository.dart'
    as _i364;
import 'package:sigapp/courses/domain/repositories/local_syllabus_repository.dart'
    as _i504;
import 'package:sigapp/courses/domain/repositories/program_curriculum_repository.dart'
    as _i889;
import 'package:sigapp/courses/domain/repositories/regeva_repository.dart'
    as _i348;
import 'package:sigapp/courses/domain/repositories/schedule_repository.dart'
    as _i974;
import 'package:sigapp/courses/domain/repositories/user_preferences_repository.dart'
    as _i939;
import 'package:sigapp/courses/domain/services/course_service.dart' as _i906;
import 'package:sigapp/courses/infrastructure/pages/career/career_page_cubit.dart'
    as _i112;
import 'package:sigapp/courses/infrastructure/pages/course_detail/course_detail_cubit.dart'
    as _i215;
import 'package:sigapp/courses/infrastructure/pages/course_detail/partials/grade_tracker_section_cubit.dart'
    as _i1059;
import 'package:sigapp/courses/infrastructure/pages/course_prerequisite_chain/course_chain_preferences_cubit.dart'
    as _i293;
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/enrolled_courses_page_cubit.dart'
    as _i885;
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/partials/weekly_schedule/course_visibility_cubit.dart'
    as _i55;
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/tabs/schedule_tab/schedule_share_button_cubit.dart'
    as _i880;
import 'package:sigapp/courses/infrastructure/pages/scheduled_courses/scheduled_courses_cubit.dart'
    as _i27;
import 'package:sigapp/courses/infrastructure/repositories/courses_repository.dart'
    as _i892;
import 'package:sigapp/courses/infrastructure/repositories/local_grade_tracking_category_decorator.dart'
    as _i219;
import 'package:sigapp/courses/infrastructure/repositories/local_grade_tracking_course_decorator.dart'
    as _i954;
import 'package:sigapp/courses/infrastructure/repositories/local_grade_tracking_grade_decorator.dart'
    as _i434;
import 'package:sigapp/courses/infrastructure/repositories/local_syllabus_repository.dart'
    as _i717;
import 'package:sigapp/courses/infrastructure/repositories/program_curriculum_repository.dart'
    as _i654;
import 'package:sigapp/courses/infrastructure/repositories/regeva_repository.dart'
    as _i75;
import 'package:sigapp/courses/infrastructure/repositories/remote_grade_tracking_category_repository.dart'
    as _i50;
import 'package:sigapp/courses/infrastructure/repositories/remote_grade_tracking_course_repository.dart'
    as _i264;
import 'package:sigapp/courses/infrastructure/repositories/remote_grade_tracking_grade_repository.dart'
    as _i1020;
import 'package:sigapp/courses/infrastructure/repositories/schedule_repository.dart'
    as _i637;
import 'package:sigapp/courses/infrastructure/repositories/student_session_repository.dart'
    as _i79;
import 'package:sigapp/courses/infrastructure/repositories/sync_queue_repository.dart'
    as _i328;
import 'package:sigapp/courses/infrastructure/repositories/user_preferences_repository_impl.dart'
    as _i669;
import 'package:sigapp/courses/infrastructure/services/app_lifecycle_sync_integration.dart'
    as _i615;
import 'package:sigapp/courses/infrastructure/services/conflict_resolver.dart'
    as _i710;
import 'package:sigapp/courses/infrastructure/services/grade_tracking_local_service.dart'
    as _i891;
import 'package:sigapp/courses/infrastructure/services/sync_manager.dart'
    as _i870;
import 'package:sigapp/shared/application/repositories/student_session_repository.dart'
    as _i607;
import 'package:sigapp/shared/application/usecases/get_academic_info_usecase.dart'
    as _i354;
import 'package:sigapp/shared/domain/service/progress_indicator_service.dart'
    as _i151;
import 'package:sigapp/shared/infrastructure/overlays/progress_indicator_bloc.dart'
    as _i675;
import 'package:sigapp/shared/infrastructure/pages/home_page_cubit.dart'
    as _i722;
import 'package:sigapp/shared/infrastructure/pages/sync_metrics_cubit.dart'
    as _i43;
import 'package:sigapp/shared/infrastructure/partials/user_avatar_button_cubit.dart'
    as _i259;
import 'package:sigapp/shared/infrastructure/services/progress_indicator_service.dart'
    as _i856;
import 'package:sigapp/student/application/usecases/get_academic_report_usecase.dart'
    as _i771;
import 'package:sigapp/student/domain/repositories/student_repository.dart'
    as _i594;
import 'package:sigapp/student/infrastructure/pages/student_cubit.dart'
    as _i151;
import 'package:sigapp/student/infrastructure/repositories/student_repository.dart'
    as _i528;
import 'package:sigapp/student/infrastructure/usecases/cached_get_academic_info_usecase.dart'
    as _i866;
import 'package:sigapp/student/infrastructure/usecases/get_academic_info_usecase_impl.dart'
    as _i248;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i880.ScheduleShareButtonCubit>(
      () => _i880.ScheduleShareButtonCubit(),
    );
    await gh.singletonAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i974.Logger>(() => registerModule.logger());
    gh.singleton<_i906.CourseService>(() => _i906.CourseService());
    gh.singleton<_i675.ProgressIndicatorBloc>(
      () => _i675.ProgressIndicatorBloc(),
    );
    gh.singleton<_i151.ProgressIndicatorService>(
      () =>
          _i856.ProgressIndicatorServiceImpl(gh<_i675.ProgressIndicatorBloc>()),
    );
    gh.singleton<_i504.LocalSyllabusRepository>(
      () => _i717.LocalSyllabusRepositoryImpl(),
    );
    gh.singleton<_i873.ToastService>(() => _i804.ToastServiceImpl());
    gh.singleton<_i1010.SharedPreferencesAuthRepository>(
      () => _i247.SharedPreferencesAuthRepositoryImpl(
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.singletonAsync<_i139.SQLiteClientManager>(() {
      final i = _i139.SQLiteClientManager(gh<_i974.Logger>());
      return i.init().then((_) => i);
    });
    gh.singleton<_i200.ApiGatewayClient>(
      () => _i200.ApiGatewayClient(gh<_i974.Logger>()),
    );
    gh.singleton<_i897.UpdateService>(
      () => _i897.UpdateService(gh<_i974.Logger>()),
    );
    gh.singleton<_i199.DatabaseHealthManager>(
      () => _i199.DatabaseHealthManager(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i465.AsyncOperationGuard>(
      () => _i465.AsyncOperationGuard(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i382.MailUtils>(
      () => _i382.MailUtils(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i710.ConflictResolver>(
      () => _i710.ConflictResolver(gh<_i974.Logger>()),
    );
    gh.singleton<_i986.RegevaClient>(
      () =>
          _i986.RegevaClient(gh<_i460.SharedPreferences>(), gh<_i974.Logger>()),
    );
    gh.singleton<_i857.SigaClient>(
      () => _i857.SigaClient(gh<_i460.SharedPreferences>(), gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i391.ApiGatewayAuthService>(
      () => _i417.ApiGatewayAuthServiceImpl(
        gh<_i200.ApiGatewayClient>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i193.GetStoredCredentialsUseCase>(
      () => _i193.GetStoredCredentialsUseCase(
        gh<_i1010.SharedPreferencesAuthRepository>(),
      ),
    );
    gh.lazySingleton<_i974.ScheduleRepository>(
      () => _i637.ScheduleRepositoryImpl(gh<_i857.SigaClient>()),
    );
    gh.singleton<_i10.AuthRepository>(
      () =>
          _i127.AuthRepositoryImpl(gh<_i857.SigaClient>(), gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i889.ProgramCurriculumRepository>(
      () => _i654.ProgramCurriculumRepositoryImpl(gh<_i857.SigaClient>()),
    );
    gh.lazySingleton<_i786.GradeTrackingCourseRepository>(
      () => _i264.RemoteGradeTrackingCourseRepository(
        gh<_i200.ApiGatewayClient>(),
        gh<_i974.Logger>(),
      ),
      instanceName: 'remote',
    );
    gh.singletonAsync<_i891.GradeTrackingLocalService>(
      () async => _i891.GradeTrackingLocalService(
        await getAsync<_i139.SQLiteClientManager>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.singletonAsync<_i328.SyncQueueRepository>(
      () async => _i328.SyncQueueRepository(
        await getAsync<_i139.SQLiteClientManager>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.singletonAsync<_i576.AppInitializer>(
      () async => _i576.AppInitializer(
        await getAsync<_i139.SQLiteClientManager>(),
        gh<_i199.DatabaseHealthManager>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i325.GradeTrackingCategoryRepository>(
      () => _i50.RemoteGradeTrackingCategoryRepository(
        gh<_i200.ApiGatewayClient>(),
        gh<_i974.Logger>(),
        gh<_i786.GradeTrackingCourseRepository>(instanceName: 'remote'),
      ),
      instanceName: 'remote',
    );
    gh.lazySingleton<_i348.RegevaRepository>(
      () => _i75.RegevaRepositoryImpl(gh<_i986.RegevaClient>()),
    );
    gh.lazySingleton<_i939.UserPreferencesRepository>(
      () => _i669.UserPreferencesRepositoryImpl(
        gh<_i200.ApiGatewayClient>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i607.StudentSessionRepository>(
      () => _i79.StudentSessionRepositoryImpl(gh<_i857.SigaClient>()),
    );
    gh.singleton<_i679.SessionLifecycleService>(
      () => _i649.SessionLifecycleServiceImpl(
        gh<_i857.SigaClient>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i986.CoursesRepository>(
      () => _i892.CoursesRepositoryImpl(gh<_i857.SigaClient>()),
    );
    gh.singleton<_i583.GoRouter>(
      () => registerModule.router(gh<_i193.GetStoredCredentialsUseCase>()),
    );
    gh.lazySingleton<_i315.GetClassScheduleUsecase>(
      () => _i315.GetClassScheduleUsecase(gh<_i974.ScheduleRepository>()),
    );
    gh.lazySingleton<_i594.StudentRepository>(
      () => _i528.StudentRepositoryImpl(gh<_i857.SigaClient>()),
    );
    gh.factory<_i908.KeepSessionAliveUsecase>(
      () => _i908.KeepSessionAliveUsecase(gh<_i10.AuthRepository>()),
    );
    gh.lazySingleton<_i154.GetScheduledCoursesUsecase>(
      () => _i154.GetScheduledCoursesUsecase(gh<_i986.CoursesRepository>()),
    );
    gh.lazySingleton<_i504.GetCourseGradeUsecase>(
      () => _i504.GetCourseGradeUsecase(
        gh<_i607.StudentSessionRepository>(),
        gh<_i348.RegevaRepository>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i27.ScheduledCoursesPageCubit>(
      () => _i27.ScheduledCoursesPageCubit(
        gh<_i154.GetScheduledCoursesUsecase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i364.GradeTrackingGradeRepository>(
      () => _i1020.RemoteGradeTrackingGradeRepository(
        gh<_i200.ApiGatewayClient>(),
        gh<_i974.Logger>(),
        gh<_i786.GradeTrackingCourseRepository>(instanceName: 'remote'),
      ),
      instanceName: 'remote',
    );
    gh.lazySingleton<_i650.GetEnrolledCoursesUsecase>(
      () => _i650.GetEnrolledCoursesUsecase(
        gh<_i986.CoursesRepository>(),
        gh<_i315.GetClassScheduleUsecase>(),
      ),
    );
    gh.factory<_i568.SigaAuthenticationUsecase>(
      () => _i568.SigaAuthenticationUsecase(
        gh<_i10.AuthRepository>(),
        gh<_i679.SessionLifecycleService>(),
      ),
    );
    gh.factory<_i323.GetAllHiddenCoursesPreferencesUseCase>(
      () => _i323.GetAllHiddenCoursesPreferencesUseCase(
        gh<_i939.UserPreferencesRepository>(),
        gh<_i607.StudentSessionRepository>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i186.GetCourseViewModeUseCase>(
      () => _i186.GetCourseViewModeUseCase(
        gh<_i939.UserPreferencesRepository>(),
        gh<_i607.StudentSessionRepository>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i127.GetHighlightCriticalPathUseCase>(
      () => _i127.GetHighlightCriticalPathUseCase(
        gh<_i939.UserPreferencesRepository>(),
        gh<_i607.StudentSessionRepository>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i857.SetCourseViewModePreferencesUseCase>(
      () => _i857.SetCourseViewModePreferencesUseCase(
        gh<_i939.UserPreferencesRepository>(),
        gh<_i607.StudentSessionRepository>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i131.SetHighlightCriticalPathPreferencesUseCase>(
      () => _i131.SetHighlightCriticalPathPreferencesUseCase(
        gh<_i939.UserPreferencesRepository>(),
        gh<_i607.StudentSessionRepository>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i445.GetSyllabusFileUsecase>(
      () => _i445.GetSyllabusFileUsecase(
        gh<_i348.RegevaRepository>(),
        gh<_i607.StudentSessionRepository>(),
        gh<_i504.LocalSyllabusRepository>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i771.GetAcademicReportUsecase>(
      () => _i771.GetAcademicReportUsecase(
        gh<_i594.StudentRepository>(),
        gh<_i607.StudentSessionRepository>(),
      ),
    );
    gh.factory<_i215.CourseDetailCubit>(
      () => _i215.CourseDetailCubit(
        gh<_i445.GetSyllabusFileUsecase>(),
        gh<_i504.GetCourseGradeUsecase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingletonAsync<_i870.SyncManager>(
      () async => _i870.SyncManager(
        await getAsync<_i328.SyncQueueRepository>(),
        gh<_i974.Logger>(),
        gh<_i786.GradeTrackingCourseRepository>(instanceName: 'remote'),
        gh<_i325.GradeTrackingCategoryRepository>(instanceName: 'remote'),
        gh<_i364.GradeTrackingGradeRepository>(instanceName: 'remote'),
      ),
    );
    gh.lazySingletonAsync<_i364.GradeTrackingGradeRepository>(
      () async => _i434.LocalGradeTrackingGradeDecorator(
        gh<_i364.GradeTrackingGradeRepository>(instanceName: 'remote'),
        gh<_i786.GradeTrackingCourseRepository>(instanceName: 'remote'),
        await getAsync<_i891.GradeTrackingLocalService>(),
        await getAsync<_i870.SyncManager>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.singleton<_i354.GetAcademicInfoUseCase>(
      () => _i248.GetAcademicInfoUseCaseImpl(
        gh<_i771.GetAcademicReportUsecase>(),
        gh<_i650.GetEnrolledCoursesUsecase>(),
        gh<_i607.StudentSessionRepository>(),
      ),
      instanceName: 'getAcademicInfoUseCaseImpl',
    );
    gh.singleton<_i528.NavigationService>(
      () => _i561.NavigationServiceImpl(gh<_i583.GoRouter>()),
    );
    gh.factory<_i293.CourseChainPreferencesCubit>(
      () => _i293.CourseChainPreferencesCubit(
        gh<_i186.GetCourseViewModeUseCase>(),
        gh<_i857.SetCourseViewModePreferencesUseCase>(),
        gh<_i127.GetHighlightCriticalPathUseCase>(),
        gh<_i131.SetHighlightCriticalPathPreferencesUseCase>(),
        gh<_i873.ToastService>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.singletonAsync<_i615.AppLifecycleSyncIntegration>(
      () async => _i615.AppLifecycleSyncIntegration(
        await getAsync<_i870.SyncManager>(),
        gh<_i974.Logger>(),
      )..initialize(),
    );
    gh.factory<_i733.SetCourseVisibilityPreferencesUseCase>(
      () => _i733.SetCourseVisibilityPreferencesUseCase(
        gh<_i939.UserPreferencesRepository>(),
        gh<_i607.StudentSessionRepository>(),
        gh<_i323.GetAllHiddenCoursesPreferencesUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingletonAsync<_i786.GradeTrackingCourseRepository>(
      () async => _i954.LocalGradeTrackingCourseDecorator(
        gh<_i786.GradeTrackingCourseRepository>(instanceName: 'remote'),
        await getAsync<_i891.GradeTrackingLocalService>(),
        await getAsync<_i870.SyncManager>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factoryAsync<_i262.GetSyncMetricsUseCase>(
      () async =>
          _i262.GetSyncMetricsUseCase(await getAsync<_i870.SyncManager>()),
    );
    gh.factoryAsync<_i811.ManageGradeTrackingGradesUseCase>(
      () async => _i811.ManageGradeTrackingGradesUseCase(
        await getAsync<_i364.GradeTrackingGradeRepository>(),
        gh<_i607.StudentSessionRepository>(),
      ),
    );
    gh.factoryAsync<_i733.CreateGradeTrackingUseCase>(
      () async => _i733.CreateGradeTrackingUseCase(
        await getAsync<_i786.GradeTrackingCourseRepository>(),
        gh<_i607.StudentSessionRepository>(),
      ),
    );
    gh.factoryAsync<_i362.DeleteGradeTrackingUseCase>(
      () async => _i362.DeleteGradeTrackingUseCase(
        await getAsync<_i786.GradeTrackingCourseRepository>(),
        gh<_i607.StudentSessionRepository>(),
      ),
    );
    gh.factoryAsync<_i409.GetGradeTrackingUseCase>(
      () async => _i409.GetGradeTrackingUseCase(
        await getAsync<_i786.GradeTrackingCourseRepository>(),
        gh<_i607.StudentSessionRepository>(),
      ),
    );
    gh.lazySingletonAsync<_i325.GradeTrackingCategoryRepository>(
      () async => _i219.LocalGradeTrackingCategoryDecorator(
        gh<_i325.GradeTrackingCategoryRepository>(instanceName: 'remote'),
        gh<_i786.GradeTrackingCourseRepository>(instanceName: 'remote'),
        await getAsync<_i891.GradeTrackingLocalService>(),
        await getAsync<_i870.SyncManager>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factoryAsync<_i43.SyncMetricsCubit>(
      () async =>
          _i43.SyncMetricsCubit(await getAsync<_i262.GetSyncMetricsUseCase>()),
    );
    gh.factory<_i48.SignOutUseCase>(
      () => _i48.SignOutUseCase(
        gh<_i1010.SharedPreferencesAuthRepository>(),
        gh<_i528.NavigationService>(),
        gh<_i10.AuthRepository>(),
        gh<_i348.RegevaRepository>(),
        gh<_i151.ProgressIndicatorService>(),
        gh<_i391.ApiGatewayAuthService>(),
        gh<_i873.ToastService>(),
        gh<_i607.StudentSessionRepository>(),
        gh<_i594.StudentRepository>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.singleton<_i354.GetAcademicInfoUseCase>(
      () => _i866.CachedGetAcademicInfoUseCase(
        gh<_i354.GetAcademicInfoUseCase>(
          instanceName: 'getAcademicInfoUseCaseImpl',
        ),
      ),
    );
    gh.singleton<_i767.AuthenticationManager>(
      () => _i767.AuthenticationManager(
        gh<_i679.SessionLifecycleService>(),
        gh<_i193.GetStoredCredentialsUseCase>(),
        gh<_i48.SignOutUseCase>(),
        gh<_i908.KeepSessionAliveUsecase>(),
        gh<_i568.SigaAuthenticationUsecase>(),
        gh<_i873.ToastService>(),
        gh<_i974.Logger>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i259.UserAvatarButtonCubit>(
      () => _i259.UserAvatarButtonCubit(
        gh<_i354.GetAcademicInfoUseCase>(),
        gh<_i48.SignOutUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i55.CourseVisibilityCubit>(
      () => _i55.CourseVisibilityCubit(
        gh<_i323.GetAllHiddenCoursesPreferencesUseCase>(),
        gh<_i733.SetCourseVisibilityPreferencesUseCase>(),
        gh<_i873.ToastService>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factoryAsync<_i1033.ManageGradeTrackingCategoriesUseCase>(
      () async => _i1033.ManageGradeTrackingCategoriesUseCase(
        await getAsync<_i325.GradeTrackingCategoryRepository>(),
        gh<_i607.StudentSessionRepository>(),
      ),
    );
    gh.factory<_i151.StudentPageViewCubit>(
      () => _i151.StudentPageViewCubit(
        gh<_i354.GetAcademicInfoUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i365.SignInUseCase>(
      () => _i365.SignInUseCase(
        gh<_i1010.SharedPreferencesAuthRepository>(),
        gh<_i391.ApiGatewayAuthService>(),
        gh<_i528.NavigationService>(),
        gh<_i354.GetAcademicInfoUseCase>(),
        gh<_i607.StudentSessionRepository>(),
        gh<_i594.StudentRepository>(),
        gh<_i974.Logger>(),
        gh<_i568.SigaAuthenticationUsecase>(),
      ),
    );
    gh.factory<_i885.EnrolledCoursesPageCubit>(
      () => _i885.EnrolledCoursesPageCubit(
        gh<_i650.GetEnrolledCoursesUsecase>(),
        gh<_i354.GetAcademicInfoUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i41.LoginCubit>(
      () => _i41.LoginCubit(
        gh<_i193.GetStoredCredentialsUseCase>(),
        gh<_i365.SignInUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i504.GetProgramCurriculumProgressUsecase>(
      () => _i504.GetProgramCurriculumProgressUsecase(
        gh<_i889.ProgramCurriculumRepository>(),
        gh<_i354.GetAcademicInfoUseCase>(),
        gh<_i650.GetEnrolledCoursesUsecase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i722.HomePageCubit>(
      () => _i722.HomePageCubit(gh<_i48.SignOutUseCase>(), gh<_i974.Logger>()),
    );
    gh.factoryAsync<_i1059.GradeTrackerSectionCubit>(
      () async => _i1059.GradeTrackerSectionCubit(
        await getAsync<_i409.GetGradeTrackingUseCase>(),
        await getAsync<_i733.CreateGradeTrackingUseCase>(),
        await getAsync<_i362.DeleteGradeTrackingUseCase>(),
        await getAsync<_i1033.ManageGradeTrackingCategoriesUseCase>(),
        await getAsync<_i811.ManageGradeTrackingGradesUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i112.CareerPageCubit>(
      () => _i112.CareerPageCubit(
        gh<_i504.GetProgramCurriculumProgressUsecase>(),
        gh<_i354.GetAcademicInfoUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i799.RegisterModule {}
