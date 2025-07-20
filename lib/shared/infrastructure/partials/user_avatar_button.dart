import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:sigapp/core/injection/get_it.dart';
import 'package:sigapp/shared/infrastructure/partials/user_avatar_button/general_alert_dialog.dart';
import 'package:sigapp/shared/infrastructure/partials/user_avatar_button_cubit.dart';
import 'package:sigapp/core/infrastructure/ui/widgets/initials_avatar.dart';
import 'package:sigapp/shared/infrastructure/utils/logo_file_utils.dart';

class UserAvatarButtonWidget extends StatelessWidget {
  const UserAvatarButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<UserAvatarButtonCubit>(),
      child: BlocBuilder<UserAvatarButtonCubit, UserAvatarButtonState>(
        builder: (context, state) {
          return switch (state) {
            UserAvatarButtonInitialState() => () {
              BlocProvider.of<UserAvatarButtonCubit>(context).init();
              return _buildCircularProgressIndicator();
            }(),
            UserAvatarButtonLoadingState() => _buildCircularProgressIndicator(),
            UserAvatarButtonSuccessState() => _build(context, state),
            UserAvatarButtonErrorState() => _build(context, state),
          };
        },
      ),
    );
  }

  Widget _buildCircularProgressIndicator() {
    return const SizedBox(
      height: 32,
      width: 32,
      child: CircularProgressIndicator(),
    );
  }

  Widget _build(BuildContext context, UserAvatarButtonState state) {
    final faculty = switch (state) {
      UserAvatarButtonSuccessState(:final data) => data.academicReport.faculty,
      _ => null,
    };

    final userData = _extractUserData(state);
    final cubit = BlocProvider.of<UserAvatarButtonCubit>(context);

    if (faculty != null) {
      final imageFilePath = getFacultyImagePath(faculty);
      return _buildAvatar(
        context: context,
        imageFilePath: imageFilePath,
        initials: null,
        userData: userData,
        cubit: cubit,
      );
    }

    return _buildAvatar(
      context: context,
      imageFilePath: null,
      initials: userData.initials,
      userData: userData,
      cubit: cubit,
    );
  }

  _UserData _extractUserData(UserAvatarButtonState state) {
    var initials = '?';
    var fullName = 'Desconocido';
    var id = 'Desconocido';
    String? errorMessage;

    switch (state) {
      case UserAvatarButtonSuccessState():
        id = state.data.academicReport.code;
        errorMessage = state.errorMessage;

        final firstName = state.data.academicReport.firstName;
        final lastName = state.data.academicReport.lastName;
        fullName = '$firstName $lastName';

        if (firstName.trim().isEmpty || lastName.trim().isEmpty) {
          getIt<Logger>().d(
            'Student with empty name - firstName: "$firstName", lastName: "$lastName", code: ${state.data.academicReport.code}',
          );
        }

        initials =
            fullName
                .split(' ')
                .map((w) => w.trim())
                .where((w) => w.isNotEmpty)
                .map((w) => w.characters.first.toUpperCase())
                .take(2)
                .join();

        // Fallback if no valid initials found
        if (initials.isEmpty) {
          initials = '?';
        }
        break;
      case UserAvatarButtonErrorState():
        if (state.error != null) {
          errorMessage = state.error.toString();
        }
        break;
      default:
        break;
    }

    return _UserData(
      initials: initials,
      fullName: fullName,
      id: id,
      errorMessage: errorMessage,
    );
  }

  Widget _buildAvatar({
    required BuildContext context,
    required String? imageFilePath,
    required String? initials,
    required _UserData userData,
    required UserAvatarButtonCubit cubit,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    // Si tenemos una ruta de imagen, creamos un avatar con imagen
    if (imageFilePath != null) {
      return AvatarCircleWidget(
        imageFilePath: imageFilePath,
        fallbackContent: null,
        backgroundColor: primaryColor,
        onTap:
            () => _showAvatarDialog(
              context: context,
              imageFilePath: imageFilePath,
              initials: null,
              userData: userData,
              cubit: cubit,
            ),
      );
    }

    // Si no tenemos imagen, creamos un avatar con iniciales
    return InitialsAvatarWidget(
      backgroundColor: primaryColor,
      content: initials ?? '?',
      enableGradient: true,
      onPressed:
          () => _showAvatarDialog(
            context: context,
            imageFilePath: null,
            initials: initials,
            userData: userData,
            cubit: cubit,
          ),
    );
  }

  void _showAvatarDialog({
    required BuildContext context,
    required String? imageFilePath,
    required String? initials,
    required _UserData userData,
    required UserAvatarButtonCubit cubit,
  }) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GeneralAvatarDialog(
          avatar: AvatarCircleWidget(
            imageFilePath: imageFilePath,
            fallbackContent: initials,
            backgroundColor: primaryColor,
          ),
          userFullName: userData.fullName,
          userId: userData.id,
          errorMessage: userData.errorMessage,
          onSignOut: () {
            Navigator.of(context).pop();
            cubit.signOut();
          },
        );
      },
    );
  }
}

class _UserData {
  final String initials;
  final String fullName;
  final String id;
  final String? errorMessage;

  _UserData({
    required this.initials,
    required this.fullName,
    required this.id,
    this.errorMessage,
  });
}
