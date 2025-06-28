import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:sigapp/auth/application/usecases/get_stored_credentials_usecase.dart';
import 'package:sigapp/auth/infrastructure/pages/login_cubit.dart';
import 'package:sigapp/auth/infrastructure/pages/login_page.dart';
import 'package:sigapp/shared/infrastructure/pages/about_page.dart';
import 'package:sigapp/shared/infrastructure/pages/home_page.dart';
import 'package:sigapp/shared/infrastructure/pages/home_page_cubit.dart';

class RouterBuilder {
  static GoRouter build(
    GetStoredCredentialsUseCase getStoredCredentialsUseCase,
    // RouterRefreshListenable refreshListenable,
  ) {
    final router = GoRouter(
      // refreshListenable: refreshListenable,
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/login',
          builder:
              (context, state) => BlocProvider(
                create: (context) => getIt<LoginCubit>(),
                child: LoginPage(),
              ),
        ),
        GoRoute(
          path: '/',
          builder:
              (context, state) => BlocProvider(
                create: (context) => getIt<HomePageCubit>(),
                child: const HomePageWidget(),
              ),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutPageWidget(),
        ),
      ],
      redirect: (context, state) async {
        final credentials = getStoredCredentialsUseCase.execute();
        if (!credentials.hasCredentials) {
          return '/login';
        }
        return null;
      },
      errorPageBuilder:
          (context, state) => const MaterialPage(
            child: Scaffold(body: Center(child: Text('Page not found'))),
          ),
    );
    return router;
  }
}
