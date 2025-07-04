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
import 'package:sigapp/auth/application/usecases/authenticate_usecase.dart'
    as _i738;
import 'package:sigapp/auth/application/usecases/get_stored_credentials_usecase.dart'
    as _i193;
import 'package:sigapp/auth/application/usecases/keep_session_alive_usecase.dart'
    as _i908;
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
import 'package:sigapp/core/infrastructure/database/sqlite_client_manager.dart'
    as _i139;
import 'package:sigapp/core/infrastructure/http/api_gateway_client.dart'
    as _i200;
import 'package:sigapp/core/infrastructure/http/regeva_client.dart' as _i986;
import 'package:sigapp/core/infrastructure/http/siga_client.dart' as _i857;
import 'package:sigapp/core/infrastructure/ui/not_used_pages/schedule_page/partials/export_to_calendar_cubit.dart'
    as _i893;
import 'package:sigapp/core/infrastructure/ui/utils/mail_utils.dart' as _i382;
import 'package:sigapp/core/injection/register_module.dart' as _i799;
import 'package:sigapp/courses/application/repositories/student_session_repository.dart'
    as _i6;
import 'package:sigapp/courses/application/usecases/get_class_schedule_usecase.dart'
    as _i315;
import 'package:sigapp/courses/application/usecases/get_course_grade_usecase.dart'
    as _i504;
import 'package:sigapp/courses/application/usecases/get_enrolled_courses_usecase.dart'
    as _i650;
import 'package:sigapp/courses/application/usecases/get_program_curriculum_progress_usecase.dart'
    as _i504;
import 'package:sigapp/courses/application/usecases/get_scheduled_courses_usecase.dart'
    as _i154;
import 'package:sigapp/courses/application/usecases/get_syllabus_file_usecase.dart'
    as _i445;
import 'package:sigapp/courses/application/usecases/grade_tracking_usecases.dart'
    as _i947;
import 'package:sigapp/courses/domain/repositories/courses_repository.dart'
    as _i986;
import 'package:sigapp/courses/domain/repositories/grade_tracking_repository.dart'
    as _i259;
import 'package:sigapp/courses/domain/repositories/local_syllabus_repository.dart'
    as _i504;
import 'package:sigapp/courses/domain/repositories/program_curriculum_repository.dart'
    as _i889;
import 'package:sigapp/courses/domain/repositories/regeva_repository.dart'
    as _i348;
import 'package:sigapp/courses/domain/repositories/schedule_repository.dart'
    as _i974;
import 'package:sigapp/courses/domain/services/course_service.dart' as _i906;
import 'package:sigapp/courses/infrastructure/pages/career/career_page_cubit.dart'
    as _i112;
import 'package:sigapp/courses/infrastructure/pages/course_detail/course_detail_cubit.dart'
    as _i215;
import 'package:sigapp/courses/infrastructure/pages/course_detail/partials/grade_tracker_section_cubit.dart'
    as _i1059;
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/enrolled_courses_page_cubit.dart'
    as _i885;
import 'package:sigapp/courses/infrastructure/pages/enrolled_courses/tabs/schedule_tab/schedule_share_button_cubit.dart'
    as _i880;
import 'package:sigapp/courses/infrastructure/pages/scheduled_courses/scheduled_courses_cubit.dart'
    as _i27;
import 'package:sigapp/courses/infrastructure/repositories/courses_repository.dart'
    as _i892;
import 'package:sigapp/courses/infrastructure/repositories/grade_tracking_repository.dart'
    as _i4;
import 'package:sigapp/courses/infrastructure/repositories/local_syllabus_repository.dart'
    as _i717;
import 'package:sigapp/courses/infrastructure/repositories/program_curriculum_repository.dart'
    as _i654;
import 'package:sigapp/courses/infrastructure/repositories/regeva_repository.dart'
    as _i75;
import 'package:sigapp/courses/infrastructure/repositories/schedule_repository.dart'
    as _i637;
import 'package:sigapp/courses/infrastructure/repositories/student_session_repository.dart'
    as _i79;
import 'package:sigapp/shared/domain/service/progress_indicator_service.dart'
    as _i151;
import 'package:sigapp/shared/infrastructure/overlays/progress_indicator_bloc.dart'
    as _i675;
import 'package:sigapp/shared/infrastructure/pages/home_page_cubit.dart'
    as _i722;
import 'package:sigapp/shared/infrastructure/partials/user_avatar_button_cubit.dart'
    as _i259;
import 'package:sigapp/shared/infrastructure/services/progress_indicator_service.dart'
    as _i856;
import 'package:sigapp/student/application/usecases/get_academic_info_usecase.dart'
    as _i97;
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
    gh.singleton<_i139.SQLiteClientManager>(
      () => _i139.SQLiteClientManager(gh<_i974.Logger>()),
    );
    gh.singleton<_i200.ApiGatewayClient>(
      () => _i200.ApiGatewayClient(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i465.AsyncOperationGuard>(
      () => _i465.AsyncOperationGuard(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i382.MailUtils>(
      () => _i382.MailUtils(gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i97.GetAcademicInfoUseCase>(
      () => _i866.CachedGetAcademicInfoUseCase(
        gh<_i97.GetAcademicInfoUseCase>(
          instanceName: 'getAcademicInfoUseCaseImpl',
        ),
      ),
    );
    gh.singleton<_i986.RegevaClient>(
      () =>
          _i986.RegevaClient(gh<_i460.SharedPreferences>(), gh<_i974.Logger>()),
    );
    gh.singleton<_i857.SigaClient>(
      () => _i857.SigaClient(gh<_i460.SharedPreferences>(), gh<_i974.Logger>()),
    );
    gh.lazySingleton<_i6.StudentSessionRepository>(
      () => _i79.StudentSessionRepositoryImpl(gh<_i857.SigaClient>()),
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
    gh.lazySingleton<_i889.ProgramCurriculumRepository>(
      () => _i654.ProgramCurriculumRepositoryImpl(gh<_i857.SigaClient>()),
    );
    gh.singleton<_i10.AuthRepository>(
      () => _i127.AuthRepositoryImpl(gh<_i857.SigaClient>()),
    );
    gh.lazySingleton<_i259.GradeTrackingRepository>(
      () => _i4.GradeTrackingRepositoryImpl(
        gh<_i200.ApiGatewayClient>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i151.StudentPageViewCubit>(
      () => _i151.StudentPageViewCubit(
        gh<_i97.GetAcademicInfoUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i348.RegevaRepository>(
      () => _i75.RegevaRepositoryImpl(gh<_i986.RegevaClient>()),
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
    gh.factory<_i893.ExportToCalendarCubit>(
      () => _i893.ExportToCalendarCubit(
        gh<_i315.GetClassScheduleUsecase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i908.KeepSessionAliveUsecase>(
      () => _i908.KeepSessionAliveUsecase(gh<_i10.AuthRepository>()),
    );
    gh.lazySingleton<_i154.GetScheduledCoursesUsecase>(
      () => _i154.GetScheduledCoursesUsecase(gh<_i986.CoursesRepository>()),
    );
    gh.factory<_i27.ScheduledCoursesPageCubit>(
      () => _i27.ScheduledCoursesPageCubit(
        gh<_i154.GetScheduledCoursesUsecase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i445.GetSyllabusFileUsecase>(
      () => _i445.GetSyllabusFileUsecase(
        gh<_i348.RegevaRepository>(),
        gh<_i6.StudentSessionRepository>(),
        gh<_i504.LocalSyllabusRepository>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i771.GetAcademicReportUsecase>(
      () => _i771.GetAcademicReportUsecase(
        gh<_i594.StudentRepository>(),
        gh<_i6.StudentSessionRepository>(),
      ),
    );
    gh.lazySingleton<_i947.GradeTrackingUseCases>(
      () => _i947.GradeTrackingUseCases(
        gh<_i259.GradeTrackingRepository>(),
        gh<_i6.StudentSessionRepository>(),
      ),
    );
    gh.factory<_i1059.GradeTrackerSectionCubit>(
      () => _i1059.GradeTrackerSectionCubit(
        gh<_i947.GradeTrackingUseCases>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i650.GetEnrolledCoursesUsecase>(
      () => _i650.GetEnrolledCoursesUsecase(
        gh<_i986.CoursesRepository>(),
        gh<_i315.GetClassScheduleUsecase>(),
      ),
    );
    gh.lazySingleton<_i504.GetCourseGradeUsecase>(
      () => _i504.GetCourseGradeUsecase(
        gh<_i6.StudentSessionRepository>(),
        gh<_i348.RegevaRepository>(),
      ),
    );
    gh.factory<_i738.AuthenticateUsecase>(
      () => _i738.AuthenticateUsecase(
        gh<_i10.AuthRepository>(),
        gh<_i679.SessionLifecycleService>(),
      ),
    );
    gh.singleton<_i248.GetAcademicInfoUseCaseImpl>(
      () => _i248.GetAcademicInfoUseCaseImpl(
        gh<_i771.GetAcademicReportUsecase>(),
        gh<_i650.GetEnrolledCoursesUsecase>(),
        gh<_i6.StudentSessionRepository>(),
      ),
      instanceName: 'getAcademicInfoUseCaseImpl',
    );
    gh.factory<_i215.CourseDetailCubit>(
      () => _i215.CourseDetailCubit(
        gh<_i445.GetSyllabusFileUsecase>(),
        gh<_i504.GetCourseGradeUsecase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.singleton<_i528.NavigationService>(
      () => _i561.NavigationServiceImpl(gh<_i583.GoRouter>()),
    );
    gh.factory<_i885.EnrolledCoursesPageCubit>(
      () => _i885.EnrolledCoursesPageCubit(
        gh<_i650.GetEnrolledCoursesUsecase>(),
        gh<_i97.GetAcademicInfoUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.lazySingleton<_i504.GetProgramCurriculumProgressUsecase>(
      () => _i504.GetProgramCurriculumProgressUsecase(
        gh<_i889.ProgramCurriculumRepository>(),
        gh<_i97.GetAcademicInfoUseCase>(),
        gh<_i650.GetEnrolledCoursesUsecase>(),
        gh<_i974.Logger>(),
      ),
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
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i259.UserAvatarButtonCubit>(
      () => _i259.UserAvatarButtonCubit(
        gh<_i97.GetAcademicInfoUseCase>(),
        gh<_i48.SignOutUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.singleton<_i767.AuthenticationManager>(
      () => _i767.AuthenticationManager(
        gh<_i679.SessionLifecycleService>(),
        gh<_i193.GetStoredCredentialsUseCase>(),
        gh<_i48.SignOutUseCase>(),
        gh<_i908.KeepSessionAliveUsecase>(),
        gh<_i738.AuthenticateUsecase>(),
        gh<_i873.ToastService>(),
        gh<_i974.Logger>(),
      ),
      dispose: (i) => i.dispose(),
    );
    gh.factory<_i722.HomePageCubit>(
      () => _i722.HomePageCubit(gh<_i48.SignOutUseCase>(), gh<_i974.Logger>()),
    );
    gh.factory<_i112.CareerPageCubit>(
      () => _i112.CareerPageCubit(
        gh<_i504.GetProgramCurriculumProgressUsecase>(),
        gh<_i97.GetAcademicInfoUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    gh.factory<_i365.SignInUseCase>(
      () => _i365.SignInUseCase(
        gh<_i1010.SharedPreferencesAuthRepository>(),
        gh<_i391.ApiGatewayAuthService>(),
        gh<_i528.NavigationService>(),
        gh<_i97.GetAcademicInfoUseCase>(),
        gh<_i974.Logger>(),
        gh<_i738.AuthenticateUsecase>(),
      ),
    );
    gh.factory<_i41.LoginCubit>(
      () => _i41.LoginCubit(
        gh<_i193.GetStoredCredentialsUseCase>(),
        gh<_i365.SignInUseCase>(),
        gh<_i974.Logger>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i799.RegisterModule {}
