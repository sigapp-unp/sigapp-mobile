import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:sigapp/shared/infrastructure/overlays/progress_indicator_bloc.dart';
import 'package:sigapp/shared/infrastructure/overlays/progress_indicator_overlay.dart';
import 'package:sigapp/core/infrastructure/ui/theme/brand_theme.dart';
import 'package:sigapp/core/infrastructure/services/update_service.dart';
import 'package:toastification/toastification.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Check for app updates when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<UpdateService>().checkForUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<ProgressIndicatorBloc>()),
      ],
      child: ToastificationWrapper(
        child: MaterialApp.router(
          builder: (context, child) {
            return BlocBuilder<ProgressIndicatorBloc, ProgressIndicatorState>(
              builder: (context, state) {
                if (state is ProgressIndicatorHidden) return child!;
                return Overlay(
                  initialEntries: [
                    OverlayEntry(
                      builder:
                          (context) => Stack(
                            children: [
                              child!,
                              Positioned.fill(
                                child: ProgressIndicatorOverlayWidget(),
                              ),
                            ],
                          ),
                    ),
                  ],
                );
              },
            );
          },
          routerConfig: getIt<GoRouter>(),
          themeMode: ThemeMode.system,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: BrandTheme.primaryColor,
              primary: BrandTheme.primaryColor,
              secondary: BrandTheme.secondaryColor,
              brightness: Brightness.light,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: BrandTheme.primaryColorDark,
              primary: BrandTheme.primaryColorDark,
              // secondary: BrandTheme.secondaryColorDark,
              secondary: BrandTheme.secondaryColor,
              brightness: Brightness.dark,
            ),
          ),
        ),
      ),
    );
  }
}
